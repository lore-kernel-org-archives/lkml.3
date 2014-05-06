Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaEFAhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:37:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32981 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933005AbaEFAhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:37:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1954hZl8sL3Z7OY36DmQXux
Date: Mon, 5 May 2014 17:37:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: am335x-boneblack: remove use of
 ti,vcc-aux-disable-is-sleep
Message-ID: <20140506003734.GO25949@atomide.com>
References: <1398432986-30585-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398432986-30585-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johan Hovold <jhovold@gmail.com> [140425 06:37]:
> Remove use of property ti,vcc-aux-disable-is-sleep, which does not
> exist.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Thanks applying into omap-for-v3.16/fixes-not-urgent.

Tony

> ---
>  arch/arm/boot/dts/am335x-boneblack.dts | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
> index 6b71ad95a5cf..305975d3f531 100644
> --- a/arch/arm/boot/dts/am335x-boneblack.dts
> +++ b/arch/arm/boot/dts/am335x-boneblack.dts
> @@ -26,7 +26,6 @@
>  	pinctrl-0 = <&emmc_pins>;
>  	bus-width = <8>;
>  	status = "okay";
> -	ti,vcc-aux-disable-is-sleep;
>  };
>  
>  &am33xx_pinmux {
> -- 
> 1.8.3.2
> 
