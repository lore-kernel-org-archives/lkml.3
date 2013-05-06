Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3EFG4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 02:56:24 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51562 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083Ab3EFG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 02:56:23 -0400
Date: Mon, 6 May 2013 12:25:53 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 61/63] ARM: ux500: Stop passing DMA platform data
 though AUXDATA
Message-ID: <20130506065552.GA14706@bnru10>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-62-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367591569-32197-62-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 16:32:47 +0200, Lee Jones wrote:
> The DMA platform data is now empty due to some recent refactoring,
> so there is no longer a requirement to pass it though.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/cpu-db8500.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> index a2c83c2..2b6cbde 100644
> --- a/arch/arm/mach-ux500/cpu-db8500.c
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -264,8 +264,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
>  	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
>  		"ux500-msp-i2s.3", &msp3_platform_data),
>  	/* Requires clock name bindings and channel address lookup table. */
> -	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000,
> -		       "dma40.0", &dma40_plat_data),
> +	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000, "dma40.0", NULL),

Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>

srinidhi
