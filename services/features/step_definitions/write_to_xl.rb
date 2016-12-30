After do |scenario|
	# if scenario.failed?
	#req_header = ActiveSupport::JSON.decode(@req_header.to_s)
	req_header = JSON.pretty_generate @req_header rescue @req_header.to_s
	act_resp = ActiveSupport::JSON.decode(@act_resp) rescue @act_resp
	act_resp = JSON.pretty_generate act_resp rescue act_resp
	@failing_error = scenario.exception.to_s if (!@failing_error || @failing_error.empty?) && scenario.exception
	payload = ActiveSupport::JSON.decode(@req_param) rescue @req_param
	payload = JSON.pretty_generate payload rescue @req_param
	expected_resp = ActiveSupport::JSON.decode(@resp_param) rescue @resp_param
	expected_resp = JSON.pretty_generate expected_resp rescue expected_resp
	result = scenario.failed? ? "Fail" : "Pass"
	resp_too_long = act_resp.length > 32001 rescue false
	act_resp = resp_too_long ? act_resp[0..32000] : act_resp
	note = resp_too_long ? 'complete response is too long, only first part is available' : ''
	$act_resp_data_val.push [@row_id, @test_element, @scenario, result, Time.now.to_s, @url, @request_type, req_header, payload, expected_resp, act_resp, @exp_header, @act_resp_headers.to_s, @response_time, @exp_code, @act_code, @failing_error, note]
	# end
end

Before do
	if $act_resp_data_val.nil?
		$act_resp_data_val =[["ID", "Element", "Scenario", "Result", "Date/Time", "URL", "Method", "Headers", "Payload", "Expected Response", "Actual Response", "Expected Headers", "Actual Headers", "Time(s)", "Exp Code", "Act Code", "Issue", "Note"]]
	end
end

at_exit do
	book = Spreadsheet::Workbook.new
	sheet1 = book.create_worksheet
	for i in 0..$act_resp_data_val.length - 1
		sheet1.row(i).push i, *$act_resp_data_val[i]
	end
	@myRoot = File.join(File.dirname(__FILE__), '/')
	`mkdir #{@myRoot}../../awetest_report`
	puts "#{@myRoot}../../awetest_report/#{$data_changes_for}_#{Time.now.strftime "%d_%m_%H_%M_%S"}_.xls"
	book.write "#{@myRoot}../../awetest_report/#{$data_changes_for}_#{Time.now.strftime "%d_%m_%H_%M_%S"}_.xls"
	# Create Html Report
	html_string = ''
	html_string << get_html_header_string
	for i in 1..$act_resp_data_val.length - 1
		html_string << write_each_line_to_report($act_resp_data_val[i], i)
	end
	html_string << get_html_footer_string
	File.open("#{@myRoot}../../awetest_report/#{$data_changes_for}_#{Time.now.strftime "%d_%m_%H_%M_%S"}_.html", 'w') { |file| file.write(html_string) }
end

def get_html_header_string
	return '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>

    <link href="style.css" rel="stylesheet"/>

    <script   src="https://code.jquery.com/jquery-3.1.1.min.js"   integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="   crossorigin="anonymous"></script>
    <script type="text/javascript">
			$(document).ready(function() {

					//Hide show expanded block
					$(".expand-button").click(function() {
							var targetEl = $(this).attr("data-target");

							if(targetEl == "all") {
									if(isAllClosed(".inner-table-wrapper")) {
											$(".inner-table-wrapper").removeClass("hide");
											$(".expand-button").removeClass("closed");
									} else {
											$(".inner-table-wrapper").addClass("hide");
											$(".expand-button").addClass("closed");
									}
							} else {
									$(targetEl).find(".inner-table-wrapper").toggleClass("hide");
									$(this).toggleClass("closed");
							}
					});

					function isAllClosed(elem) {
							var result = true;
							$(elem).each(function(index, current) {
									if(!$(current).hasClass("hide")) result = false;
							});
							return result;
					}
			});
</script>

</head>
<body>
    <div class="left-tab"></div>
    <div class="wrapper">
        <div class="content">
            <div class="row">
                <div class="gl_page_inner">
                    <div class="design-body">
                        <div class="information-table">
                            <div class="table-control-row">
                                <p class="active left-control expand-button closed" data-target="all">EXPAND ALL</p>
                                <p class="right-control active">ALL</p>
                                <p class="right-control">ERRORS</p>
                                <p class="right-control">SHOW</p>
                            </div>

                            <table class="inf-table">
                                <thead class="table-head">
                                <tr>
                                    <th width="39">#</th>
                                    <th width="80">ID</th>
                                    <th width="121">URL</th>
                                    <th width="230">Scenario</th>
                                    <th width="96">Date/Time</th>
                                    <th width="67">Method</th>
                                    <th width="90">Duration</th>
                                    <th width="86">Exp Code</th>
                                    <th width="86">Actual Code</th>
                                    <th width="88">Result</th>
                                </tr>
                                </thead>

                                <tbody>'
end

def write_each_line_to_report (report_line, i)
	result_string = "<tr>
                                    <td width='39' class='expand-button closed' data-target='.expand-#{i}'>#{i}</td>
                                    <td width='80'>#{i}</td>
                                    <td width='121'><a href='#{report_line[5]}' class='table-link'>#{report_line[5]}</a></td>
                                    <td width='235'>#{report_line[0]}</td>
                                    <td width='96'>#{report_line[4]}</td>
                                    <td width='67'>#{report_line[6]}</td>
                                    <td width='90'>#{report_line[13]}</td>
                                    <td width='86'>#{report_line[14]}</td>
                                    <td width='86'>#{report_line[15]}</td>"

	if report_line[3] == 'Pass'
		result_string << "<td width='90' class='result-pass'><span class='sprite sprite-i-passed-green'></span>#{report_line[3]}</td>"
	else
		result_string << "<td width='90' class='result-fail'><span class='sprite sprite-i-failed-red'></span>#{report_line[3]}</td>"
	end
	result_string << "</tr>
                                <tr class='expand-row expand-#{i}'>
                                    <td class='no-padding no-border' colspan='10'>
                                        <div class='inner-table-wrapper hide'>
                                            <table class='inf-table'>
                                                <tr>
                                                    <th>Request</th>
                                                    <th>Expected Response</th>
                                                    <th>Actual Response</th>
                                                </tr>"
	if report_line[3] == 'Pass'
	else
		result_string << "<tr>
												<td class='error-row' colspan='3'>Error: TODO</td>
                                                </tr>"
	end
	result_string << "<tr>
                                                    <td>Headers<br>#{report_line[7]}</td>
                                                    <td>Expected Headers<br>#{report_line[11]}</td>
                                                    <td>Actual Headers<br>#{report_line[12]}</td>
                                                </tr>
                                                <tr>
                                                    <td>Payload<br>#{report_line[8]}</td>
                                                    <td>Expected Response<br>#{report_line[9]}</td>
                                                    <td>Actual Response<br>#{report_line[10]}</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>"
	return result_string
end

def get_html_footer_string
	return "
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>"
end