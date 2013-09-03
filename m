Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3ICSU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:20:56 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:54765 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3ICSUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:20:55 -0400
Date: Tue, 3 Sep 2013 20:20:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] timers/nohz changes for v3.12
Message-ID: <20130903182052.GA30757@gmail.com>
References: <20130903141322.GA27504@gmail.com>
 <CAMuHMdWPE7OxWFNENe7qAx4+2rhMwbK6kG4LzXCxKMMKsxKM2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWPE7OxWFNENe7qAx4+2rhMwbK6kG4LzXCxKMMKsxKM2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Tue, Sep 3, 2013 at 4:13 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > Please pull the latest timers-nohz-for-linus git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus
> >
> >    HEAD: c2e7fcf53c3cb02b4ada1c66a9bc8a4d97d58aba nohz: Include local CPU in full dynticks global kick
> >
> > It mostly contains fixes and full dynticks off-case optimizations,
> > by Frederic Weisbecker.
> >
> > NOTE: for some reason my pull request scripts failed to generate a proper
> > diffstat so I've generated the shortlog and diffstat manually. All
> > resulting mistakes are mine.
> 
> You forgot to push timers-nohz-for-linus, or it hadn't propagated from
> ra.kernel.org to git.kernel.org?

Hm, it's visible here.

> git (1.7.9.5, Ubuntu 12.04LTS) doesn't seem to complain about missing or 
> stale branches on the remote, and just does something it thinks is 
> right.

My scripts check that the remote branch is visible and is the same as the 
local branch - but I guess there's a way that check can go wrong as well.

Thanks,

	Ingo
