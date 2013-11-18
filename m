Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3KRJq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:46:28 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41626 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3KRJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:46:20 -0500
MIME-Version: 1.0
In-Reply-To: <1384605572-9811-1-git-send-email-acourbot@nvidia.com>
References: <1384605572-9811-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 18 Nov 2013 10:46:19 +0100
Message-ID: <CACRpkdYfdUEvs3D-+enB6sS+O_Ht9W+X=XTCty9ZtAfa+Wvm0Q@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix find_chip_by_name()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 1:39 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> find_chip_by_name() was incorrectly implemented by using
> gpio_lookup_list instead of gpiod_chips to iterate through all the
> registered GPIO controllers. This patch reimplements it by using
> gpiochip_find() with a custom search function, which simplifies the code
> on top of fixing the mistake.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied for fixes.

Yours,
Linus Walleij
