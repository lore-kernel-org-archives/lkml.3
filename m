Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3HBN4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:56:24 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47342 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3HBN4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:56:22 -0400
MIME-Version: 1.0
Date: Fri, 2 Aug 2013 15:56:21 +0200
X-Google-Sender-Auth: DZ1JDyB_7fyX0JYfWnVmbEhyZl4
Message-ID: <CAMuHMdWyhNopvvEMhjY-z2NTBo=CVWLt1Qa3ooJAEFoD0m29kA@mail.gmail.com>
Subject: Android Gmail app (was: Re: [PATCH] sched,x86: optimize switch_mm for
 multi-threaded workloads)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
        Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 7:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> It's normal. I occasionally write quick replies while on my phone, and
> the f*cking android gmail app cannot do plain-text mode. There are
> open bug tickets about it:
>
>    https://code.google.com/p/android/issues/detail?id=8712
>
> and I've talked in private to my google contacts too, but some
> ass-wipe inside the android team thinks that html-only mail is the
> right thing to do.

It's no longer open. It was closed as "WrongForum" :-(

So we'll have to keep on adding stars to conversations on our Android/Linux
devices, and reply when we get back to our GNU/Linux devices?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
