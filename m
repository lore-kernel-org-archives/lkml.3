Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbaFSIVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:21:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40765 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbaFSIVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:21:37 -0400
Date: Thu, 19 Jun 2014 10:21:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Daniel Phillips <daniel@phunq.net>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140619082129.GA4309@xo-6d-61-c0.localdomain>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard>
 <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard>
 <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-06-16 08:25:54, James Bottomley wrote:
> On Sun, 2014-06-15 at 14:41 -0700, Daniel Phillips wrote:
> > On Friday, June 13, 2014 1:20:39 PM PDT, Pavel Machek wrote:
> > > On Fri 2014-06-13 10:49:39, Daniel Phillips wrote:
> >  to sign up for a ridiculous amount of largely thankless, but 
> > perhaps fascinating work. Any volunteers?
> 
> The whole suggestion is a non starter: we can't stage core API changes.
> Even if we worked out how to do that, the staging trees mostly don't get
> the type of in-depth expert review that you need anyway.

Well.. most filesystems do not need any core API changes, right?

> The Cardinal concern has always been the viability page forking and its
> impact on writeback  ... and since writeback is our most difficult an
> performance sensitive area, the bar to changing it is high.

And in this particular case, Daniel was flamed for poor coding style, not
for page forking. So staging/ would actually help him -- he could concentrate
on core changes without being distracted by unimportant stuff.

> When you presented page forking at LSF/MM in 2013, it didn't even stand
> up to basic scrutiny before people found unresolved problems:
> 
> http://lwn.net/Articles/548091/
> 
> After lots of prodding, you finally coughed up a patch for discussion:
> 
> http://thread.gmane.org/gmane.linux.file-systems/85619
> 
> But then that petered out again.  I can't emphasise enough that
> iterating these threads to a conclusion and reposting interface
> suggestions is the way to proceed on this ... as far as I can tell from
> the discussion, the reviewers were making helpful suggestions, even if
> they didn't like the original interface you proposed.

This obviously needs to be solved, first...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
