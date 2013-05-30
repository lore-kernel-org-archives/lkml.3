Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3E3STH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:19:07 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60004 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3E3STC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-9-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
	<1369206634-6778-9-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:19:01 +0200
Message-ID: <CACRpkdauO5Tgkec-g5N85+M2AejUmvF+rO-5V7Yc5vKUMNpm4A@mail.gmail.com>
Subject: Re: [PATCH 08/11] ARM: davinci: start using gpiolib support
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 9:10 AM, Philip Avinash <avinashphilip@ti.com> wrote:

> - Remove NEED_MACH_GPIO_H config option for Davinci platforms to start
>   using common gpio library interface.
> - Added struct davinci_gpio_controller definitions in platform_data
>   directory for Davinci gpio devices.
> - Removed GPIO_TYPE_DAVINCI enum definition as GPIO Davinci is converted
>   to Linux device driver model.
>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

> +/* Convert GPIO signal to GPIO pin number */
> +#define GPIO_TO_PIN(bank, gpio)        (16 * (bank) + (gpio))

Hm not synonymous with pinctrl pins, well I guess I have to live
with this...

Yours,
Linus Walleij
