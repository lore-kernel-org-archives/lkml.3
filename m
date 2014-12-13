Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031036AbaLMNxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 08:53:04 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:41140 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947AbaLMNxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 08:53:01 -0500
Date: Sat, 13 Dec 2014 13:52:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Maintainer abuse
Message-ID: <20141213135231.5684cf9d@lxorguk.ukuu.org.uk>
In-Reply-To: <20141212234336.GA28451@pd.tnic>
References: <alpine.DEB.2.11.1412130016090.16494@nanos>
	<20141212234336.GA28451@pd.tnic>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2014 00:43:36 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Dec 13, 2014 at 12:24:03AM +0100, Thomas Gleixner wrote:
> >  - Posting of massive patch sets right during or just before the merge
> >    window
> > 
> >  - Reposting of patchsets before the reviewer/maintainer had a chance
> >    to reply to ALL of N patches
> 
> Absolutely agreed.
> 
> The rule of sending out patches and collecting feedback for a week at
> least is not really being respected, from my experience. Shit gets
> blasted out at the highest rate possible. Maybe lkml should have a
> git-send-email throttle.

Every time anyone has tried to deal with Linux scaling problems by
throttling the rate it has failed, from the near forking of it when Linus
couldn't cope onwards. Today we are already seeing the same occurring
with all the vendor trees, and shared downstream trees with a rapidly
growing amount of stuff that simply isn't upstream because upstream can't
keep up with actual product timescales any more.

Leaving aside the small number of people who are just rude, there are
always going to be a lot of people who resend because they assume the
email was lost (as email is hopelessly unreliable nowdays), people who
don't understand, people whose managers don't understand, and people who
genuinely think their patch is important.

I'd ask two other questions instead

1. Why are they in your mailbox ?

Is it the year for a Google summer of code project or similar to turn
patchwork into a proper patch management tool (one that collects the
patches, provides a good maintainer interface, tells people automatically
that their patches are queued, deletes repeats, gives them status urls
they can give to managers or check, and also has the right bits
maintainer side to actually do stuff like send out "your patch set no
longer merges, please update" emails, and tell the maintainer if it
merges, the coding style important bits, etc and with buttons for "merge
me"

It could then be integrated into git (if only so we can have a "git lost"
command to block annoying sources)

2. Is X86 moving at a rate which needs some additional maintainers to
"maintain" the pending queue during merge windows and the like, and get
stuff into order for the maintainers proper ?

Alan
