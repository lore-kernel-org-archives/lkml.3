Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab3JPNRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:17:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56346 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933Ab3JPNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:17:52 -0400
Message-ID: <525E91D4.30509@ti.com>
Date: Wed, 16 Oct 2013 18:47:08 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <rogerq@ti.com>, George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH v2 2/2] ARM: dts: omap5: Add dr_mode for dwc3
References: <52580F34.8030809@ti.com> <1381816199-7966-1-git-send-email-kishon@ti.com>
In-Reply-To: <1381816199-7966-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On Tuesday 15 October 2013 11:19 AM, Kishon Vijay Abraham I wrote:
> From: George Cherian <george.cherian@ti.com>
> 
> Added dr_mode property in dwc3 and set its default mode to device.
> Currently dwc3 driver doesn't have support for OTG mode. So explicitly
> setting to peripheral even dwc3 is a OTG controller since OMAP5 has
> already got an EHCI host.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Can you take this patch for 3.13?

Thanks
Kishon
> ---
> Changes from v1:
> Changed the commit log to explain why dr_mode was not set to OTG.
>  arch/arm/boot/dts/omap5.dtsi |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 6d0a1d5..ef598af 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -652,6 +652,7 @@
>  				reg = <0x4a030000 0x10000>;
>  				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
>  				usb-phy = <&usb2_phy>, <&usb3_phy>;
> +				dr_mode = "peripheral";
>  				tx-fifo-resize;
>  			};
>  		};
> 

