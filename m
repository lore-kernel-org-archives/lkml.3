Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3BEU3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:29:38 -0500
Received: from 17.mo1.mail-out.ovh.net ([87.98.179.142]:38166 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754626Ab3BEU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:29:36 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 15:29:35 EST
Date: Tue, 5 Feb 2013 20:51:26 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        linux@arm.linux.org.uk
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [v4 PATCH 11/12] ARM: dts: add spi nodes for atmel SoC
Message-ID: <20130205195126.GB30595@game.jcrosoft.org>
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
 <1358148877-18679-12-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358148877-18679-12-git-send-email-wenyou.yang@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7151153258737216389
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:34 Mon 14 Jan     , Wenyou Yang wrote:
> From: Richard Genoud <richard.genoud@gmail.com>
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> [wenyou.yang@atmel.com: add spi nodes for sam9260, sam9263, sam9g45 and sam9n12]
> [wenyou.yang@atmel.com: remove spi property "cs-gpios" to the board dts files]
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: linux@arm.linux.org.uk
> ---
>  arch/arm/boot/dts/at91sam9260.dtsi |   18 ++++++++++++++++++
>  arch/arm/boot/dts/at91sam9263.dtsi |   18 ++++++++++++++++++
>  arch/arm/boot/dts/at91sam9g45.dtsi |   18 ++++++++++++++++++
I alreadt have some patch in queue

Best Regards,
J.
>  arch/arm/boot/dts/at91sam9n12.dtsi |   18 ++++++++++++++++++
>  arch/arm/boot/dts/at91sam9x5.dtsi  |   18 ++++++++++++++++++
>  5 files changed, 90 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
> index 68bccf4..9586fe1 100644
> --- a/arch/arm/boot/dts/at91sam9260.dtsi
> +++ b/arch/arm/boot/dts/at91sam9260.dtsi
> @@ -453,6 +453,24 @@
>  				status = "disabled";
>  			};
>  
> +			spi0: spi@fffc8000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9260-spi";
> +				reg = <0xfffc8000 0x200>;
> +				interrupts = <12 4 3>;
> +				status = "disabled";
> +			};
> +
> +			spi1: spi@fffcc000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9260-spi";
> +				reg = <0xfffcc000 0x200>;
> +				interrupts = <13 4 3>;
> +				status = "disabled";
> +			};
> +
>  			adc0: adc@fffe0000 {
>  				compatible = "atmel,at91sam9260-adc";
>  				reg = <0xfffe0000 0x100>;
> diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
> index 32ec62c..636b882 100644
> --- a/arch/arm/boot/dts/at91sam9263.dtsi
> +++ b/arch/arm/boot/dts/at91sam9263.dtsi
> @@ -426,6 +426,24 @@
>  				reg = <0xfffffd40 0x10>;
>  				status = "disabled";
>  			};
> +
> +			spi0: spi@fffa4000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9260-spi";
> +				reg = <0xfffa4000 0x200>;
> +				interrupts = <14 4 3>;
> +				status = "disabled";
> +			};
> +
> +			spi1: spi@fffa8000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9260-spi";
> +				reg = <0xfffa8000 0x200>;
> +				interrupts = <15 4 3>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index 231858f..0100b80 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -495,6 +495,24 @@
>  				reg = <0xfffffd40 0x10>;
>  				status = "disabled";
>  			};
> +
> +			spi0: spi@fffa4000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9g45-spi";
> +				reg = <0xfffa4000 0x200>;
> +				interrupts = <14 4 3>;
> +				status = "disabled";
> +			};
> +
> +			spi1: spi@fffa8000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9g45-spi";
> +				reg = <0xfffa8000 0x200>;
> +				interrupts = <15 4 3>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
> index e9efb34..86d5357 100644
> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> @@ -355,6 +355,24 @@
>  				#size-cells = <0>;
>  				status = "disabled";
>  			};
> +
> +			spi0: spi@f0000000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9x5-spi";
> +				reg = <0xf0000000 0x100>;
> +				interrupts = <13 4 3>;
> +				status = "disabled";
> +			};
> +
> +			spi1: spi@f0004000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9x5-spi";
> +				reg = <0xf0004000 0x100>;
> +				interrupts = <14 4 3>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index 40ac3a4..8ea2f7d 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -473,6 +473,24 @@
>  					trigger-value = <0x6>;
>  				};
>  			};
> +
> +			spi0: spi@f0000000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9x5-spi";
> +				reg = <0xf0000000 0x100>;
> +				interrupts = <13 4 3>;
> +				status = "disabled";
> +			};
> +
> +			spi1: spi@f0004000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91sam9x5-spi";
> +				reg = <0xf0004000 0x100>;
> +				interrupts = <14 4 3>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		nand0: nand@40000000 {
> -- 
> 1.7.9.5
> 
