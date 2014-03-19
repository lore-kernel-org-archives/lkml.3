Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbaCSB5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:57:39 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:38300 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaCSB5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <1625450.oZua1OVhNs@amdc1032>
References: <1625450.oZua1OVhNs@amdc1032>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 19 Mar 2014 10:57:16 +0900
Message-ID: <CAAVeFuLxN+uTKd7czB3jGvceWGgYv1o6O3sAXM9H6kUM9XmWmA@mail.gmail.com>
Subject: Re: [PATCH] gpio: iop: fix devm_ioremap_resource() return value checking
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 6:58 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> devm_ioremap_resource() returns a pointer to the remapped memory or
> an ERR_PTR() encoded error code on failure.  Fix the check inside
> iop3xx_gpio_probe() accordingly.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
