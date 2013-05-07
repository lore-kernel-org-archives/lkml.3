Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3EGRIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:08:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33834 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3EGRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:08:18 -0400
MIME-Version: 1.0
In-Reply-To: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
References: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
Date: Tue, 7 May 2013 10:02:22 -0700
X-Google-Sender-Auth: gZXDHrjZnQWYVelV6DuvY6f5Dto
Message-ID: <CA+55aFwMXmJ9V+3o62ELm-0NT1DaUCTvidmAhJSXzQcTMfJygA@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: Third batch of arm-soc changes for 3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 9:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I used a new script to create the pull requests this time, hope
> I got it right now.

So you seem to have blasted this series out with that automated
script, so they all got sent basically at the same timestamp, and they
are in the wrong order in my mailbox because email isn't that ordered.

Which is very annoying when there is no obvious way to tell what the
ordering between the pulls are *and* they are clearly not independent.
It turns out that I tried to merge "part 3" before "part 2", because I
hadn't noticed that small detail, and "part 3" was first in my inbox.

If you have pull requests that depend on each other, please number
them CLEARLY ("part 3" may sound clear, but it's not at all so when
I've done 123 merges in the last 10 days, and I can't remember if
perhaps two of those are earlier merges from you. Or at least delay
sending them out by a few seconds in between, so that email systems
don't tend to re-order them.

Or, in fact, preferably both.

Of course, when there aren't any dependencies between pull requests,
and the ordering doesn't matter, this isn't an issue. And *most* of
the time you either have sent out emails by hand (and there's been
that human delay and they arrived in the right order) or I've just
been lucky.

So if ordering matters, I really prefer to see [git pull 1/3] or
something like that at the beginning of the subject line. That is
visually clear, and unambiguous. And/or a few seconds or more between
sends - sure, email  may still get re-ordered, but in the modern world
that tends to be unlikely to happen for stuff that is more than a
second or two apart.

Please do NOT do what you did here. Everything got batched up and sent
in the same second, and the numbering was unclear AS HELL. There's a
"device tree changes, part 2", which isn't unreadable on its own (just
not very obvious), but THERE IS NO PART ONE! Similarly, there are
"arm-soc platform updates" parts 2 and 3, but again, there is no "part
1".

WTF? Seriously, I have no clue. Is the "late Exynos multiplatform
changes" the "part 1" of the device tree changes or the platform
changes? It could be either. And the "late cleanups"? Are they the
"part 1" of the other series (that didn't have the Exynos changes), or
are they "late" and come after everything?

Quite frankly, I'm not going to bother guessing after the first one I
took was clearly not the right one and gave the wrong diffstat etc, so
they are all thrown down the toilet.

Nothing pulled.

               Linus
