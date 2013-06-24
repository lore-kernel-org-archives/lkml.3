Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3FXLss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:48:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43532 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab3FXLsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:48:45 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
CC: "Nori, Sekhar" <nsekhar@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "tony@atomide.com" <tony@atomide.com>,
        "prabhakar.csengg@gmail.com" <prabhakar.csengg@gmail.com>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH 3/3] ARM: davinci: da850: adopt to pinctrl-single driver
 to configure multiple pins
Thread-Topic: [PATCH 3/3] ARM: davinci: da850: adopt to pinctrl-single
 driver to configure multiple pins
Thread-Index: AQHOViyjPxkpN+2o00iG31qLF1FFYJlE42KA
Date: Mon, 24 Jun 2013 11:48:01 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA911E0@DBDE04.ent.ti.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
 <1369145282-14419-5-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1369145282-14419-5-git-send-email-prakash.pm@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Tue, May 21, 2013 at 19:38:02, Manjunathappa, Prakash wrote:
> function-mask property is a mask for a pin at each pin configure offset
> in a pincontrol register.
> 

Got 1/3 and 2/3 accepted, I do not know if this gets merged via DaVinci tree or
pincontrol tree. Could you please takecare of this?

Thanks,
Prakash

> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> ---
>  arch/arm/boot/dts/da850.dtsi |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index 4d43046..9bec36c 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -37,7 +37,7 @@
>  			#size-cells = <0>;
>  			pinctrl-single,bit-per-mux;
>  			pinctrl-single,register-width = <32>;
> -			pinctrl-single,function-mask = <0xffffffff>;
> +			pinctrl-single,function-mask = <0xf>;
>  			status = "disabled";
>  
>  			nand_cs3_pins: pinmux_nand_pins {
> -- 
> 1.7.4.1
> 
> 

