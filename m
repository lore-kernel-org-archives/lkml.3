Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3BERFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:05:35 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:35239 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3BERFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:05:33 -0500
MIME-Version: 1.0
In-Reply-To: <1359822572-26009-5-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-5-git-send-email-acourbot@nvidia.com>
Date: Tue, 5 Feb 2013 18:05:32 +0100
Message-ID: <CACRpkdaVwjv2DwSx667sgVkHqx-tHsy6A0mP-kvq6h9nDDBrGA@mail.gmail.com>
Subject: Re: [PATCH 3/9] gpiolib: use gpio_chips list in gpiochip_find
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Using the GPIO chips list is much faster than parsing the entire GPIO
> number space.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

You don't say :-)
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
