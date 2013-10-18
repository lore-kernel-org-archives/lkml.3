Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3JRMAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:00:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38392 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3JRMAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:00:46 -0400
Message-ID: <526122C4.4090702@ti.com>
Date: Fri, 18 Oct 2013 15:00:04 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <bcousson@baylibre.com>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <bigeasy@linutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] ARM: dts: omap3-beagle: Adapt USB OTG to generic PHY
 framework
References: <1381142810-14541-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1381142810-14541-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

Could you please include this one for 3.13?
Without this OTG port will be broken for beagle. Thanks.

cheers,
-roger

On 10/07/2013 01:46 PM, Roger Quadros wrote:
> The generic PHY framewrok expects different properties than the
> old USB PHY framework. Supply those properties.
> 
> Fixes USB OTG port on beagle after the Generic PHY framework was
> merged in greg/usb-next. [1]
> 
> [1] - https://lkml.org/lkml/2013/9/27/581
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap3-beagle.dts |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
> index 7669c16..fa532aa 100644
> --- a/arch/arm/boot/dts/omap3-beagle.dts
> +++ b/arch/arm/boot/dts/omap3-beagle.dts
> @@ -173,6 +173,8 @@
>  &usb_otg_hs {
>  	interface-type = <0>;
>  	usb-phy = <&usb2_phy>;
> +	phys = <&usb2_phy>;
> +	phy-names = "usb2-phy";
>  	mode = <3>;
>  	power = <50>;
>  };
> 

