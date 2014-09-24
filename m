Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaIXQw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:52:58 -0400
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:20480
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753217AbaIXQwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:52:55 -0400
X-Greylist: delayed 1967 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 12:52:54 EDT
Date: Wed, 24 Sep 2014 09:19:57 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
        "Josh Cartwright" <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        "Peter Crosthwaite" <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: zynq: DT: Add missing reference for
 memory-controller
References: <fced9e56dc4ef8df9ead34f6444c010cc31c7a61.1411567289.git.michal.simek@xilinx.com>
 <ca95da888c9cd61e5b5e437b0e1b5cea893455ae.1411567289.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca95da888c9cd61e5b5e437b0e1b5cea893455ae.1411567289.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20972.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <a8d11082-8806-4a24-b904-0718ff0b0896@BN1BFFO11FD020.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(377424004)(24454002)(51704005)(95666004)(106466001)(70736001)(110136001)(90102001)(85202003)(1496007)(85306004)(33646002)(23676002)(104016003)(107046002)(50466002)(4396001)(21056001)(81542003)(19580395003)(81342003)(31966008)(83072002)(79102003)(77982003)(74662003)(92726001)(46102003)(80022003)(74502003)(10300001)(120916001)(76482002)(53416004)(87936001)(31696002)(64706001)(83506001)(85182001)(92566001)(85852003)(102836001)(74316001)(83322001)(86362001)(20776003)(44976005)(19580405001)(47776003)(77096002)(6806004)(54356999)(76176999)(50986999)(99396003)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB062;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 04:01PM +0200, Michal Simek wrote:
> Add missing reference for memory-controller.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  arch/arm/boot/dts/zynq-7000.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index fc90f47f9c03..2690e6d01f71 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -145,7 +145,7 @@
>  			cache-level = <2>;
>  		};
> 
> -		memory-controller@f8006000 {
> +		mc: memory-controller@f8006000 {
same here. 'mc0', there are definitely options to add more memory
controllers to Zynq in the PL. Also, I'd spell it out instead of
abbreviating the name.

	Sören
