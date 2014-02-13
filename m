Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBMXJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:09:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55777 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaBMXJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:09:06 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+WYbNtpmGI3W8uuS4yhq0s
Date: Thu, 13 Feb 2014 15:08:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com
Subject: Re: [PATCH 3/9] ARM: dts: omap3-gta04: Fix mmc1 properties.
Message-ID: <20140213230847.GK28216@atomide.com>
References: <1390685343-11663-1-git-send-email-marek@goldelico.com>
 <1390685343-11663-4-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390685343-11663-4-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [140125 13:31]:
> Does not have an aux supply, and must be non-removable.
> 
> Otherwise it is removed during suspend and filesystem gets confused.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  arch/arm/boot/dts/omap3-gta04.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
> index e315675..6011151 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dts
> +++ b/arch/arm/boot/dts/omap3-gta04.dts
> @@ -149,8 +149,8 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&mmc1_pins>;
>  	vmmc-supply = <&vmmc1>;
> -	vmmc_aux-supply = <&vsim>;
>  	bus-width = <4>;
> +	ti,non-removable;
>  };
>  
>  &mmc2 {

Taking this too into omap-for-v3.14/fixes.

Tony
