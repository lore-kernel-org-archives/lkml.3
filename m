Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaFPP0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:26:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54477 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbaFPP0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:26:07 -0400
Message-ID: <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Tux3 for review
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: Pavel Machek <pavel@ucw.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 16 Jun 2014 08:25:54 -0700
In-Reply-To: <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
References: <5376B273.7000800@partner.samsung.com>
	 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
	 <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz>
	 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
	 <20140613202039.GA23872@amd.pavel.ucw.cz>
	 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-15 at 14:41 -0700, Daniel Phillips wrote:
> On Friday, June 13, 2014 1:20:39 PM PDT, Pavel Machek wrote:
> > Hi!
> >
> > On Fri 2014-06-13 10:49:39, Daniel Phillips wrote:
> >> Hi Pavel, On Friday, June 13, 2014 3:32:16 AM PDT, Pavel Machek wrote:
> >  ...
> >
> > Actually, would it make sense to have staging/fs/?
> 
> That makes sense to me, if a suitably expert and nonaligned maintainer can 
> be found

Really? We're at the passive aggressive implication that everyone's
against you now?  Can we get back to the technical discussion, please?

>  to sign up for a ridiculous amount of largely thankless, but 
> perhaps fascinating work. Any volunteers?

The whole suggestion is a non starter: we can't stage core API changes.
Even if we worked out how to do that, the staging trees mostly don't get
the type of in-depth expert review that you need anyway.

The Cardinal concern has always been the viability page forking and its
impact on writeback  ... and since writeback is our most difficult an
performance sensitive area, the bar to changing it is high.

When you presented page forking at LSF/MM in 2013, it didn't even stand
up to basic scrutiny before people found unresolved problems:

http://lwn.net/Articles/548091/

After lots of prodding, you finally coughed up a patch for discussion:

http://thread.gmane.org/gmane.linux.file-systems/85619

But then that petered out again.  I can't emphasise enough that
iterating these threads to a conclusion and reposting interface
suggestions is the way to proceed on this ... as far as I can tell from
the discussion, the reviewers were making helpful suggestions, even if
they didn't like the original interface you proposed.

James


