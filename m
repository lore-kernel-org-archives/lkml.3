Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaH1RPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:15:43 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:42412
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811AbaH1RPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:15:41 -0400
Date: Thu, 28 Aug 2014 10:15:36 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Ezra Savard <ezras@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Ezra Savard <ezra.savard@xilinx.com>
Subject: Re: [PATCH] ARM: zynq: DT: Add LEDs to zc702 DT
References: <1409242973-2735-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1409242973-2735-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20902.005
X-TM-AS-Result: No--4.282-5.0-31-1
X-imss-scan-details: No--4.282-5.0-31-1
Message-ID: <48d3362c-a688-4245-8258-cd1062f954a1@BN1AFFO11FD035.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(377424004)(24454002)(189002)(51704005)(64706001)(110136001)(83506001)(50466002)(85202003)(46102001)(107046002)(81542001)(106466001)(74316001)(95666004)(77096002)(81342001)(77982001)(79102001)(20776003)(23676002)(47776003)(92566001)(80022001)(33646002)(99396002)(104016003)(74502001)(74662001)(87936001)(85852003)(102836001)(4396001)(31966008)(85182001)(53416004)(76482001)(76176999)(50986999)(19580405001)(83322001)(92726001)(54356999)(31696002)(83072002)(1496007)(86362001)(85306004)(19580395003)(70736001)(90102001)(21056001)(44976005)(6806004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB045;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-28 at 09:22AM -0700, Soren Brinkmann wrote:
> From: Ezra Savard <ezra.savard@xilinx.com>
> 
> Adds LEDs to the zc702 devicetree for use with the leds-gpio driver.
> 
> Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
> Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-zc702.dts | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
> index 835c3089c61c..4e9fe26b3e85 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> @@ -27,6 +27,16 @@
>  		bootargs = "console=ttyPS0,115200 earlyprintk";
>  	};
>  
> +	gpio-leds {
The node name should rather be just 'leds'. That slipped through, sorry.
Do you want a v2 for that?

	Soren
