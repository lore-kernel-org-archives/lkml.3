Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3BIKMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:12:01 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:33836 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3BIKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:10:04 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/9] gpiolib: use gpio_chips list in gpiochip_find
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
In-Reply-To: <CACRpkdaVwjv2DwSx667sgVkHqx-tHsy6A0mP-kvq6h9nDDBrGA@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-5-git-send-email-acourbot@nvidia.com> <CACRpkdaVwjv2DwSx667sgVkHqx-tHsy6A0mP-kvq6h9nDDBrGA@mail.gmail.com>
Date: Sat, 09 Feb 2013 09:25:25 +0000
Message-Id: <20130209092525.9F9A23E2C48@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 18:05:32 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > Using the GPIO chips list is much faster than parsing the entire GPIO
> > number space.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> You don't say :-)
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

