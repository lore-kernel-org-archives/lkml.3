Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbbAUKFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:05:48 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33985 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbAUKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:05:45 -0500
MIME-Version: 1.0
In-Reply-To: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
Date: Wed, 21 Jan 2015 11:05:44 +0100
Message-ID: <CACRpkdYww-6HbmM9uViyB6ZRp2MQnkTYz-7ZxAVN_GsRTNqaoA@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: sa1100: add platform functions to handle PWER settings
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrea Adami <andrea.adami@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 11:09 AM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:

> PWER settings logically belongs neither to GPIO nor to system IRQ code.
> Add special functions to handle PWER (for GPIO and for system IRQs)
> from platform code.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

> diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
(...)
> +int sa11x0_gpio_set_wake(unsigned int gpio, unsigned int on)
(...)
> +int sa11x0_sc_set_wake(unsigned int irq, unsigned int on)

Why are these two functions not added to any .h file?

Did you miss to commit something or are there compile
warnings about this?

Yours,
Linus Walleij
