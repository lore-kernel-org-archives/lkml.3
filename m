Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaFQJum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:50:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25709 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaFQJuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:50:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19COCzeHTfPGG5rKnxNNv1X
Date: Tue, 17 Jun 2014 02:50:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, balbi@ti.com,
        dmurphy@ti.com, mugunthanvnm@ti.com, nsekhar@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH v7 5/5] ARM: dts: am437x-gp-evm: Update binding for
 touchscreen size
Message-ID: <20140617095035.GQ17845@atomide.com>
References: <1402997507-9736-1-git-send-email-rogerq@ti.com>
 <1402997507-9736-6-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402997507-9736-6-git-send-email-rogerq@ti.com>
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

This too:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
> index 003766c..2674132 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -277,8 +277,8 @@
>  
>  		attb-gpio = <&gpio3 22 GPIO_ACTIVE_HIGH>;
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
