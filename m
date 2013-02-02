Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3BBPBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:01:39 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53427 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3BBPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:01:37 -0500
MIME-Version: 1.0
In-Reply-To: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
References: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
Date: Sat, 2 Feb 2013 16:01:37 +0100
Message-ID: <CACRpkdbFTt3bN4y5QFMFq6dfAA3XOkKWF4FY5X4jcGfYbYvxOw@mail.gmail.com>
Subject: Re: [PATCH 0/2] gpiolib: remove gpiochip_reserve()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dirk Opfer <dirk@opfer-online.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 3:44 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> If Dmitri could give his Acked-by or Tested-by and one of the GPIO maintainers
> merge this series, I could go ahead with the deeper changes to gpiolib.

Good riddance.

Both patches applied to get some rotation in linux-next.

This is too good stuff to wait and I like to push this work ahead
a bit. I can still back them out if there is some problem on the
TOSA.


Yours,
Linus Walleij
