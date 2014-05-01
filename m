Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaEAOQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:16:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36244 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaEAOQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:16:35 -0400
Message-ID: <53625725.6060401@ti.com>
Date: Thu, 1 May 2014 10:16:05 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 03/12] ARM: keystone: add MTD_SPI_NOR (new dependency
 for M25P80)
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com> <1398925607-7482-4-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1398925607-7482-4-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2014 02:26 AM, Brian Norris wrote:
> This defconfig contains the CONFIG_M25P80 symbol, which is now
> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> the new dependency.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
I will pick this up for 3.16.

>  arch/arm/configs/keystone_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
> index ec9a41d50680..b3057730689f 100644
> --- a/arch/arm/configs/keystone_defconfig
> +++ b/arch/arm/configs/keystone_defconfig
> @@ -112,6 +112,7 @@ CONFIG_MTD_PLATRAM=y
>  CONFIG_MTD_M25P80=y
>  CONFIG_MTD_NAND=y
>  CONFIG_MTD_NAND_DAVINCI=y
> +CONFIG_MTD_SPI_NOR=y
>  CONFIG_MTD_UBI=y
>  CONFIG_PROC_DEVICETREE=y
>  CONFIG_BLK_DEV_LOOP=y
> 

