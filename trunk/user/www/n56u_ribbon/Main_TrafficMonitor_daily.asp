<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">

<title>ASUS Wireless Router RT-N56U - </title>

<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmmenu.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmhist.js"></script>

<script type='text/javascript'>

wan_route_x = '<% nvram_get_x("IPConnection", "wan_route_x"); %>';
wan_nat_x = '<% nvram_get_x("IPConnection", "wan_nat_x"); %>';
wan_proto = '<% nvram_get_x("Layer3Forwarding",  "wan_proto"); %>';

//	<% nvram("wan0_ifname,lan_ifname,rstats_enable"); %>
try {
//	<% bandwidth("daily"); %>
}
catch (ex) {
	daily_history = [];
}
rstats_busy = 0;
if (typeof(daily_history) == 'undefined') {
	daily_history = [];
	rstats_busy = 1;
}

function save()
{
	cookie.set('daily', scale, 31);
}

function genData()
{
	var w, i, h, t;

	w = window.open('', 'tomato_data_d');
	w.document.writeln('<pre>');
	for (i = 0; i < daily_history.length-1; ++i) {
		h = daily_history[i];
		t = getYMD(h[0]);
		w.document.writeln([t[0], t[1] + 1, t[2], h[1], h[2]].join(','));
	}
	w.document.writeln('</pre>');
	w.document.close();
}

function getYMD(n)
{
	// [y,m,d]
	return [(((n >> 16) & 0xFF) + 1900), ((n >>> 8) & 0xFF), (n & 0xFF)];
}

function redraw()
{
	var h;
	var grid;
	var rows;
	var ymd;
	var d;
	var lastt;
	var lastu, lastd;

	if (daily_history.length-1 > 0) {
		ymd = getYMD(daily_history[0][0]);
		d = new Date((new Date(ymd[0], ymd[1], ymd[2], 12, 0, 0, 0)).getTime() - ((30 - 1) * 86400000));
		E('last-dates').innerHTML = '(' + ymdText(ymd[0], ymd[1], ymd[2]) + ' ~ ' + ymdText(d.getFullYear(), d.getMonth(), d.getDate()) + ')';

		lastt = ((d.getFullYear() - 1900) << 16) | (d.getMonth() << 8) | d.getDate();
	}

	lastd = 0;
	lastu = 0;
	rows = 0;
	block = '';
	gn = 0;

	grid = '<table class="table" cellspacing="1">';
	/*grid += makeRow('header', 'Date', '<#Downlink#>', '<#Uplink#>', '<#Total#>');*/

	grid += "<tr><th width='25%' valign='top' style='text-align:left'><#Date#></th>";
	grid += "<th width='25%' style='text-align:right' valign='top'><#Downlink#></th>";
	grid += "<th width='25%' style='text-align:right' valign='top'><#Uplink#></th>";
	grid += "<th width='25%' style='text-align:right' valign='top'><#Total#></th></tr>";
	
	for (i = 0; i < daily_history.length-1; ++i) {
		h = daily_history[i];
		ymd = getYMD(h[0]);
		grid += makeRow(((rows & 1) ? 'odd' : 'even'), ymdText(ymd[0], ymd[1], ymd[2]), rescale(h[1]), rescale(h[2]), rescale(h[1] + h[2]));
		++rows;

		if (h[0] >= lastt) {
			lastd += h[1];
			lastu += h[2];
		}
	}

/*	grid += '<td style="line-height:30px">Last 30 Days<span id="last-dates"></span></td>';
	grid += '<td style="text-align:right" id="last-dn">-</td><td style="text-align:right" id="last-up">-</td><td style="text-align:right" id="last-total">-</td>';
*/	
	E('bwm-daily-grid').innerHTML = grid + '</table>';
	
	E('last-dn').innerHTML = rescale(lastd);
	E('last-up').innerHTML = rescale(lastu);
	E('last-total').innerHTML = rescale(lastu + lastd);
}

