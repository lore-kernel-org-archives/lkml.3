Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbbANJVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:21:49 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:2446 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbbANJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:21:47 -0500
Message-ID: <54B6352B.8050508@atmel.com>
Date: Wed, 14 Jan 2015 10:21:47 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Tejun Heo <tj@kernel.org>
CC: <linux-ide@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "Boris Brezillon" <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ata: pata_at91: depend on !ARCH_MULTIPLATFORM
References: <1421173517-21246-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421173517-21246-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2015 19:25, Alexandre Belloni a écrit :
> Until the driver is corrected to stop using mach/at91isam9_smc.h, it won't
> compile in a ARCH_MULTIPLATFORM configuration.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/ata/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index a3a13605a9c4..5f601553b9b0 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -835,6 +835,7 @@ config PATA_AT32
>  config PATA_AT91
>  	tristate "PATA support for AT91SAM9260"
>  	depends on ARM && SOC_AT91SAM9
> +	depends on !ARCH_MULTIPLATFORM
>  	help
>  	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
>  
> 


-- 
Nicolas Ferre
