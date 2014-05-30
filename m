Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaE3ITQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:19:16 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:42078 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaE3ITN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:19:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140530160859.54642243@canb.auug.org.au>
References: <20140530160859.54642243@canb.auug.org.au>
Date: Fri, 30 May 2014 10:19:12 +0200
Message-ID: <CACRpkdaRFRwRHFUQ6oNLg0X5kJ-iigie+4t9Xu9ZcVpG9wMgww@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pinctrl tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 8:08 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
>
> After merging the pinctrl tree, today's linux-next build (arm multi_v7_defconfig)
> failed like this:
>
> drivers/pinctrl/sirf/pinctrl-sirf.c: In function 'sirfsoc_gpio_handle_irq':
> drivers/pinctrl/sirf/pinctrl-sirf.c:578:11: error: 'sgpio_chip' undeclared (first use in this function)
>
> Caused by commit 294d1351ff47 ("pinctrl: sirf: switch to using
> allocated state container").

Grr a bad cherry-pick from my side. I've fixed it up today.
Thanks a lot for this Stephen.

Yours,
Linus Walleij
