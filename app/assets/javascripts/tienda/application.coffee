#= require jquery
#= require jquery_ujs

$ ->
  # Clear modal div after closing them
  $('body').on 'hidden.bs.modal', '.modal', ->
    $(this).removeData 'bs.modal'
    return

  # New Stock Level AJAX Callback function
  $('.tienda_products_index, .tienda_variants_index').on('ajax:success', '#new_stock_level_adjustment', (e, data, status, xhr) ->
    quantity = parseInt($(this).find('#stock_level_adjustment_adjustment').val())
    product = $(this).find('#item_id').val()
    stock_label = $('a.btn-sm[href*=' + product + ']').closest('td').find('b');
    old_quantity = parseInt(stock_label.text())
    $('#stockModal').modal('hide')
    if isNaN(old_quantity)
      stock_label.text quantity
    else
      stock_label.text quantity + old_quantity

    return
  ).on 'ajax:error', (e, xhr, status, error) ->
    console.log(xhr)
    $(this).find('#stockModal .alert-danger').removeClass('hidden').text(xhr.responseText)
    return

  $('#main-menu').metisMenu()

  $(window).bind 'load resize', ->
    if $(this).width() < 768
      $('div.sidebar-collapse').addClass 'collapse'
    else
      $('div.sidebar-collapse').removeClass 'collapse'
    return

  # When clicking the order search button, toggle the form
  $('a[rel=searchOrders]').on 'click', ->
    $('div.search-orders').toggleClass('hide')

  return
# $ ->
#
#   # Automatically focus all fields with the 'focus' class
#   $('input.focus').focus()
#
#   # Add a new attribute to a table
#   $('a[data-behavior=addAttributeToAttributesTable]').on 'click', ->
#     table = $('table.productAttributes')
#     if $('tbody tr', table).length == 1 || $('tbody tr:last td:first input', table).val().length > 0
#       template = $('tr.template', table).html()
#       table.append("<tr>#{template}</tr>")
#     false
#
#   # Remove an attribute from a table
#   $('table.productAttributes tbody').on 'click', 'tr td.remove a', ->
#     $(this).parents('tr').remove()
#     false
#
#   # Sorting on the product attribtues table
#   $('table.productAttributes tbody').sortable
#     axis: 'y'
#     handle: '.handle'
#     cursor: 'move',
#     helper: (e,tr)->
#       originals = tr.children()
#       helper = tr.clone()
#       helper.children().each (index)->
#         $(this).width(originals.eq(index).width())
#       helper
#
#   # Chosen
#   $('select.chosen').chosen()
#   $('select.chosen-with-deselect').chosen({allow_single_deselect: true})
#   $('select.chosen-basic').chosen({disable_search_threshold:100})
#
#   # Printables
#   $('a[rel=print]').on 'click', ->
#     window.open($(this).attr('href'), 'despatchnote', 'width=700,height=800')
#     false
#
#   # Close dialog
#   $('body').on 'click', 'a[rel=closeDialog]', Nifty.Dialog.closeTopDialog
#
#   # Open AJAX dialogs
#   $('a[rel=dialog]').on 'click', ->
#     element = $(this)
#     options = {}
#     options.width = element.data('dialog-width') if element.data('dialog-width')
#     options.offset = element.data('dialog-offset') if element.data('dialog-offset')
#     options.behavior = element.data('dialog-behavior') if element.data('dialog-behavior')
#     options.id = 'ajax'
#     options.url = element.attr('href')
#     Nifty.Dialog.open(options)
#     false
#
#   # Format money values to 2 decimal places
#   $('div.moneyInput input').each formatMoneyField
#   $('body').on('blur', 'div.moneyInput input', formatMoneyField)
#
# #
# # Format money values to 2 decimal places
# #
# window.formatMoneyField = ->
#   value = $(this).val().replace /,/, ""
#   $(this).val(parseFloat(value).toFixed(2)) if value.length
#
# #
# # Stock Level Adjustment dialog beavior
# #
# Nifty.Dialog.addBehavior
#   name: 'stockLevelAdjustments'
#   onLoad: (dialog,options)->
#     $('input[type=text]:first', dialog).focus()
#     $(dialog).on 'submit', 'form', ->
#       form = $(this)
#       $.ajax
#         url: form.attr('action')
#         method: 'POST'
#         data: form.serialize()
#         dataType: 'text'
#         success: (data)->
#           $('div.table', dialog).replaceWith(data)
#           $('input[type=text]:first', dialog).focus()
#         error: (xhr)->
#           if xhr.status == 422
#             alert xhr.responseText
#           else
#             alert 'An error occurred while saving the stock level.'
#       false
#     $(dialog).on 'click', 'nav.pagination a', ->
#       $.ajax
#         url: $(this).attr('href')
#         success: (data)->
#           $('div.table', dialog).replaceWith(data)
#       false
#
# #
# # Always fire keyboard shortcuts when focused on fields
# #
# Mousetrap.stopCallback = -> false
#
# #
# # Close dialogs on escape
# #
# Mousetrap.bind 'escape', ->
#   Nifty.Dialog.closeTopDialog()
#   false