function init()
{
	var s;

	if (nvram.rstats_enable != '1') return;

	if ((s = cookie.get('daily')) != null) {
		if (s.match(/^([0-2])$/)) {
			E('scale').value = scale = RegExp.$1 * 1;
		}
	}

	initDate('ymd');
	daily_history.sort(cmpHist);
	redraw();
}

function switchPage(page){
	if(page == "1")
		location.href = "/Main_TrafficMonitor_realtime.asp";
	else if(page == "2")
		location.href = "/Main_TrafficMonitor_last24.asp";
	else
		return false;
}
</script>

<style>
    .table td.dl, .table td.ul, .table td.total {text-align: right;}
    #last-dn, #last-up, #last-total {font-weight: bold;}
</style>

</head>

<body onload="show_banner(0); show_menu(4, -1, 0); show_footer(); init();" >

<div class="container-fluid" style="padding-right: 0px">
    <div class="row-fluid">
        <div class="span2"><center><div id="logo"></div></center></div>
        <div class="span10" >
            <div id="TopBanner"></div>
        </div>
    </div>
</div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0" style="position: relative;"></iframe>
<form method="post" name="form" action="../apply.cgi" >
<input type="hidden" name="current_page" value="Main_TrafficMonitor_daily.asp">
<input type="hidden" name="next_page" value="Main_TrafficMonitor_daily.asp">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="sid_list" value="WLANConfig11b;">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("LANGUAGE", "preferred_lang"); %>">
<input type="hidden" name="wl_ssid2" value="<% nvram_get_x("WLANConfig11b",  "wl_ssid2"); %>">
<input type="hidden" name="firmver" value="<% nvram_get_x("",  "firmver"); %>">

<div class="container-fluid">
    <div class="row-fluid">
        <div class="span2">
            <!--Sidebar content-->
            <!--=====Beginning of Main Menu=====-->
            <div class="well sidebar-nav side_nav" style="padding: 0px;">
                <ul id="mainMenu" class="clearfix"></ul>
                <ul class="clearfix">
                    <li>
                        <div id="subMenu" class="accordion"></div>
                    </li>
                </ul>
            </div>
        </div>

        <div class="span10">
            <div class="row-fluid">
                <div class="span12">
                    <div class="box well grad_colour_dark_blue">
                        <h2 class="box_head round_top"><#menu4#></h2>
                        <div class="round_bottom">
                            <div id="tabMenu"></div>

                            <div align="right" style="margin: 8px 8px 0px 0px;">
                                <select onchange='changeDate(this, "ymd")' id='dafm'>
                                    <option value=0><#Date#>:</option>
                                    <option value=0>yyyy-mm-dd</option>
                                    <option value=1>mm-dd-yyyy</option>
                                    <option value=2>mmm dd, yyyy</option>
                                    <option value=3>dd.mm.yyyy</option>
                                </select>
                                <select onchange='changeScale(this)' id='scale'>
                                    <option value=0><#Scale#>:</option>
                                    <option value=0>KB</option>
                                    <option value=1>MB</option>
                                    <option value=2 selected>GB</option>
                                </select>
                                <select onchange="switchPage(this.options[this.selectedIndex].value)">
                                    <option><#switchpage#></option>
                                    <option value="1"><#menu4_2_1#></option>
                                    <option value="2"><#menu4_2_2#></option>
                                    <option value="3" selected><#menu4_2_3#></option>
                                </select>
                                <div id='bwm-daily-grid'></div>
                            </div>

                            <table width="100%" cellpadding="4" cellspacing="0" class="table table-striped">
                                <tr>
                                    <td width="25%"><b><#Last30days#> <span id='last-dates'></span></b></td>
                                    <td width="25%" class="dl" id='last-dn'>-</td>
                                    <td width="25%" class="ul" id='last-up'>-</td>
                                    <td width="25%" class="total" id='last-total'>-</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="footer"></div>
</form>
</body>
</html>

