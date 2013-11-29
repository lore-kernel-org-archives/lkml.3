Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3K2IeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:34:00 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62695 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3K2Id5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:33:57 -0500
MIME-Version: 1.0
In-Reply-To: <1385048076-7875-2-git-send-email-grygorii.strashko@ti.com>
References: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
	<1385048076-7875-2-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 29 Nov 2013 09:33:56 +0100
Message-ID: <CACRpkdYpza8A27Ypz7absfhtauB7KXvKNvHVP3UjUJ1_hEpApg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: davinci: get rid of DAVINCI_N_GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 4:34 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> Since Davinci GPIO driver is moved to support gpiolib it has to use
> ARCH_NR_GPIOS (can be configured using CONFIG_ARCH_NR_GPIO Kconfig
> option) configuration instead of any mach/platform specific options.
>
> Hence, replace private DAVINCI_N_GPIO with common ARCH_NR_GPIOS. This is
> safe because default value for ARCH_NR_GPIOS=256 and maximum number of
> supported GPIOs for Davinci is DAVINCI_N_GPIO=144.
>
> More over, this is one of steps to re-use Davinci GPIO driver by other
> mach/platform.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Now we have a handful of people patching DaVinci GPIOs...

Sekhar: can you coordinate the different DaVinci patches? If you want me
to take a complete set of stuff at the end of the day you can give me a
pull request for inclusion into the GPIO tree.

Yours,
Linus Walleij
