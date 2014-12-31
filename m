Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaLaIWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:22:30 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40981 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaLaIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:22:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141208071930.GA20802@dtor-ws>
References: <20141208071930.GA20802@dtor-ws>
Date: Wed, 31 Dec 2014 09:22:27 +0100
Message-ID: <CACRpkdZ3PHGRG400Y9zo9RKGyyFm9qF7rZZa8PGpT6AStjUhYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: gpio_keys - allow separating gpio and irq in
 device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 8:19 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> This change allows specify interrupt for buttons separately form gpio,
> potentially allowing to form several "clusters" of buttons on
> different interrupts.
>
> Button defined without both gpio and irq in device tree is a hared error

hared?

> instead of a warning now.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

...but it would be nice if it could also be converted to use GPIO
descriptors internally at some point.

Yours,
Linus Walleij
