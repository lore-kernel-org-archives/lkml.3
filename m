Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaFICQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 22:16:37 -0400
Received: from [207.46.163.207] ([207.46.163.207]:36155 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932216AbaFICQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 22:16:31 -0400
Date: Mon, 9 Jun 2014 10:15:36 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: imx6: add missing compatible and clock
 properties for kpp
Message-ID: <20140609021535.GX8860@dragon>
References: <1402052579-22803-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402052579-22803-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(24454002)(51704005)(81542001)(57986005)(33656002)(23756003)(74662001)(83072002)(86362001)(31966008)(85852003)(80022001)(46102001)(74502001)(79102001)(20776003)(64706001)(81342001)(4396001)(6806004)(54356999)(102836001)(19580405001)(19580395003)(83322001)(87936001)(77982001)(99396002)(33716001)(92726001)(50986999)(47776003)(77096999)(21056001)(76482001)(44976005)(76176999)(92566001)(104016001)(97736001)(83506001)(68736004)(84676001)(50466002)(26826002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB412;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02379661A3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 01:02:59PM +0200, Lothar Waﬂmann wrote:
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  arch/arm/boot/dts/imx6qdl.dtsi |    2 ++
>  1 file changed, 2 insertions(+)

Applied, thanks.

Shawn

> 
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index ce05991..3266d01 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -466,8 +466,10 @@
>  			};
>  
>  			kpp: kpp@020b8000 {
> +				compatible = "fsl,imx6q-kpp", "fsl,imx21-kpp";
>  				reg = <0x020b8000 0x4000>;
>  				interrupts = <0 82 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks 62>; /* IPG clock */
>  			};
>  
>  			wdog1: wdog@020bc000 {
> -- 
> 1.7.10.4
> 
