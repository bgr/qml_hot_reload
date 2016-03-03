.pragma library


function toArray(listModel) {
    /* Returns regular javascript array from given ListModel.
     * Useful for further using Array functions like map, filter, etc.
     */
    var res = [];
    for (var i=0; i < listModel.count; i++) {
        res.push(listModel.get(i));
    }
    return res;
}
