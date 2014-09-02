Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaIBIhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:37:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:39244 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaIBIhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:37:05 -0400
Message-ID: <540581AB.6020101@atmel.com>
Date: Tue, 2 Sep 2014 10:36:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        <linux-mtd@lists.infradead.org>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 06/12] ARM: at91: add MTD_SPI_NOR (new dependency for
 M25P80)
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com> <1398925607-7482-7-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1398925607-7482-7-git-send-email-computersforpeace@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2014 08:26, Brian Norris :
> This defconfig contains the CONFIG_M25P80 symbol, which is now
> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> the new dependency.
> 
> At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Okay, now taken in at91-3.18-defconfig, thanks:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/configs/sama5_defconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
> index dc3881e07630..8282ebab6e52 100644
> --- a/arch/arm/configs/sama5_defconfig
> +++ b/arch/arm/configs/sama5_defconfig
> @@ -65,12 +65,12 @@ CONFIG_DEVTMPFS_MOUNT=y
>  # CONFIG_PREVENT_FIRMWARE_BUILD is not set
>  CONFIG_MTD=y
>  CONFIG_MTD_CMDLINE_PARTS=y
> -CONFIG_MTD_CHAR=y
>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_CFI=y
>  CONFIG_MTD_M25P80=y
>  CONFIG_MTD_NAND=y
>  CONFIG_MTD_NAND_ATMEL=y
> +CONFIG_MTD_SPI_NOR=y
>  CONFIG_MTD_UBI=y
>  CONFIG_MTD_UBI_GLUEBI=y
>  CONFIG_PROC_DEVICETREE=y
> 


-- 
Nicolas Ferre
