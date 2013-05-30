Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967784Ab3E3HXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:23:04 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47554 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967699Ab3E3HW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:22:58 -0400
Date: Thu, 30 May 2013 09:22:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Basic perf PMU support for Haswell v12
Message-ID: <20130530072254.GA11890@gmail.com>
References: <1369261073-1275-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369261073-1275-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> v12: Rebase to 3.10-rc2
> Add mem-loads/stores support for parity with Sandy Bridge.
> Fix fixed counters (Thanks Ingo!)
> Make late ack optional
> Export new config bits in sysfs.
> Minor changes

Sigh, what you have not fixed in your patches are the basic stylistic 
mistakes I pointed out to the past:

   https://lkml.org/lkml/2013/5/1/78

(my previous feedback is also quoted below.)

Here checkpatch.pl says this about your series:

  total: 6 errors, 10 warnings, 662 lines checked

and a handful of those checkpatch.pl complaints are for valid, real 
problems.

Furthermore, you have not replied to any of those two mails of mine, nor 
have you fixed the stylistic problems I pointed out, in these latest 
patches!

To fix it simply follow the advice I gave you twice before: run 
scripts/checkpatch.pl against your patches and address any valid 
complaints it gives _BEFORE YOU RESUBMIT THEM_!

Andi, what the heck is going on here? Your behavior makes no sense to me. 
You are pretty much the only contributor I know who makes a habit out of 
willfully ignoring maintainer feedback...

Thanks,

	Ingo

--------------------->
* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > You say it's barebones, yet it does not work :-( How well was this 
> > > patch-set tested on non-Haswell hardware, which makes up 99.99% of our 
> > > installed base?
> > > 
> > > In particular, after applying your patches, 'perf top' stopped working 
> > > on an Intel testbox of mine:
> > 
> > The other problem I noticed was stylistic: when I applied your patches for 
> > testing even Git complained about their cleanliness ...
> > 
> > To quote from Documentation/SubmittingPatches:
> > 
> >   4) Style check your changes.
> > 
> >   Check your patch for basic style violations, details of which can be
> >   found in Documentation/CodingStyle.  Failure to do so simply wastes
> >   the reviewers time and will get your patch rejected, probably
> >   without even being read.
> > 
> >   At a minimum you should check your patches with the patch style
> >   checker prior to submission (scripts/checkpatch.pl).  You should
> >   be able to justify all violations that remain in your patch.
> > 
> > Please make your patches less sloppy!
> 
> Andi, you have not replied to this mail of mine.
> 
> What new measures are you taking to avoid such annoying stylistic problems 
> to creep into your patches?
> 
> These problems are regular in your patches and that has been going on for 
> years - causing maintenance overhead for many maintainers, not just me.
> 
> Apparently you are not using proper tooling (checkpatch.pl for example) to 
> check your patches. If you refuse to take action I will have to stop 
> dealing with your patches directly altogether - the overhead just does not 
> justify the effort. You'll need to get your patches reviewed by and signed 
> off by a more experienced kernel hacker who knows how to submit patches.
> 
> Thanks,
