Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3ILQTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:19:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58404 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3ILQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:19:46 -0400
Message-ID: <5231E97F.1060005@ti.com>
Date: Thu, 12 Sep 2013 11:19:11 -0500
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
Subject: Re: [PATCH 3/4] ARM: am335x-bone-common: switch mmc1 to 4-bit mode
References: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net> <1379000532-27376-4-git-send-email-koen@dominion.thruhere.net>
In-Reply-To: <1379000532-27376-4-git-send-email-koen@dominion.thruhere.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nitpick minor comment:
$subject: ARM: dts: am335x-bone-common: switch mmc1 to 4-bit mode

On 09/12/2013 10:42 AM, Koen Kooi wrote:
> The micro-SD slot hooks up all four data pins so lets' use them.
> 
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
> ---
>  arch/arm/boot/dts/am335x-bone-common.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> index cfec441..80407ff 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -290,6 +290,7 @@
>  
>  &mmc1 {
>  	status = "okay";
> +	bus-width = <0x4>;
>  	vmmc-supply = <&ldo3_reg>;
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&mmc1_pins>;
> 


-- 
Regards,
Nishanth Menon
