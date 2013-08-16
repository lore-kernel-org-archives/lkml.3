Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3HPPCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:02:24 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:54654 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3HPPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:02:21 -0400
Date: Fri, 16 Aug 2013 11:02:20 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Message-ID: <82440653.410050.1376665340121.JavaMail.root@mail>
In-Reply-To: <CACRpkdZdeVNtJSmc6Lr6j=oO9FLsAvjyrwhYS0j4OoAEhxCN9g@mail.gmail.com>
Subject: Re: [PATCH] gpio: (gpio-pca953x) move header to
 linux/platform_data/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC28 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

You wrote:
> But:
> 
> >  drivers/gpio/gpio-pca953x.c                 |  2 +-
> (...)
> > diff --git a/drivers/gpio/gpio-pca953x.c
> > b/drivers/gpio/gpio-pca953x.c
> > index 426c51d..8804aec 100644
> > --- a/drivers/gpio/gpio-pca953x.c
> > +++ b/drivers/gpio/gpio-pca953x.c
> > @@ -18,7 +18,7 @@
> >  #include <linux/irq.h>
> >  #include <linux/irqdomain.h>
> >  #include <linux/i2c.h>
> > -#include <linux/i2c/pca953x.h>
> > +#include <linux/platform_data/pca953x.h>
> 
> Why does the GPIO driver need platform data from the
> I2C driver???
> 
> Can't this just be made to go away?

I didn't dig that much in the driver, but I cannot imagine
another way to pass, for instance, the setup callback.

What would be a good alternative for you?

Regards,
Vivien
