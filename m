Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3CKB1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:27:03 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:56416 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3CKB1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:27:01 -0400
Message-ID: <513D32E3.1080101@gmail.com>
Date: Sun, 10 Mar 2013 20:26:59 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linus.walleij@linaro.org, marc.zyngier@arm.com, shawn.guo@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM:kernel: beautify code, using 'static const' instead
 of 'const static'
References: <513BE8FA.6080304@asianux.com>
In-Reply-To: <513BE8FA.6080304@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 07:59 PM, Chen Gang wrote:
> 
>   better using 'static const' instead of 'const static'
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm/kernel/smp_twd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
> index 3f25650..ef3e499 100644
> --- a/arch/arm/kernel/smp_twd.c
> +++ b/arch/arm/kernel/smp_twd.c
> @@ -362,7 +362,7 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
>  }
>  
>  #ifdef CONFIG_OF
> -const static struct of_device_id twd_of_match[] __initconst = {
> +static const struct of_device_id twd_of_match[] __initconst = {

This will go away with conversion to use CLKSRC_OF.

Rob

>  	{ .compatible = "arm,cortex-a9-twd-timer",	},
>  	{ .compatible = "arm,cortex-a5-twd-timer",	},
>  	{ .compatible = "arm,arm11mp-twd-timer",	},
> 

