require("select2");

const form = $("form.role-switcher");
const formDropdowns = form.find(".dropdown-autocomplete");
formDropdowns.select2();
formDropdowns.on("select2:select", () => {
   form.submit();
});