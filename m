Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaGFJdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:33:23 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57800 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaGFJdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <1404467529-26301-1-git-send-email-tushar.b@samsung.com>
References: <1404467529-26301-1-git-send-email-tushar.b@samsung.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 6 Jul 2014 18:33:01 +0900
Message-ID: <CAAVeFuKNQ08o9ePQ6ERTcLq2PMf34oUuXHTyJgTeuTqsWOQJWg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: of: Update debug messages for of_get_named_gpiod_flags
To: Tushar Behera <tushar.b@samsung.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, trblinux@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 6:52 PM, Tushar Behera <tushar.b@samsung.com> wrote:
> Following is the debug output (only a few examples) before and after the patch.
>
> $ dmesg | grep of_get_named_gpiod_flags
>
> Before:
> of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12220000[0]'
> of_get_named_gpiod_flags exited with status 0
>
> After:
> of_get_named_gpiod_flags: can't parse 'wp-gpios' property of node '/mmc@12220000[0]'
> of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio-keys/power[0]' - status (0)
>
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>

More meaningful debug messages are always a good thing.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
