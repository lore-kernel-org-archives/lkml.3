Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaIRNqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:46:31 -0400
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:26600
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755159AbaIRNqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:46:30 -0400
Date: Thu, 18 Sep 2014 21:46:15 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: <stefan@agner.ch>, <B38611@freescale.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <jic23@kernel.org>, <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: vf610-colibri: Add ADC support
Message-ID: <20140918134613.GK4796@dragon>
References: <cover.1410873422.git.maitysanchayan@gmail.com>
 <1015e874d5b13795e38069402a66b4798d79b632.1410873422.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1015e874d5b13795e38069402a66b4798d79b632.1410873422.git.maitysanchayan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(51704005)(199003)(83506001)(46406003)(99396002)(20776003)(74502003)(83322001)(105606002)(64706001)(76176999)(19580395003)(110136001)(50986999)(85306004)(46102003)(90102001)(47776003)(68736004)(21056001)(81542003)(4396001)(57986006)(81342003)(77982003)(74662003)(31966008)(54356999)(23726002)(19580405001)(76482002)(106466001)(80022003)(95666004)(44976005)(102836001)(92566001)(87936001)(83072002)(104016003)(6806004)(50466002)(84676001)(86362001)(92726001)(33656002)(79102003)(107046002)(85852003)(1411001)(33716001)(97756001)(26826002)(97736003)(473944003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB375;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 01:53:16PM +0530, Sanchayan Maity wrote:
> Enable ADC support for Colibri VF61 modules
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> ---
>  arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 0cd8343..275ebec 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -69,6 +69,16 @@
>  	status = "okay";
>  };
>  
> +&adc0 {
> +	pinctrl-names = "default";
> +	status = "okay";
> +};
> +
> +&adc1 {
> +	pinctrl-names = "default";
> +	status = "okay";
> +};
> +

Please sort the nodes alphabetically in node name.

Shawn

>  &iomuxc {
>  	vf610-colibri {
>  		pinctrl_esdhc1: esdhc1grp {
> -- 
> 1.7.9.5
> 
