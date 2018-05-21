function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

X = [ones(m, 1) X];

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



%Feedforward to return cost J
loop_sum = 0;
y;
for i = 1:m 
	a2 = [1 sigmoid(X(i,:) * Theta1')];
	a3 = sigmoid(a2 * Theta2');
	current_y = zeros(1, num_labels);
	current_y(1,y(i,1)) = 1;
	loop_sum = loop_sum + sum((-current_y*log(a3')))-((1.-current_y)*log(1.-(a3)'));

end
J = loop_sum/m;
use_theta1 = Theta1(:, 2:end);
use_theta2 = Theta2(:, 2:end);

J = J +  ((lambda*((sum(sum(use_theta1.^2))) + (sum(sum(use_theta2.^2)))))/(2*m));



%backpropagation step
big_delta_1 = 0;
big_delta_2 = 0;
for i = 1:m 
	a1 = X(i,:);
	a2 = [1 sigmoid(X(i,:) * Theta1')];
	a3 = sigmoid(a2 * Theta2');
	current_y = zeros(1, num_labels);
	current_y(1,y(i,1)) = 1;
	delta3 = a3 - current_y;
	z2 = a1 * Theta1';
	delta2 = (delta3*Theta2).*([0 sigmoidGradient(z2)]);
	delta2 = delta2';
	delta2 = delta2(2:end);
	big_delta_1 = big_delta_1 + (delta2 * a1);
	big_delta_2 = big_delta_2 + (delta3' * a2);
	size(big_delta_1);
	size(big_delta_2);



Theta1_grad = (big_delta_1./m) + ((lambda*[zeros(size(big_delta_1, 1), 1) Theta1(:, 2:end)])/m);
Theta2_grad = (big_delta_2./m) + ((lambda*[zeros(size(big_delta_2, 1), 1) Theta2(:, 2:end)])/m);




% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
