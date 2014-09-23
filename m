Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaIWPrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:47:19 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44888 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaIWPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <1409946775-24076-1-git-send-email-nm@ti.com>
References: <1409946775-24076-1-git-send-email-nm@ti.com>
Date: Tue, 23 Sep 2014 17:47:13 +0200
Message-ID: <CACRpkdYh-AWN6y_cfn6sg9j-hYYkLYbf-3Vcnsv+u5WOO9hxLQ@mail.gmail.com>
Subject: Re: [RESEND PATCH] gpio: omap: Fix interrupt names
From: Linus Walleij <linus.walleij@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 9:52 PM, Nishanth Menon <nm@ti.com> wrote:

> When viewing the /proc/interrupts, there is no information about which
> GPIO bank a specific gpio interrupt is hooked on to. This is more than a
> bit irritating as such information can esily be provided back to the
> user and at times, can be crucial for debug.
>
> So, instead of displaying something like:
> 31:     0       0  GPIO   0  palmas
> 32:     0       0  GPIO  27  mmc0
>
> Display the following with appropriate device name:
> 31:     0       0  4ae10000.gpio   0  palmas
> 32:     0       0  4805d000.gpio  27  mmc0
>
> This requires that we create irq_chip instance specific for each GPIO
> bank which is trivial to achieve.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Acked-by: Kevin Hilman <khilman@linaro.org>
> ---
> Requested to be resend by Javier with linux-gpio maintainers in CC.
>
> Original V1 of the patch: https://patchwork.kernel.org/patch/4757891/
>
> Probably belongs to 3.18 kernel series at this point in time.
>
> Changes since v1: just picked up Acks.

Patch applied.

Yours,
Linus Walleij
