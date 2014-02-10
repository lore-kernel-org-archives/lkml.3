Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBJJ7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:59:45 -0500
Received: from antcom.de ([46.38.233.243]:52328 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaBJJ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:59:43 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2014 04:59:43 EST
Message-ID: <52F8A094.2000608@antcom.de>
Date: Mon, 10 Feb 2014 10:49:08 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] ARM: lpc32xx: don't select HAVE_PWM
References: <003901cf25fc$73002790$590076b0$%han@samsung.com> <003b01cf25fc$bd4b51d0$37e1f570$%han@samsung.com>
In-Reply-To: <003b01cf25fc$bd4b51d0$37e1f570$%han@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/14 02:09, Jingoo Han wrote:
> The HAVE_PWM symbol is only for legacy platforms that provide
> the PWM API without using the generic framework. The lpc32xx
> platforms use the generic PWM framework, after the commit "2132fa8
> pwm: add lpc32xx PWM support".
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  arch/arm/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e254198..897fa15 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -632,7 +632,6 @@ config ARCH_LPC32XX
>  	select CPU_ARM926T
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_IDE
> -	select HAVE_PWM
>  	select USB_ARCH_HAS_OHCI
>  	select USE_OF
>  	help
> 

Acked-by: Roland Stigge <stigge@antcom.de>
