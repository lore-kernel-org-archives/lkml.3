Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaGKKfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:35:47 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34664 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGKKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140711102844.GA17147@pd.tnic>
References: <1405072301-8719-1-git-send-email-bp@alien8.de>
	<CAMuHMdXz9dYaWizBo1hxuPx_-Y40tx+TfzuTihR6BySU6a+3qw@mail.gmail.com>
	<20140711102844.GA17147@pd.tnic>
Date: Fri, 11 Jul 2014 12:35:43 +0200
X-Google-Sender-Auth: 5qJ6Bet00J4_OYuPTgRs7xkUCWQ
Message-ID: <CAMuHMdVNKD2DsmhrHGxyhGSQZX8MXFOHkr__jx-A9PWvrFCSpQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Get rid of __HAVE_ARCH_CMPXCHG
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:28 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Jul 11, 2014 at 12:19:43PM +0200, Geert Uytterhoeven wrote:
>> What about non-x86? __HAVE_ARCH_CMPXCHG isn't always defined.
>
> Bah, this hunk was definitely not supposed to be there. Thanks for the
> catch!

IC.

In that case you also want to add a (new) "#define __HAVE_ARCH_CMPXCHG 1"
to one of the shared x86 header files, right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
