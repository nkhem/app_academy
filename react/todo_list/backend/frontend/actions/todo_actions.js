import * as TodoAPIUtil from '../util/todo_api_util';
import { receiveErrors } from './error_actions';

export const RECEIVE_TODOS = "RECEIVE_TODOS";
export const RECEIVE_TODO = "RECEIVE_TODO";
export const REMOVE_TODO = "REMOVE_TODO";

export const receiveTodos = todos => {
  return {
    type: RECEIVE_TODOS,
    todos: todos
  };
};

export const receiveTodo = todo => {
  return {
    type: RECEIVE_TODO,
    todo: todo
  };
};

export const removeTodo = todo => {
  return {
    type: REMOVE_TODO,
    todo: todo
  };
};

export const fetchTodos = () => dispatch => {
  return TodoAPIUtil.fetchTodos().then( todos => dispatch(receiveTodos(todos)));
};

export const createTodo = thisTodo => dispatch => {
  return TodoAPIUtil.createTodo( {todo: thisTodo} )
    .then(  newTodo => dispatch(receiveTodo(newTodo)),
            error => dispatch(receiveErrors(error.responseJSON))
    );
};
