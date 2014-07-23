Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaGWPp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:45:28 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:56862 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbaGWPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <1406013463-19218-5-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
	<1406013463-19218-5-git-send-email-acourbot@nvidia.com>
Date: Wed, 23 Jul 2014 17:45:18 +0200
Message-ID: <CACRpkdZCJ2-2fx+1FGfvK6uvMG9oEH7RHCU8r50aoxKgSTjU6Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] gpio: remove gpiod_lock/unlock_as_irq()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 9:17 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> gpio_lock/unlock_as_irq() are working with (chip, offset) arguments and
> are thus not using the old integer namespace. Therefore, there is no
> reason to have gpiod variants of these functions working with
> descriptors, especially since the (chip, offset) tuple is more suitable
> to the users of these functions (GPIO drivers, whereas GPIO descriptors
> are targeted at GPIO consumers).
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Argh the mess is likely my fault for not having wrapped my head around
descriptors properly at the time.

Patch applied, naturally.

Yours,
Linus Walleij
