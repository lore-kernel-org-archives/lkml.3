Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbaD3MbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:31:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51414 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaD3MbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:31:12 -0400
Message-ID: <5360ECF5.6080801@ti.com>
Date: Wed, 30 Apr 2014 15:30:45 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: DTS: omap54xx-clocks: remove the autoidle properties
 for clock nodes
References: <1398858096-32144-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1398858096-32144-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 02:41 PM, Peter Ujfalusi wrote:
> In OMAP5 bit 8 in PRCM registers are not defined (Reserved) unlike their
> counterpart in OMAP4.
> It is better to not write to these bits.

Yeah, looks like this bug was copied over from the legacy clock data.

Acked-by: Tero Kristo <t-kristo@ti.com>

>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>   arch/arm/boot/dts/omap54xx-clocks.dtsi | 48 ----------------------------------
>   1 file changed, 48 deletions(-)
>
> diff --git a/arch/arm/boot/dts/omap54xx-clocks.dtsi b/arch/arm/boot/dts/omap54xx-clocks.dtsi
> index d487fdab3921..d784ff5d3904 100644
> --- a/arch/arm/boot/dts/omap54xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/omap54xx-clocks.dtsi
> @@ -120,10 +120,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_abe_x2_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x01f0>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	abe_24m_fclk: abe_24m_fclk {
> @@ -164,10 +162,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_abe_x2_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x01f4>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_ck: dpll_core_ck {
> @@ -188,10 +184,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0150>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	c2c_fclk: c2c_fclk {
> @@ -215,10 +209,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0138>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_h12x2_ck: dpll_core_h12x2_ck {
> @@ -226,10 +218,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x013c>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_h13x2_ck: dpll_core_h13x2_ck {
> @@ -237,10 +227,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0140>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_h14x2_ck: dpll_core_h14x2_ck {
> @@ -248,10 +236,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0144>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_h22x2_ck: dpll_core_h22x2_ck {
> @@ -259,10 +245,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0154>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_h23x2_ck: dpll_core_h23x2_ck {
> @@ -270,10 +254,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0158>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_h24x2_ck: dpll_core_h24x2_ck {
> @@ -281,10 +263,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x015c>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_m2_ck: dpll_core_m2_ck {
> @@ -292,10 +272,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0130>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_core_m3x2_ck: dpll_core_m3x2_ck {
> @@ -303,10 +281,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_core_x2_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0134>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	iva_dpll_hs_clk_div: iva_dpll_hs_clk_div {
> @@ -335,10 +311,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_iva_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x01b8>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_iva_h12x2_ck: dpll_iva_h12x2_ck {
> @@ -346,10 +320,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_iva_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x01bc>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	mpu_dpll_hs_clk_div: mpu_dpll_hs_clk_div {
> @@ -372,10 +344,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_mpu_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0170>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	per_dpll_hs_clk_div: per_dpll_hs_clk_div {
> @@ -642,10 +612,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_per_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0158>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_per_h12x2_ck: dpll_per_h12x2_ck {
> @@ -653,10 +621,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_per_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x015c>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_per_h14x2_ck: dpll_per_h14x2_ck {
> @@ -664,10 +630,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_per_x2_ck>;
>   		ti,max-div = <63>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0164>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_per_m2_ck: dpll_per_m2_ck {
> @@ -675,10 +639,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_per_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0150>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_per_m2x2_ck: dpll_per_m2x2_ck {
> @@ -686,10 +648,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_per_x2_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0150>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_per_m3x2_ck: dpll_per_m3x2_ck {
> @@ -697,10 +657,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_per_x2_ck>;
>   		ti,max-div = <31>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0154>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_unipro1_ck: dpll_unipro1_ck {
> @@ -723,10 +681,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_unipro1_ck>;
>   		ti,max-div = <127>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0210>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_unipro2_ck: dpll_unipro2_ck {
> @@ -749,10 +705,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_unipro2_ck>;
>   		ti,max-div = <127>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x01d0>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	dpll_usb_ck: dpll_usb_ck {
> @@ -775,10 +729,8 @@
>   		compatible = "ti,divider-clock";
>   		clocks = <&dpll_usb_ck>;
>   		ti,max-div = <127>;
> -		ti,autoidle-shift = <8>;
>   		reg = <0x0190>;
>   		ti,index-starts-at-one;
> -		ti,invert-autoidle-bit;
>   	};
>
>   	func_128m_clk: func_128m_clk {
>

