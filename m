Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3JKOq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:46:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39271 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab3JKOqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:46:55 -0400
Message-ID: <52580F34.8030809@ti.com>
Date: Fri, 11 Oct 2013 17:46:12 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
References: <1381402195-29257-1-git-send-email-kishon@ti.com> <1381402195-29257-2-git-send-email-kishon@ti.com>
In-Reply-To: <1381402195-29257-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
> From: George Cherian <george.cherian@ti.com>
> 
> Added dr_mode property in dwc3 and set its default mode to device.

If there is a specific reason why this is not set to "otg", we need
to explain it here.

AFAIK the port is meant to be used as OTG port.

> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
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

cheers,
-roger
