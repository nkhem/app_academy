import React, { Component} from 'react';
import { connect } from 'react-redux';
import { selectBook } from '../actions/index';
import { bindActionCreators } from 'redux'; //makes sure the action generated by the action creator flows through all the reducers

class BooksList extends Component {
  renderList(){
    return this.props.books.map( book => {
      return (
        <li key={book.title} className='list-group-item'>
          {book.title}
        </li>
      );
    });
  }

  render(){
    return (
      <ul className='list-group col-cm-4'>
        { this.renderList()}
      </ul>
    );
  }
}

// whenever state changes, BooksList container will automatically rerender
function mapStateToProps(state) {
  return { books: state.books };
}

// whenever selectBook is called, the result should be passed to all of our reducers
function mapDispatchToProps(dispatch) {
  return bindActionCreators({ selectBook: selectBook }, dispatch);
} // anything returned from this funstion will end up as props on the BookList containers

//Promoste BookList from a component to a container - it needs to know about this new dispatch methos, selectBook. Make it available as a prop

export default connect(mapStateToProps, mapDispatchToProps)(BooksList);
