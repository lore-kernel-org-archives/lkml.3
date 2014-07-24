Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428AbaGXI0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:26:10 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59829 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934120AbaGXI0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:26:07 -0400
MIME-Version: 1.0
In-Reply-To: <1406041261-5716-1-git-send-email-linux@roeck-us.net>
References: <1406041261-5716-1-git-send-email-linux@roeck-us.net>
Date: Thu, 24 Jul 2014 10:26:06 +0200
Message-ID: <CACRpkdZP377kmVYAMWaEg2wJy_P4S67xs857v3pNhTZwvp3ThA@mail.gmail.com>
Subject: Re: [PATCH v3] gpiolib: Export gpiochip_request_own_desc and gpiochip_free_own_desc
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 5:01 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> Both functions were introduced to let gpio drivers request their own
> gpio pins. Without exporting the functions, this can however only be
> used by gpio drivers built into the kernel.
>
> Secondary impact is that the functions can not currently be used by
> platform initialization code associated with the gpio-pca953x driver.
> This code permits auto-export of gpio pins through platform data, but
> if this functionality is used, the module can no longer be unloaded due
> to the problem solved with the introduction of gpiochip_request_own_desc
> and gpiochip_free_own_desc.
>
> Export both function so they can be used from modules and from
> platform initialization code.
>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3: Add API documentation.
>     Use EXPORT_SYMBOL_GPL.

Patch applied with the nice review tags.

Yours,
Linus Walleij
