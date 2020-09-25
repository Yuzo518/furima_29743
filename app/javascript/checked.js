document.addEventListener("turbolinks:load", function(){
  /** 使用する要素の宣言 **/
  /* 商品価格valueの値を取得し,input_valueに格納する */
  const value_id = document.getElementById("item-price");
  /* 販売手数料のid:add-tax-priceから要素の取得*/
  const tax_id = document.getElementById("add-tax-price");
  /* 販売利益のid:profitから要素の取得*/
  const profit_id = document.getElementById("profit");

  /** input_value要素に値が入力されたときにイベントを発火させる **/
  value_id.addEventListener("input", () => {
    let item_value = value_id.value;
    /*価格が数字かどうかの判断 */
    if (!Number.isNaN(item_value)) {
      /* HTMLに手数料と販売利益に計算した値を表示する*/
      tax_id.innerHTML = Math.floor(item_value * 0.1);
      profit_id.innerHTML = Math.floor(item_value * 0.9);
    }else{
      /* HTMLに手数料と販売利益にNaNを表示する*/
      tax_id.innerHTML = "NaN";
      profit_id.innerHTML = "NaN";
    }
  });
})