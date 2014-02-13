Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaBMXIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:08:32 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54148 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaBMXI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:08:29 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19W+Sx9tlTqNfo1lSwdNXqV
Date: Thu, 13 Feb 2014 15:08:06 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com
Subject: Re: [PATCH 1/9] ARM: dts: omap3-gta04: Fix 'aux' gpio key flags.
Message-ID: <20140213230805.GJ28216@atomide.com>
References: <1390685343-11663-1-git-send-email-marek@goldelico.com>
 <1390685343-11663-2-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390685343-11663-2-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [140125 13:31]:
> From: NeilBrown <neilb@suse.de>
> 
> It should be ACTIVE_HIGH.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  arch/arm/boot/dts/omap3-gta04.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
> index b9b55c9..9d37184 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dts
> +++ b/arch/arm/boot/dts/omap3-gta04.dts
> @@ -32,7 +32,7 @@
>  		aux-button {
>  			label = "aux";
>  			linux,code = <169>;
> -			gpios = <&gpio1 7 GPIO_ACTIVE_LOW>;
> +			gpios = <&gpio1 7 GPIO_ACTIVE_HIGH>;
>  			gpio-key,wakeup;
>  		};
>  	};

Picking this one into omap-for-v3.14/fixes thanks.

Tony
