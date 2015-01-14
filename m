Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbbANJVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:21:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:2407 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbbANJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:21:28 -0500
Message-ID: <54B63517.9030809@atmel.com>
Date: Wed, 14 Jan 2015 10:21:27 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-pcmcia@lists.infradead.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] pcmcia: at91_cf: depend on !ARCH_MULTIPLATFORM
References: <1421173685-21559-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421173685-21559-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2015 19:28, Alexandre Belloni a écrit :
> Until the driver is corrected to stop including mach/at91_ramc.h and using
> mach/io.h, it won't compile in a ARCH_MULTIPLATFORM configuration.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/pcmcia/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> index 910e90bf16c6..45f67c63d385 100644
> --- a/drivers/pcmcia/Kconfig
> +++ b/drivers/pcmcia/Kconfig
> @@ -276,6 +276,7 @@ config BFIN_CFPCMCIA
>  config AT91_CF
>  	tristate "AT91 CompactFlash Controller"
>  	depends on PCMCIA && ARCH_AT91
> +	depends on !ARCH_MULTIPLATFORM
>  	help
>  	  Say Y here to support the CompactFlash controller on AT91 chips.
>  	  Or choose M to compile the driver as a module named "at91_cf".
> 


-- 
Nicolas Ferre
