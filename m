Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaFVBGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 21:06:18 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55700 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbaFVBGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 21:06:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugGAIcrplN5LC2v/2dsb2JhbABZgw2DSFGnNAEBAQEBAQaZKgGBBBd1hAMBAQUjDwEjIxAIAQIYAgIFIQICDwUlAyETiEGNK5wlnXUXFoEUhDiDYIU0B4J3gUwEmkOTW4NUKw
Date: Sun, 22 Jun 2014 11:06:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Daniel Phillips <daniel@phunq.net>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140622010600.GX9508@dastard>
References: <20140520031802.GF18954@dastard>
 <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 12:29:01PM -0700, James Bottomley wrote:
> On Thu, 2014-06-19 at 14:58 -0700, Daniel Phillips wrote:
> > On Thursday, June 19, 2014 2:26:48 AM PDT, Lukáš Czerner wrote:
> > > Let me remind you some more important problems Dave brought up,
> > > including page forking:
> > >
> > > "
> > >  The hacks around VFS and MM functionality need to have demonstrated
> > >  methods for being removed.
> > 
> > We already removed 450 lines of core kernel workarounds from Tux3 with an 
> > approach that was literally cut and pasted from one of Dave's emails. Then 
> > Dave changed his mind. Now the Tux3 team has been assigned a research 
> > project to improve core kernel writeback instead of simply adapting the 
> > approach that is already proven to work well enough. That is a rather 
> > blatant example of "perfect is the enemy of good enough". Please read the 
> > thread.
> 
> That's a bit disingenuous: the concern has always been how page forking
> interacted with writeback.  It's not new, it was one of the major things
> brought up at LSF 14 months ago, so you weren't just assigned this.

BTW, it's worth noting that reviewers are *allowed* to change their
mind at any time during a discussion or during review cycles.
Indeed, this occurs quite commonly. It's no different to multiple
reviewers disagreeing on what the best way to make the improvement
is - sometimes it takes an implementation to solidify opinion on the
best approach to solving a problem.

i.e. it took an implementation of the writeback hook tailored
specifically to tux3's requirements to understand the best way to
solve the infrastructure problem for *everyone*. This is how review
is supposed to work - take an idea, and refine it into something
better that works for everyone.

We'd have been stuck way up the creek without a paddle a long time
ago if reviewers weren't allowed to change their minds....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
