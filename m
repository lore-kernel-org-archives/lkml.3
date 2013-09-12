Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3ILN3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:29:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49221 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3ILN32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:29:28 -0400
Message-ID: <5231C189.2040406@ti.com>
Date: Thu, 12 Sep 2013 16:28:41 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] arm/dts: added dt properties to adapt to the new
 phy framwork
References: <1378136591-7463-1-git-send-email-kishon@ti.com> <1378136591-7463-7-git-send-email-kishon@ti.com>
In-Reply-To: <1378136591-7463-7-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Need some commit log.

cheers,
-roger

On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/omap5.dtsi |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 94abef5..9fe71ff 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -651,7 +651,8 @@
>  				compatible = "snps,dwc3";
>  				reg = <0x4a030000 0x10000>;
>  				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
> -				usb-phy = <&usb2_phy>, <&usb3_phy>;
> +				phys = <&usb2_phy>, <&usb3_phy>;
> +				phy-names = "usb2-phy", "usb3-phy";
>  				tx-fifo-resize;
>  			};
>  		};
> @@ -667,6 +668,7 @@
>  				compatible = "ti,omap-usb2";
>  				reg = <0x4a084000 0x7c>;
>  				ctrl-module = <&omap_control_usb2phy>;
> +				#phy-cells = <0>;
>  			};
>  
>  			usb3_phy: usb3phy@4a084400 {
> @@ -676,6 +678,7 @@
>  				      <0x4a084c00 0x40>;
>  				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
>  				ctrl-module = <&omap_control_usb3phy>;
> +				#phy-cells = <0>;
>  			};
>  		};
>  
> 

