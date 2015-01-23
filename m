Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbbAWKeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:34:07 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39559 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbbAWKeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:34:05 -0500
MIME-Version: 1.0
In-Reply-To: <1422008501.30730.22.camel@x220>
References: <1422008501.30730.22.camel@x220>
Date: Fri, 23 Jan 2015 16:04:04 +0530
Message-ID: <CAJe_ZhcVZNzbEiVBsvHDqsYOdCXA9fmZuHrQMQ-jFDWuoobovQ@mail.gmail.com>
Subject: Re: gpio: ARCH_MB86S7X?
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Andy Green <andy.green@linaro.org>,
        Vincent Yang <Vincent.Yang@tw.fujitsu.com>,
        Tetsuya Nuriya <nuriya.tetsuya@jp.fujitsu.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 23 January 2015 at 15:51, Paul Bolle <pebolle@tiscali.nl> wrote:
> Jassi,
>
> Your commit 0da094d82c27 ("gpio: Add Fujitsu MB86S7x GPIO driver") is
> included in today's linux-next (ie, next-20150123). I noticed because a
> script I use to check linux-next spotted a problem in it.
>
> That commit added the Kconfig symbol GPIO_MB86S7X and made it depend on
> ARCH_MB86S7X. But there's no Kconfig symbol ARCH_MB86S7X in linux-next.
> I assume a patch to add that symbol is queued somewhere. Is that
> correct?
>
We are adding support for new Fujitsu platform MB86S7x. v4 of the
patchset has been submitted, we are hoping it gets upstream coming
merge window. However, the arch patches haven't been picked so far.

> Please note that I actually managed to cross-compile
> drivers/gpio/gpio-mb86s7x.c with this command:
>     make ARCH=arm CROSS_COMPILE=arm-linux-gnu- EXTRA_CFLAGS="-DCONFIG_GPIOLIB=y" drivers/gpio/gpio-mb86s7x.o
>
> So, for what it's worth, that dependency appears to be not needed to
> build this driver.
>
Linus.W, what do you suggest? Just drop the dependency?

Thanks
-Jassi
