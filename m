Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaLUGMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 01:12:05 -0500
Received: from mail-bl2on0059.outbound.protection.outlook.com ([65.55.169.59]:51200
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830AbaLUGMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 01:12:01 -0500
Date: Sat, 20 Dec 2014 22:11:56 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
CC: <gregkh@linuxfoundation.org>, <laurent.pinchart@ideasonboard.com>,
        <devendra.aaru@gmail.com>, <athirasnamby@gmail.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: clocking-wizard: Added a blank line after
 declaration
References: <1419129228-5333-1-git-send-email-md.jamalmohiuddin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419129228-5333-1-git-send-email-md.jamalmohiuddin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21190.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <b95962feaec54d2495d57d038af04ad0@BN1BFFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(51704005)(24454002)(189002)(377424004)(52044002)(76176999)(33646002)(104016003)(21056001)(86362001)(23676002)(47776003)(20776003)(50986999)(77156002)(74316001)(54356999)(62966003)(110136001)(64706001)(87936001)(108616004)(85182001)(92566001)(6806004)(19580395003)(19580405001)(4396001)(83506001)(92726002)(99396003)(31966008)(46102003)(2950100001)(106466001)(85202003)(107046002)(120916001)(53416004)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB037;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB037;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1BFFO11HUB037;
X-Forefront-PRVS: 0432A04947
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB037;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohammad,

On Sun, 2014-12-21 at 08:03AM +0530, Mohammad Jamal wrote:
> Fix the coding style issue by adding blank line after declaration
> 
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> ---
>  .../clocking-wizard/clk-xlnx-clock-wizard.c        |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> index 471d087..ea8d561 100644
> --- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> +++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> @@ -239,6 +239,7 @@ static int clk_wzrd_probe(struct platform_device *pdev)
>  	/* register div per output */
>  	for (i = WZRD_NUM_OUTPUTS - 1; i >= 0 ; i--) {
>  		const char *clkout_name;
> +
>  		if (of_property_read_string_index(np, "clock-output-names", i,
>  						  &clkout_name)) {
>  			dev_err(&pdev->dev,

I think the same patch had already been sent to the list by somebody
else. Not sure whether Greg picked it up yet.
Either way, feel free to add my
Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Sören
