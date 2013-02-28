Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3B1Gmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:42:33 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53386 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3B1Gma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130228025931.GA13764@lizard.gateway.2wire.net>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
	<20130227231826.GA30154@lizard.fhda.edu>
	<CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
	<20130228013514.GA7556@lizard.fhda.edu>
	<CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com>
	<20130228025931.GA13764@lizard.gateway.2wire.net>
Date: Thu, 28 Feb 2013 07:42:30 +0100
X-Google-Sender-Auth: QE73w9tGZfmwME8P9rG6InJWa6g
Message-ID: <CAMuHMdXdzNGPy2b+QrzT++U+GX5FZ6X07ziOoVzNEo2EXNXQ7w@mail.gmail.com>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 3:59 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> On Wed, Feb 27, 2013 at 09:17:06PM -0500, Paul Gortmaker wrote:
> [...]
>> > Testing patches takes time, and if I have to do it for all bunch of
>> > different machines and architectures, it becomes mess and unmanageable. In
>>
>> So, you actually want my change then -- you do not want to test for
>> goldfish power issues unless goldfish is selected.  This is how I see
>> the situation.
>
> No, I want to cover as much as possible code in one go. This is not 'all
> or nothing' thing, plus I can't test whether the driver actually works,
> but testing that it compiles is a great deal, because quite often patches
> just don't compile. :-)

Indeed, I agree. I also want more build coverage.

BTW, sometimes I think our reviews are better in catching logical errors than
build/configuration errors. As soon as you fix the build, it just works ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
