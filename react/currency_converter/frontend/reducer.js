import { SWITCH_CURRENCY } from './actions';

const initialState = {
  baseCurrency: "Please select",
  rates: {}
};

const reducer = (state = initialState, action) => {
  switch(action.type) {
    case SWITCH_CURRENCY:
      return {
        baseCurrency: action.baseCurrency,
        rates: action.rates
      };
    default:
      return state;
  }
};
window.reducer = reducer;

export default reducer;
