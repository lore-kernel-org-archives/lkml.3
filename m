Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbbAGXuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:50:01 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53265 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755961AbbAGXt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:49:56 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/npnMKmb6FLD/Y9bYFy1eR
Date: Wed, 7 Jan 2015 15:46:10 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, trivial@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] dts: omap3-n900: cleanup english
Message-ID: <20150107234610.GJ13010@atomide.com>
References: <20141207161147.GA18588@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207161147.GA18588@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141207 08:14]:
> This fixes english in comments and removes extra empty newline.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Applying into omap-for-v3.20/dt thanks.

Tony
 
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> index 11d8afd..9e0e5a2 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -287,7 +287,7 @@
>  	regulator-name = "V28";
>  	regulator-min-microvolt = <2800000>;
>  	regulator-max-microvolt = <2800000>;
> -	regulator-always-on; /* due battery cover sensor */
> +	regulator-always-on; /* due to battery cover sensor */
>  };
>  
>  &vaux2 {
> @@ -345,7 +345,6 @@
>  	regulator-name = "VIO";
>  	regulator-min-microvolt = <1800000>;
>  	regulator-max-microvolt = <1800000>;
> -
>  };
>  
>  &vintana1 {
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
