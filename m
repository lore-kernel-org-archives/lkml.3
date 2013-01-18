Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3ARWds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:33:48 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42411 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3ARWdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:33:46 -0500
MIME-Version: 1.0
In-Reply-To: <1358495866-9329-1-git-send-email-shawn.guo@linaro.org>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
	<1358495866-9329-1-git-send-email-shawn.guo@linaro.org>
Date: Fri, 18 Jan 2013 23:33:45 +0100
Message-ID: <CACRpkdZA9O6N7hmtU-6R1Ff6hW5vjD_ar9RLG1dbkd+MWyoKiw@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: devm_gpio_* support should not depend on GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 8:57 AM, Shawn Guo <shawn.guo@linaro.org> wrote:

> Some architectures (e.g. blackfin) provide gpio API without requiring
> GPIOLIB support (ARCH_WANT_OPTIONAL_GPIOLIB).  devm_gpio_* functions
> should also work for these architectures, since they do not really
> depend on GPIOLIB.
>
> Add a new option GPIO_DEVRES (enabled by default) to control the build
> of devres.c.  It also removes the empty version of devm_gpio_*
> functions for !GENERIC_GPIO build from linux/gpio.h, and moves the
> function declarations from asm-generic/gpio.h into linux/gpio.h.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

OK I removed the old version of the patch and pushed this instead.

Thanks!
Linus Walleij
