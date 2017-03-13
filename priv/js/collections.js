App.Collection.Contacts = Backbone.Collection.extend({
	model: App.Models.Contacts,
	urlRoot: '/contacts'
});