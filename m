Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaFQJuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:50:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55610 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752971AbaFQJuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:50:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18PZ42GjZ01VLYXiwa+a1VI
Date: Tue, 17 Jun 2014 02:50:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, balbi@ti.com,
        dmurphy@ti.com, mugunthanvnm@ti.com, nsekhar@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH v7 4/5] ARM: dts: am43x-epos-evm: Update binding for
 touchscreen size
Message-ID: <20140617095015.GP17845@atomide.com>
References: <1402997507-9736-1-git-send-email-rogerq@ti.com>
 <1402997507-9736-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402997507-9736-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140617 02:33]:
> Update the bindings for touchscreen size.
> 
> CC: Benoit Cousson <bcousson@baylibre.com>
> CC: Tony Lindgren <tony@atomide.com>
> CC: Mugunthan V N <mugunthanvnm@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

This should be fine to queue along with the driver changes:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/boot/dts/am43x-epos-evm.dts | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
> index 19f1f7e..f3fe017 100644
> --- a/arch/arm/boot/dts/am43x-epos-evm.dts
> +++ b/arch/arm/boot/dts/am43x-epos-evm.dts
> @@ -340,8 +340,8 @@
>  
>  		attb-gpio = <&gpio1 17 GPIO_ACTIVE_HIGH>;
>  
> -		x-size = <1024>;
> -		y-size = <600>;
> +		touchscreen-size-x = <1024>;
> +		touchscreen-size-y = <600>;
>  	};
>  };
>  
> -- 
> 1.8.3.2
> 
