Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaH2G57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:57:59 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:57701 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH2G55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:57:57 -0400
MIME-Version: 1.0
In-Reply-To: <1408467969-21226-3-git-send-email-acourbot@nvidia.com>
References: <1408467969-21226-1-git-send-email-acourbot@nvidia.com>
	<1408467969-21226-3-git-send-email-acourbot@nvidia.com>
Date: Fri, 29 Aug 2014 08:57:57 +0200
Message-ID: <CACRpkdb0uZ52E6ezTZ7d_HSZ96Ykf87xZ=kx2V2jF64yGvJazw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gpio: change gpiochip_request_own_desc() prototype
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 7:06 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> The current prototype of gpiochip_request_own_desc() requires to obtain
> a pointer to a descriptor. This is in contradiction to all other GPIO
> request schemes, and imposes an extra step of obtaining a descriptor to
> drivers. Most drivers actually cannot even perform that step since the
> function that does it (gpichip_get_desc()) is gpiolib-private.
>
> Change gpiochip_request_own_desc() to return a descriptor from a
> (chip, hwnum) tuple and update users of this function (currently
> gpiolib-acpi only).
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
