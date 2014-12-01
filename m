Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaLAK5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:57:00 -0500
Received: from h1.radempa.de ([176.9.142.194]:59051 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaLAK46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:56:58 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2014 05:56:57 EST
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        javier.martinez@collabora.co.uk, acourbot@nvidia.com,
        swarren@nvidia.com, jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harald Geyer <lambda@stardust.g4.wien.funkfeuer.at>
Subject: Re: iio: dht11 broken
In-reply-to: <547B4464.9090300@nod.at>
References: <547B4464.9090300@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Sun, 30 Nov 2014 17:23:00 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4120.1417430951.1@stardust.g4.wien.funkfeuer.at>
Date: Mon, 01 Dec 2014 11:49:32 +0100
Message-Id: <E1XvOXs-00014Z-6F@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard!

Richard Weinberger writes:
> Staring with 3.12 gpiolib refuses to set an GPIO used as IRQ into output mode.
> see commit d468bf9e (gpio: add API to be strict about GPIO IRQ usage)
> The dht driver does this and is therefore not functional.
> As the dht11 driver got merged in 3.13 there is a high chance that it
> never worked.

Well, I'm developing on mxs and there it works on 3.13 and 3.14 at least.
(I have it in production using 3.14.18 ATM.)
 
> Harald, are you aware of this issue?

I got one report about this issue, but couldn't reproduce it yet and
the reporter didn't agree to quoting his messages to kernel mailing lists,
so this has been rather low priority on my todo list. Next plan is to
see if I can reproduce the issue on sunxi (A10).

However anybody able to reproduce this and willing to test patches, would
of course push this up on my todo list.

Any input from gpiolib people about what the proper fix would be in
their opinion, of course is appreciated. I don't think the dht11 driver
is doing anything unreasonable per se, so maybe they can clarify how
the API is intended to be used?

Harald
