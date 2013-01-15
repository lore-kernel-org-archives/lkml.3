Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3AOWKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:10:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41452 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab3AOWKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:10:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: fb: Rework locking to fix lock ordering on takeover
Date: Tue, 15 Jan 2013 23:15:57 +0100
Message-ID: <2134971.95J30N79hk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+icZUVJ5hbPJvV4LMFGgD3Sto5=EV=MO9nutYdJwkiRrmpNJQ@mail.gmail.com>
References: <CA+icZUVJ5hbPJvV4LMFGgD3Sto5=EV=MO9nutYdJwkiRrmpNJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 13, 2013 04:14:38 PM Sedat Dilek wrote:
> Hi Andrew,
> 
> your patch from [1] - as far as I followed - misses a lot of
> Reported-by#s and Tested-by#s (Boris, Jiri, etc.).
> Just one new R-b I have seen yesterday.
> 
> I have the original patch from Alan plus the two follow-ups from you
> in my patch-series against v3.8-{rc2,rc3} for quite a while.
> So, please feel free to add a Tested-by.
> 
> Unfortunately, your patch has introduced some (unwanted) extra chars
> like "_*" (comments only).
> I appreciate one single (new) patch like this, but please in a proper way.

Why don't you prepare such a patch?  I suppose you know everything you need?

> A disappeared/busy/not-answering maintainer is not an excuse for
> handling serious regressions (even here in this case there are fixes
> around),
> Personally, I am still missing a mei-driver fix [2] and a libata-dev fix [3].
> Both issues are not new to the maintainers.
> Not sure if shouting louder is the best strategy here.

[2] seems to be in the Greg's tree, so I suppose it's on its way to Linus and
please note that we're after a several days vacation period and people need to
process their backlogs.

Perhaps just ping the relevant maintainers when 3.8-rc4 is out (and do the same
after -rc5 and so on).

> It would be great to have a place like a "board of arbitration" where
> someone can send blames.
> And I remember vaguely Rafael had a nice list of issues (w/ reference
> to patches!).
> This was a real cool helpful innoivation!
> I can't remember why Rafael stopped his nice service to the
> Linux-kernel community.

Because I don't have the time to do that any more.  Yes, it was useful, but it
also was quite a bit of work.  Would you volunteer to do that?

Rafael


> [1] https://patchwork.kernel.org/patch/1969391/
> [2] http://git.kernel.org/?p=linux/kernel/git/gregkh/char-misc.git;a=commitdiff;h=e6028db0146cf5a68dbd1508225ea49840997880
> [3] http://patchwork.ozlabs.org/patch/206897/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
