Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaB1WZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:25:25 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57984 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaB1WZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:25:21 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18SRn//NPC0M1sk8HfJ/8/V
Date: Fri, 28 Feb 2014 14:25:02 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com
Subject: Re: [PATCH 5/9] ARM: dts: omap3-gta04: Add basic sound support.
Message-ID: <20140228222501.GL13624@atomide.com>
References: <1390685343-11663-1-git-send-email-marek@goldelico.com>
 <1390685343-11663-6-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390685343-11663-6-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [140125 13:31]:

Hmm care to add descriptions and repost the remaining patches
that I did not yet pick up for the fixes?

> Signed-off-by: NeilBrown <neilb@suse.de>

Hmm should this also have From: NeilBrown <neilb@suse.de>?

Also, while at it, maybe change your long time habit of adding
a period to the end of the subject line? That is of course
if you don't insist on having it, it's not usually used if
you look at git log --pretty=oneline :)

Regards,

Tony

> ---
>  arch/arm/boot/dts/omap3-gta04.dts | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
> index 7e09410..a924a843 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dts
> +++ b/arch/arm/boot/dts/omap3-gta04.dts
> @@ -36,6 +36,14 @@
>  			gpio-key,wakeup;
>  		};
>  	};
> +
> +	sound {
> +		compatible = "ti,omap-twl4030";
> +		ti,model = "gta04";
> +
> +		ti,mcbsp = <&mcbsp2>;
> +		ti,codec = <&twl_audio>;
> +	};
>  };
>  
>  &omap3_pmx_core {
> @@ -79,6 +87,13 @@
>  		reg = <0x48>;
>  		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
>  		interrupt-parent = <&intc>;
> +
> +		twl_audio: audio {
> +			compatible = "ti,twl4030-audio";
> +			codec {
> +			};
> +		};
> +
>  		vaux4: regulator-vaux4 {
>  			compatible = "ti,twl4030-vaux4";
>  			regulator-min-microvolt = <2800000>;
> -- 
> 1.8.3.2
> 
