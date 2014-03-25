Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaCYJtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:49:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54847 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaCYJtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:49:42 -0400
Message-ID: <53315121.3040900@ti.com>
Date: Tue, 25 Mar 2014 11:49:21 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <anatol.pomozov@gmail.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH v5 2/5] ARM: dts: am43xx clock data
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com> <1395223803-4714-3-git-send-email-george.cherian@ti.com>
In-Reply-To: <1395223803-4714-3-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 12:10 PM, George Cherian wrote:
> Add USB and USB PHY reference clock data
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>

Acked-by: Roger Quadros <rogerq@ti.com>

cheers,
-roger

> ---
>  arch/arm/boot/dts/am43xx-clocks.dtsi | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am43xx-clocks.dtsi b/arch/arm/boot/dts/am43xx-clocks.dtsi
> index 142009c..5171d3e 100644
> --- a/arch/arm/boot/dts/am43xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/am43xx-clocks.dtsi
> @@ -653,4 +653,36 @@
>  		clocks = <&clk_32768_ck>, <&clk_32k_tpm_ck>;
>  		reg = <0x4260>;
>  	};
> +
> +	usb_phy0_always_on_clk32k: usb_phy0_always_on_clk32k {
> +        	#clock-cells = <0>;
> +	        compatible = "ti,gate-clock";
> +	        clocks = <&usbphy_32khz_clkmux>;
> +	        ti,bit-shift = <8>;
> +	        reg = <0x2a40>;
> +	};
> +
> +	usb_phy1_always_on_clk32k: usb_phy1_always_on_clk32k {
> +        	#clock-cells = <0>;
> +	        compatible = "ti,gate-clock";
> +	        clocks = <&usbphy_32khz_clkmux>;
> +	        ti,bit-shift = <8>;
> +	        reg = <0x2a48>;
> +	};
> +
> +	usb_otg_ss0_refclk960m: usb_otg_ss0_refclk960m {
> +		#clock-cells = <0>;
> +	        compatible = "ti,gate-clock";
> +		clocks = <&dpll_per_clkdcoldo>;
> +	        ti,bit-shift = <8>;
> +	        reg = <0x8a60>;
> +	};
> +
> +	usb_otg_ss1_refclk960m: usb_otg_ss1_refclk960m {
> +		#clock-cells = <0>;
> +	        compatible = "ti,gate-clock";
> +		clocks = <&dpll_per_clkdcoldo>;
> +	        ti,bit-shift = <8>;
> +		reg = <0x8a68>;
> +	};
>  };
> 

