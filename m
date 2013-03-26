Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079Ab3CZI2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:28:46 -0400
Received: from londo.lunn.ch ([80.238.139.98]:33705 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779Ab3CZI2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:28:44 -0400
Date: Tue, 26 Mar 2013 09:28:37 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: fix Dove cpu type from V7 to PJ4
Message-ID: <20130326082837.GO5627@lunn.ch>
References: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 04:06:51PM +0100, Sebastian Hesselbarth wrote:
> The CPU used in Marvell Dove SoCs is a PJ4 Sheeva core. Using
> CONFIG_CPU_PJ4 instead of CONFIG_CPU_V7 will also allow to enable
> iWMMXt extensions on Dove.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Andrew Lunn <andrew@lunn.ch>

> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
