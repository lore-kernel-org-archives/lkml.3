Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3EXL0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:26:33 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:56358 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3EXL0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:26:32 -0400
Date: Fri, 24 May 2013 12:26:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH] ARM: ux500: regulators: Remove misleading comment
Message-ID: <20130524112627.GY22683@gmail.com>
References: <1369227995-17142-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369227995-17142-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013, Lee Jones wrote:

> This patch removes a comment which explains that the ab8505 platform
> uses the same initialisation settings as the ab8500. Well when this
> changed and the ab8505 started using its own set of initialisation
> values, someone forgot to remove it.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500-regulators.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
> index 33c353b..b34441b 100644
> --- a/arch/arm/mach-ux500/board-mop500-regulators.c
> +++ b/arch/arm/mach-ux500/board-mop500-regulators.c
> @@ -996,7 +996,6 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
>  	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
>  };
>  
> -/* Use the AB8500 init settings for AB8505 as they are the same right now */
>  struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
>  	.reg_init               = ab8505_reg_init,
>  	.num_reg_init           = ARRAY_SIZE(ab8505_reg_init),

This patch still stands though.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
