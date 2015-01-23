Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbbAWKYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:24:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49228 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753422AbbAWKYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:24:31 -0500
Date: Fri, 23 Jan 2015 11:24:26 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sylvain.rochet@finsecur.com, peda@axentia.se
Subject: Re: [PATCH 05/12] ARM: at91: move select SRAM to ARCH_AT91
Message-ID: <20150123102426.GG19922@piout.net>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
 <1421741825-18226-6-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421741825-18226-6-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/2015 at 16:16:58 +0800, Wenyou Yang wrote :
> Because the CONFIG_AT91_SLOW_CLOCK will be removed
> to simply the PM config, so move select SRAM.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  arch/arm/mach-at91/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 56dcede..7d5e201 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -6,6 +6,7 @@ config ARCH_AT91
>  	select PINCTRL
>  	select PINCTRL_AT91
>  	select USE_OF
> +	select SRAM if PM
>  	bool
>  
>  menuconfig SOC_SAM_V7
> @@ -128,7 +129,6 @@ comment "AT91 Feature Selections"
>  
>  config AT91_SLOW_CLOCK
>  	bool "Suspend-to-RAM disables main oscillator"
> -	select SRAM
>  	depends on SUSPEND
>  	help
>  	  Select this if you want Suspend-to-RAM to save the most power
> -- 
> 1.7.9.5
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
