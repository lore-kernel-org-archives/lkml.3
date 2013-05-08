Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3EHDSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:18:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11394 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751592Ab3EHDSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:18:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+KOvOrTT8GFFV2MOJ44SfN
Date: Tue, 7 May 2013 20:17:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL 4/5] ARM: arm-soc: late cleanups
Message-ID: <20130508031758.GT28721@atomide.com>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
 <1367947574-2934383-5-git-send-email-arnd@arndb.de>
 <20130507231925.GR28721@atomide.com>
 <CA+55aFxHZSYV3UZMf+ezADX5z2psLm5a9Wpp6qcDQho7n2J6SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxHZSYV3UZMf+ezADX5z2psLm5a9Wpp6qcDQho7n2J6SA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [130507 18:05]:
> On Tue, May 7, 2013 at 4:19 PM, Tony Lindgren <tony@atomide.com> wrote:
> >
> >> Vaibhav Hiremath (1):
> >>       ARM: OMAP2+: Fix mismerge for timer.c between ff931c82 and da4a686a
> >
> > Turns out this urgent boot fix got undone in the merge somehow.
> 
> Those lines actually disappeared already much earlier in my merge 6fa52ed33bea:
> 
>     Merge tag 'drivers-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> 
> last Saturday.

Yes then we patched it on Sunday, and Arnd merged it into his branch.
But then hose lines disappeared again for the third time :)
 
> And it's my bad. I even know how it happened: I ended up doing that
> merge twice (because I had to go back and fix something else), and
> then I "optimized" it the second time. With all the omap2 conflicts
> from that tree came from duplicate commits from the ARM tree, and I
> ended up just taking the drivers-for-linus side for
> arch/arm/mach-omap2. Which was correct for the other two files in
> there (gpmc.c and gpmc-onenand.c). but the timer.c file had changes
> from the arm tree.
> 
> Sorry about that one.

No problem, thanks for fixing it quickly.

Regards, 

Tony
