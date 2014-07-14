Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaGNHfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:35:36 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:7695
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753773AbaGNHf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:35:28 -0400
Date: Mon, 14 Jul 2014 15:35:07 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <mkl@pengutronix.de>
Subject: Re: [PATCH] ARM: dts: vf610: fix length of eshdc1 register property
Message-ID: <20140714073506.GE2197@dragon>
References: <1405322326-2183-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405322326-2183-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(19580395003)(33716001)(81156004)(87936001)(105606002)(106466001)(77982001)(84676001)(86362001)(81342001)(23726002)(81542001)(46406003)(19580405001)(64706001)(57986006)(76482001)(26826002)(44976005)(31966008)(83072002)(85306003)(97736001)(21056001)(85852003)(99396002)(68736004)(47776003)(95666004)(107046002)(33656002)(80022001)(102836001)(97756001)(76176999)(74662001)(69596002)(54356999)(83322001)(92726001)(83506001)(46102001)(104016003)(50986999)(74502001)(92566001)(110136001)(4396001)(6806004)(50466002)(79102001)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB370;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:18:46AM +0200, Stefan Agner wrote:
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---

Applied, thanks.

>  arch/arm/boot/dts/vf610.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 6cc314e..6a6190c 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -362,7 +362,7 @@
>  
>  			esdhc1: esdhc@400b2000 {
>  				compatible = "fsl,imx53-esdhc";
> -				reg = <0x400b2000 0x4000>;
> +				reg = <0x400b2000 0x1000>;
>  				interrupts = <0 28 0x04>;
>  				clocks = <&clks VF610_CLK_IPG_BUS>,
>  					<&clks VF610_CLK_PLATFORM_BUS>,
> -- 
> 2.0.1
> 
