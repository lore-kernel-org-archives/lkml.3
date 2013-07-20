Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3GTUpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:45:31 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54658 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3GTUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:45:30 -0400
MIME-Version: 1.0
In-Reply-To: <1374048297-4321-1-git-send-email-jonas.jensen@gmail.com>
References: <1373985880-23469-1-git-send-email-jonas.jensen@gmail.com>
	<1374048297-4321-1-git-send-email-jonas.jensen@gmail.com>
Date: Sat, 20 Jul 2013 22:45:29 +0200
Message-ID: <CACRpkdYktthfRsn9=9GjphXUbOEAswdCZCM48KFK2WRgBdj-Qw@mail.gmail.com>
Subject: Re: [PATCH v9] ARM: clocksource: add support for MOXA ART SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 10:04 AM, Jonas Jensen <jonas.jensen@gmail.com> wrote:

> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/irqreturn.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/io.h>
> +#include <linux/clocksource.h>

#include <linux/bitops.h>

> +#define TIMEREG_CR_1_ENABLE    BIT(0)

Because BIT() comes from there. And we shall not rely on
implicit #inclusion.

Apart from that:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
