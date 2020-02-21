import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
       title: Text('商品分类'),
       ),
       body: Container(
         child: Row(
           children: <Widget>[
             LeftCategoryNav(),
             Column(
               children: <Widget>[
                 RightCategoryNav(),
                 CategoryGoodsList()
               ],
             )
           ],
         ),
       ),
     );
  }


}
// 左侧大类导航
class  LeftCategoryNav  extends StatefulWidget {
  @override
  _LeftCategoryNavState  createState() => _LeftCategoryNavState ();
}

class _LeftCategoryNavState  extends State<LeftCategoryNav> {
  List list = [];
  int listIndex=0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: Container(
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context,index){
              return _leftInkWell(index);
            }
        ),
      ),
    );
  }
  Widget _leftInkWell(index){
  bool isClick=(listIndex==index)?true:false;
  return InkWell(
    onTap: (){
     setState(() {
       listIndex=index;
     });
      var childList = list[index].bxMallSubDto;
      Provide.value<ChildCategory>(context).getChildCategory(childList);
    },
    child: Container(
      height: ScreenUtil().setHeight(100),
      padding: EdgeInsets.only(left: 10, top: 20),
      decoration: BoxDecoration(
          color: isClick ?Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
           border: Border(
           bottom: BorderSide(width: 1, color: Colors.black12)
       )
      ),
      child: Text(
        list[index].mallCategoryName,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    ),
  );
  }
  void _getCategory() async {
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      CategoryModel listModel=CategoryModel.fromJson(data);
      setState(() {
        list=listModel.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto);
    });
  }
}
//右侧导航栏
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
//  List list = ['名酒', '宝丰', '北京二锅头', '舍得', '五粮液', '茅台', '散白'];
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
        builder: (context,child,childCategory){
          return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: childCategory.childCategoryList.length,
                itemBuilder: (context, index) {
                  return _rightInkWell(childCategory.childCategoryList[index]);
                }),
          );
        });

  }

  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}
// 商品列表，可以上拉加载
class CategoryGoodsList  extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList > {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('111'),
    );
  }
  void _getGoodsList() async {
    var data = {'categoryId': '4', 'CategorySubId': '', 'page': 1};
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      print('分类商品列表：》》》》》》》》》》》》》》》${val}');
    });
  }
}



