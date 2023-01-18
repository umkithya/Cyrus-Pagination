# Cyrus Pagination

---

A library for easily displaying paginated data, created by Um Kithya.

`Cyrus Pagination` comes in handy when building features like activity feeds, news feeds, or anywhere else where you need to lazily fetch and render content for users to consume.

## Example

<table>
  <tr>
    <td><img src="https://raw.githubusercontent.com/umkithya/Cyrus-Pagination/master/demo/list-pagination.gif" height="400"/></td>
     <td><img src="https://github.com/umkithya/Cyrus-Pagination/blob/master/demo/grid-pagination.gif?raw=true" height="400"/></td>
  </tr>
 
</table>


## Usage for List

A basic implementation requires four parameters:

- An `onRefresh` that is refresh function call when pull to refresh like refresh indicator.
- A `widget` that is item child widget.
- A `fetchData` that is an function to fetch api.
- An `itemList` that is a list of item.
- A `loading` that is variable for loading state.
- A `page` that is variable for page number state.
- An `hasMoreData` that is variable its true when data has more.
- An `end` that is variable its true when page equals total page.

## Example Simple

```dart
CyrusPagination<PassagerModel>(
        onRefresh: () async {
          setState(() {
            page = 1;
            end = false;
          });
          await fetchApi();
        },
        loading: loading,
        itemList: passagerList,
        page: page,
        end: end,
        fetchData: () => fetchApi(),
        widget: (data, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomCard(
            description: data.name,
            title: "$index",
          ),
        ),
        hasMoreData: isMoreData,
      ),
```

## Example Grid

```dart
CyrusPagination<PassagerModel>(
        isGridView: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 3 / 4.5,
        ),
        onRefresh: () async {
          setState(() {
            page = 1;
            end = false;
          });
          await fetchApi();
        },
        loading: loading,
        itemList: passagerList,
        page: page,
        end: end,
        fetchData: () => fetchApi(),
        widget: (data, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomCard(
            description: data.name,
            title: "$index",
          ),
        ),
        hasMoreData: isMoreData,
      ),
```
## Copyright & License

This open source project authorized by UM KITHYA , and the license is MIT.