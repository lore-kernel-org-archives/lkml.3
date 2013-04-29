Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab3D2QuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:50:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48754 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757691Ab3D2QuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:50:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18IN/yjgmk8mBoMQXjCYimdPyrjGM9i2F0=
Date: Mon, 29 Apr 2013 12:50:06 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: fix Dove cpu type from V7 to PJ4
Message-ID: <20130429165006.GR32497@titan.lakedaemon.net>
References: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 04:06:51PM +0100, Sebastian Hesselbarth wrote:
> The CPU used in Marvell Dove SoCs is a PJ4 Sheeva core. Using
> CONFIG_CPU_PJ4 instead of CONFIG_CPU_V7 will also allow to enable
> iWMMXt extensions on Dove.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Sebastian,

It looks as though Russell's fix for IWMMXT made it in.  Please place
this patch in Russell's patch tracker.  If you don't have the original
thread, Andrew Lunn gave this an Acked-by.  Now me as well:

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.

> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 2c3bdce..4fc9bca 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -556,7 +556,7 @@ config ARCH_IXP4XX
>  config ARCH_DOVE
>  	bool "Marvell Dove"
>  	select ARCH_REQUIRE_GPIOLIB
> -	select CPU_V7
> +	select CPU_PJ4
>  	select GENERIC_CLOCKEVENTS
>  	select MIGHT_HAVE_PCI
>  	select PINCTRL
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
