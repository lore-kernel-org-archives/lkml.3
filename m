Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3J2NZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:25:15 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59367 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3J2NZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:25:13 -0400
MIME-Version: 1.0
In-Reply-To: <20131029201013.cc93b7f5eca956bf6ff04e68@canb.auug.org.au>
References: <20131029201013.cc93b7f5eca956bf6ff04e68@canb.auug.org.au>
Date: Tue, 29 Oct 2013 14:25:12 +0100
Message-ID: <CACRpkdZ444P-zWx99T2+=nEO13Gbub2rYpE91eW0UoRFc4kdSg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (gpio
 tree related)
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have applied the following patch for today (it should go into the gpio
> tree if it is considered correct):
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Oct 2013 20:05:12 +1100
> Subject: [PATCH] gpiolib: include gpio/consumer.h in of_gpio.h for
>  desc_to_gpio()
>
> Fixes this build error on sparc:
>
> In file included from drivers/spi/spi.c:33:0:
> include/linux/of_gpio.h: In function 'of_get_named_gpio_flags':
> include/linux/of_gpio.h:93:3: error: implicit declaration of function 'desc_to_gpio' [-Werror=implicit-function-declaration]
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Patch applied, unless Alexandre has any considerations.

Yours,
Linus Walleij
