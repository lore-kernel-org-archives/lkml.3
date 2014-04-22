Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbaDVM2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:28:31 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49581 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaDVM21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:28:27 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.51.154]
In-Reply-To: <CACRpkdYLaGXJ+O0rsL5+rjUsOvxCxK2b9QtH2j4FD0g21vx8_Q@mail.gmail.com>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
	<CACRpkdYLaGXJ+O0rsL5+rjUsOvxCxK2b9QtH2j4FD0g21vx8_Q@mail.gmail.com>
Date: Tue, 22 Apr 2014 14:28:25 +0200
Message-ID: <CABxcv=mb+CXQbrS==hBayMQGsaJCPuLR=xyW_BJpZm2oSNBu-w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] add gpio_chip_ops to hold GPIO operations
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Tue, Apr 22, 2014 at 1:36 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Apr 8, 2014 at 8:20 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>
>> So this is an RFC patch-set to add a virtual table to be used by
>> GPIO chip controllers and consist of the following patches:
>
> Overall I like this.
>
> However I don't want to see any transitional phase. I prefer a BIG
> fat patch converting everyone and its dog to the new vtable and
> removing the old function pointers. This can be based on the HEAD
> of my GPIO devel branch.
>

Ok, I was adding a commit per GPIO driver but the patch-set would have
been very big (~200 patches).

> It may be a good idea to use coccinelle for this refactoring in order
> not to miss any users.
>

Agreed, I was manually searching for users by using grep but I agree
that is much safer to use coccinelle for this. I don't have previous
experience writing coccinelle semantics patches though so it may take
more time than I thought but it is the perfect excuse to finally learn
how to do it :-)

Thanks a lot and best regards,
Javier

> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-gpio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
