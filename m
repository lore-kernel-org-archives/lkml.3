Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaAIFwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:52:34 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59031 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAIFwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:52:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140109164948.6a7341cfbd92258bc8d522e3@canb.auug.org.au>
References: <20140109164948.6a7341cfbd92258bc8d522e3@canb.auug.org.au>
Date: Thu, 9 Jan 2014 11:22:32 +0530
Message-ID: <CAK9yfHzFYQHLx9ALOPx+973WeamJCVQZXq61ZWG7TpnuPukDcA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the gpio tree with the leds tree
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>, Bryan Wu <cooloney@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2014 11:19, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Linus,
>
> Today's linux-next merge of the gpio tree got a conflict in
> drivers/leds/leds-s3c24xx.c between commit cfc7937fb6bd ("leds: s3c24xx:
> Remove hardware.h inclusion") from the leds tree and commit 224feb33a645
> ("leds: s3c24xx: Fix build failure") from the gpio tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/leds/leds-s3c24xx.c
> index b7876eb09e8c,87cf215af798..000000000000
> --- a/drivers/leds/leds-s3c24xx.c
> +++ b/drivers/leds/leds-s3c24xx.c
> @@@ -18,9 -18,11 +18,10 @@@
>   #include <linux/gpio.h>
>   #include <linux/slab.h>
>   #include <linux/module.h>
>  +#include <linux/platform_data/leds-s3c24xx.h>
>
>  -#include <mach/hardware.h>
>   #include <mach/regs-gpio.h>
> + #include <plat/gpio-cfg.h>
>  -#include <linux/platform_data/leds-s3c24xx.h>
>
>   /* our context */
>

Looks good. Thanks Stephen.

-- 
With warm regards,
Sachin
