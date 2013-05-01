Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab3EAKsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:48:30 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:52707 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3EAKsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:48:24 -0400
Date: Wed, 1 May 2013 12:48:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Basic perf PMU support for Haswell v11
Message-ID: <20130501104820.GA18969@gmail.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <20130426065503.GA31197@gmail.com>
 <20130426065926.GA31487@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426065926.GA31487@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > You say it's barebones, yet it does not work :-( How well was this 
> > patch-set tested on non-Haswell hardware, which makes up 99.99% of our 
> > installed base?
> > 
> > In particular, after applying your patches, 'perf top' stopped working 
> > on an Intel testbox of mine:
> 
> The other problem I noticed was stylistic: when I applied your patches for 
> testing even Git complained about their cleanliness ...
> 
> To quote from Documentation/SubmittingPatches:
> 
>   4) Style check your changes.
> 
>   Check your patch for basic style violations, details of which can be
>   found in Documentation/CodingStyle.  Failure to do so simply wastes
>   the reviewers time and will get your patch rejected, probably
>   without even being read.
> 
>   At a minimum you should check your patches with the patch style
>   checker prior to submission (scripts/checkpatch.pl).  You should
>   be able to justify all violations that remain in your patch.
> 
> Please make your patches less sloppy!

Andi, you have not replied to this mail of mine.

What new measures are you taking to avoid such annoying stylistic problems 
to creep into your patches?

These problems are regular in your patches and that has been going on for 
years - causing maintenance overhead for many maintainers, not just me.

Apparently you are not using proper tooling (checkpatch.pl for example) to 
check your patches. If you refuse to take action I will have to stop 
dealing with your patches directly altogether - the overhead just does not 
justify the effort. You'll need to get your patches reviewed by and signed 
off by a more experienced kernel hacker who knows how to submit patches.

Thanks,

	Ingo
