Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbaIKQTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:19:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:29047 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbaIKQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:19:32 -0400
Message-ID: <5411CB8F.4070006@atmel.com>
Date: Thu, 11 Sep 2014 18:19:27 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] ARM: at91: add sama5d4 support to sama5_defconfig
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com> <1410450852-1834-8-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410450852-1834-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 17:54, Alexandre Belloni :
> Add sama5d4 to sama5_defconfig to build kernel booting on both sama5d3 and
> samad4.
> 
> Note that earlyprintk can only be working for one or the other.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/configs/sama5_defconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
> index 96c15b775d57..a6c2409c4e14 100644
> --- a/arch/arm/configs/sama5_defconfig
> +++ b/arch/arm/configs/sama5_defconfig
> @@ -19,6 +19,7 @@ CONFIG_MODULE_FORCE_UNLOAD=y
>  CONFIG_ARCH_AT91=y
>  CONFIG_SOC_SAM_V7=y
>  CONFIG_SOC_SAMA5D3=y
> +CONFIG_SOC_SAMA5D4=y
>  CONFIG_MACH_SAMA5_DT=y
>  CONFIG_AEABI=y
>  CONFIG_UACCESS_WITH_MEMCPY=y
> @@ -66,7 +67,6 @@ CONFIG_MTD=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_CFI=y
> -CONFIG_MTD_M25P80=y

Well I would keep this one...

>  CONFIG_MTD_NAND=y
>  CONFIG_MTD_NAND_ATMEL=y
>  CONFIG_MTD_SPI_NOR=y
> 


-- 
Nicolas Ferre
