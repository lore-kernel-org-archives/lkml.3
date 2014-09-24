Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaIXQdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:33:55 -0400
Received: from mail-by2on0087.outbound.protection.outlook.com ([207.46.100.87]:15872
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883AbaIXQdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:33:53 -0400
X-Greylist: delayed 928 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 12:33:52 EDT
Date: Wed, 24 Sep 2014 09:18:14 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: zynq: DT: Add missing reference for ADC
References: <fced9e56dc4ef8df9ead34f6444c010cc31c7a61.1411567289.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fced9e56dc4ef8df9ead34f6444c010cc31c7a61.1411567289.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20972.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <68d34c42-b0e0-4e8f-8b92-0bc8fd233d52@BN1AFFO11FD056.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(189002)(199003)(51704005)(24454002)(6806004)(77982003)(83322001)(50466002)(47776003)(79102003)(23676002)(90102001)(74662003)(81342003)(76482002)(86362001)(31966008)(19580405001)(50986999)(76176999)(44976005)(85182001)(99396003)(107046002)(74316001)(31696002)(64706001)(20776003)(19580395003)(33646002)(87936001)(85202003)(21056001)(83506001)(104016003)(102836001)(83072002)(85306004)(92726001)(92566001)(95666004)(110136001)(77096002)(74502003)(54356999)(81542003)(46102003)(80022003)(106466001)(4396001)(53416004)(70736001)(1496007)(120916001)(10300001)(85852003)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB062;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 04:01PM +0200, Michal Simek wrote:
> Add missing reference for ADC node.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  arch/arm/boot/dts/zynq-7000.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 772381fe07bb..fc90f47f9c03 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -64,7 +64,7 @@
>  		interrupt-parent = <&intc>;
>  		ranges;
> 
> -		adc@f8007100 {
> +		adc: adc@f8007100 {
I think we enumerated all labels. I.e. 'adc0' is probably better.

	Sören
