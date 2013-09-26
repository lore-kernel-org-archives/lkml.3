Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3IZHSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:18:13 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33336 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3IZHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <1380071607.1974.78@driftwood>
References: <20130924214800.GV25647@n2100.arm.linux.org.uk>
	<1380071607.1974.78@driftwood>
Date: Thu, 26 Sep 2013 09:18:10 +0200
X-Google-Sender-Auth: cVni_3I7x04frVeTHRYlJVtfNhQ
Message-ID: <CAMuHMdXN3CgOt6Lk1S-xYjeeACOZtuxuYu2RqSGMoTvp9qz8Cg@mail.gmail.com>
Subject: Re: new binutils needed for arm in 3.12-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Wed, Sep 25, 2013 at 3:13 AM, Rob Landley <rob@landley.net> wrote:
> Some of us can't ship GPLv3 binaries and are looking forward to the day LLVM
> or some such provides a complete solution.

Sorry, I didn't have a coffee yet, but which subtility am I missing
that prohibits
you from shipping GPLv3 binaries?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
