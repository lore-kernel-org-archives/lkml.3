Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaJ1QcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:32:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:38749 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJ1QcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:32:14 -0400
MIME-Version: 1.0
In-Reply-To: <1414052827-21942-1-git-send-email-acourbot@nvidia.com>
References: <1414052827-21942-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 28 Oct 2014 17:32:14 +0100
Message-ID: <CACRpkdbFYi3O7ONeo-Z1iA_ZkL-YSekL7hDz9Dj1eHdKe5y8Tg@mail.gmail.com>
Subject: Re: [PATCH] gpio: rename gpio_lock_as_irq to gpiochip_lock_as_irq
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:27 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> This function actually operates on a gpio_chip, so its prefix should
> reflect that fact for consistency with other functions defined in
> gpio/driver.h.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Just a consistency change ; hopefully we can slip this under the GPIO
> tree without getting acked-bys from each subsystem.

OK patch applied, hope I don't get too much breakage from new
drivers using the call. Maybe I'll have to apply the patch to
both the GPIO and pin control subsystem :-P

Yours,
Linus Walleij
