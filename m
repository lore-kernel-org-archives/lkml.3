Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3ILQUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:20:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58452 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3ILQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:20:32 -0400
Message-ID: <5231E9B0.8060303@ti.com>
Date: Thu, 12 Sep 2013 11:20:00 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: <linux-kernel@vger.kernel.org>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] ARM: dts: am335x-bone-common: add cpu0 and mmc1 triggers
References: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net> <1379000532-27376-5-git-send-email-koen@dominion.thruhere.net>
In-Reply-To: <1379000532-27376-5-git-send-email-koen@dominion.thruhere.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:42 AM, Koen Kooi wrote:
> This matches the vendor 3.8.x configuration that is shipping with the boards.
> 
> The LED layout is now:
> 
> USR0: heartbeat
> USR1: mmc0 (micro-SD slot)
> USR2: cpu0
> USR3: mmc1 (eMMC)
> 
> The cpu0 triggers was put inbetween the mmc triggers to make is easier to see
nitpick: sinbetween/in between/

> where the disk activity is.
> 
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
> ---
>  arch/arm/boot/dts/am335x-bone-common.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> index 80407ff..3057f30 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -203,12 +203,14 @@
>  		led@4 {
>  			label = "beaglebone:green:usr2";
>  			gpios = <&gpio1 23 GPIO_ACTIVE_HIGH>;
> +			linux,default-trigger = "cpu0";
>  			default-state = "off";
>  		};
>  
>  		led@5 {
>  			label = "beaglebone:green:usr3";
>  			gpios = <&gpio1 24 GPIO_ACTIVE_HIGH>;
> +			linux,default-trigger = "mmc1";
>  			default-state = "off";
>  		};
>  	};
> 


-- 
Regards,
Nishanth Menon
