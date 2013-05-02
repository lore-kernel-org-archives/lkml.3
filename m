Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab3EBKwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:52:10 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:56467 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab3EBKwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:52:07 -0400
Date: Thu, 2 May 2013 11:52:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com
Subject: Re: [PATCH 09/10] ARM: ux500: Remove ux500-musb platform registation
 when booting with DT
Message-ID: <20130502105202.GJ25256@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366729394-11406-10-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Lee Jones wrote:

> Now the ux500-musb driver has been enabled for Device Tree, there is no
> requirement to register it from platform code.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/cpu-db8500.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> index 5a6b9ae..36ef6ed 100644
> --- a/arch/arm/mach-ux500/cpu-db8500.c
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -227,8 +227,6 @@ static struct device * __init u8500_of_init_devices(void)
>  {
>  	struct device *parent = db8500_soc_device_init();
>  
> -	db8500_add_usb(parent, usb_db8500_dma_cfg, usb_db8500_dma_cfg);
> -
>  	return parent;
>  }

Linus, poke.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
