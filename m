Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3HPNes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:34:48 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47206 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3HPNeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <1375304231-27281-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1375304231-27281-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Date: Fri, 16 Aug 2013 15:34:45 +0200
Message-ID: <CACRpkdZdeVNtJSmc6Lr6j=oO9FLsAvjyrwhYS0j4OoAEhxCN9g@mail.gmail.com>
Subject: Re: [PATCH] gpio: (gpio-pca953x) move header to linux/platform_data/
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@savoirfairelinux.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:57 PM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:

> This patch moves the pca953x.h header from include/linux/i2c to
> include/linux/platform_data and updates existing support accordingly.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

On the concept:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

But:

>  drivers/gpio/gpio-pca953x.c                 |  2 +-
(...)
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index 426c51d..8804aec 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -18,7 +18,7 @@
>  #include <linux/irq.h>
>  #include <linux/irqdomain.h>
>  #include <linux/i2c.h>
> -#include <linux/i2c/pca953x.h>
> +#include <linux/platform_data/pca953x.h>

Why does the GPIO driver need platform data from the
I2C driver???

Can't this just be made to go away?

Yours,
Linus Walleij
