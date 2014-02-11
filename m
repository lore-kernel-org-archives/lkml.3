Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaBKNxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:53:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52778 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaBKNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:53:52 -0500
Message-ID: <52FA2B4F.3010408@ti.com>
Date: Tue, 11 Feb 2014 15:53:19 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <tony@atomide.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <nm@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] ARM: dts: OMAP2+: Fix boot with multi_v7_defconfig
References: <1392055835-6494-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1392055835-6494-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 08:10 PM, Roger Quadros wrote:
> The OMAP EHCI controller is not compatible with the EHCI
> platform HCD driver so don't claim that we are.
> 
> This fixes boot on OMAP platforms with CONFIG_USB_EHCI_HCD_PLATFORM=y
> e.g. multi_v7_defconfig
> 
> Reported-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Please ignore this patch as Hans has agreed to do a more proper fix in

http://article.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7015

cheers,
-roger

> ---
>  arch/arm/boot/dts/omap3.dtsi | 2 +-
>  arch/arm/boot/dts/omap4.dtsi | 2 +-
>  arch/arm/boot/dts/omap5.dtsi | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> index a5fc83b..6b5dbf8 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -641,7 +641,7 @@
>  			};
>  
>  			usbhsehci: ehci@48064800 {
> -				compatible = "ti,ehci-omap", "usb-ehci";
> +				compatible = "ti,ehci-omap";
>  				reg = <0x48064800 0x400>;
>  				interrupt-parent = <&intc>;
>  				interrupts = <77>;
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index d3f8a6e..f5d754b 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -706,7 +706,7 @@
>  			};
>  
>  			usbhsehci: ehci@4a064c00 {
> -				compatible = "ti,ehci-omap", "usb-ehci";
> +				compatible = "ti,ehci-omap";
>  				reg = <0x4a064c00 0x400>;
>  				interrupt-parent = <&gic>;
>  				interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index a72813a..42fcffd 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -784,7 +784,7 @@
>  			};
>  
>  			usbhsehci: ehci@4a064c00 {
> -				compatible = "ti,ehci-omap", "usb-ehci";
> +				compatible = "ti,ehci-omap";
>  				reg = <0x4a064c00 0x400>;
>  				interrupt-parent = <&gic>;
>  				interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
> 

