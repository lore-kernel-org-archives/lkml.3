Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaEJGKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:10:34 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:27039
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbaEJGKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:10:32 -0400
Date: Sat, 10 May 2014 14:10:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Silvio Fricke <silvio.fricke@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, <spear-devel@list.st.com>
Subject: Re: [PATCH] ARM: dts: imx6: edmqmx6: add vcc and vio power supplies
 to stmpe
Message-ID: <20140510061017.GK2870@dragon>
References: <20140417061136.GD11602@dragon>
 <cover.1397741024.git.silvio.fricke@gmail.com>
 <a6a34db97a1cdcc21d0a7675d8ee31eb9bced399.1397741024.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a6a34db97a1cdcc21d0a7675d8ee31eb9bced399.1397741024.git.silvio.fricke@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130441758300171364;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(51704005)(24454002)(199002)(189002)(47776003)(99396002)(20776003)(19580395003)(2009001)(92726001)(76176999)(77096999)(68736004)(46406003)(46102001)(57986002)(44976005)(6806004)(19580405001)(87936001)(81156002)(83322001)(31966008)(50986999)(50466002)(79102001)(92566001)(81542001)(4396001)(97756001)(84676001)(76482001)(85852003)(33716001)(33656001)(77982001)(97736001)(83072002)(69596002)(64706001)(74662001)(21056001)(74502001)(81342001)(80022001)(23726002)(86362001)(54356999);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB414;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 02070414A1
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 03:28:06PM +0200, Silvio Fricke wrote:
> Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>

Applied, thanks.

Shawn

> ---
>  arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
> index e4ae38f..8fa08aa 100644
> --- a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
> +++ b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
> @@ -216,6 +216,8 @@
>  		reg = <0x40>;
>  		interrupts = <30 0>;
>  		interrupt-parent = <&gpio3>;
> +		vcc-supply = <&sw2_reg>;
> +		vio-supply = <&sw2_reg>;
>  
>  		stmpe_gpio1: stmpe_gpio {
>  			#gpio-cells = <2>;
> @@ -228,6 +230,8 @@
>  		reg = <0x44>;
>  		interrupts = <2 0>;
>  		interrupt-parent = <&gpio5>;
> +		vcc-supply = <&sw2_reg>;
> +		vio-supply = <&sw2_reg>;
>  
>  		stmpe_gpio2: stmpe_gpio {
>  			#gpio-cells = <2>;
> -- 
> 1.9.1
> 
