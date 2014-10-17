Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851AbaJQIFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:05:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46081 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753528AbaJQIEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:04:49 -0400
Date: Fri, 17 Oct 2014 10:04:45 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 2/3] ARM: at91: remove mach/atmel-mci.h
Message-ID: <20141017080445.GA32723@piout.net>
References: <1413532366-1317-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1413532366-1317-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413532366-1317-3-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/2014 at 09:52:45 +0200, Alexandre Belloni wrote :
> Use the generic platform_data header file instead of mach/atmel-mci.h
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c    |  2 +-
>  arch/arm/mach-at91/include/mach/atmel-mci.h | 17 -----------------
>  2 files changed, 1 insertion(+), 18 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/include/mach/atmel-mci.h
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 21ab782cc8e9..797433a5881a 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -17,8 +17,8 @@
>  #include <linux/clk.h>
>  #include <linux/platform_device.h>
>  #include <linux/i2c-gpio.h>
> -#include <linux/atmel-mci.h>

I sent the wrong series, I will respin

>  #include <linux/platform_data/crypto-atmel.h>
> +#include <linux/platform_data/mmc-atmel-mci.h>
>  

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
