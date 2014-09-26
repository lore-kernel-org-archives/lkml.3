Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaIZCIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:08:13 -0400
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:7200
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751515AbaIZCIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:08:12 -0400
Date: Fri, 26 Sep 2014 10:07:46 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: vf610-colibri: Add ADC support
Message-ID: <20140926020745.GH21077@dragon>
References: <cover.1411122224.git.maitysanchayan@gmail.com>
 <a0ecfce3f97fb6684657ae76b89f38108fcdf68f.1411122224.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a0ecfce3f97fb6684657ae76b89f38108fcdf68f.1411122224.git.maitysanchayan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(51704005)(199003)(87936001)(83072002)(74662003)(80022003)(85852003)(106466001)(90102001)(102836001)(79102003)(33716001)(77982003)(46406003)(57986006)(81342003)(85306004)(76176999)(33656002)(1411001)(83506001)(10300001)(95666004)(74502003)(81156004)(86362001)(97756001)(54356999)(92726001)(46102003)(81542003)(110136001)(64706001)(4396001)(83322001)(50466002)(104016003)(105606002)(97736003)(84676001)(47776003)(68736004)(44976005)(69596002)(23726002)(6806004)(19580395003)(76482002)(21056001)(92566001)(120916001)(99396003)(50986999)(107046002)(19580405001)(31966008)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0638;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:56:13PM +0530, Sanchayan Maity wrote:
> Enable ADC support for Colibri VF61 modules
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> ---
>  arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 0cd8343..6fd099e 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -27,6 +27,16 @@
>  
>  };
>  
> +&adc0 {
> +	pinctrl-names = "default";

Sorry for missing it, but I would expect properties pinctrl-names and
pinctrl-0 appear as a couple.  Should we drop property pinctrl-names
here?

Shawn

> +	status = "okay";
> +};
> +
> +&adc1 {
> +	pinctrl-names = "default";
> +	status = "okay";
> +};
> +
>  &esdhc1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_esdhc1>;
> -- 
> 1.7.9.5
> 
