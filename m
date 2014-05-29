Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaE2S3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:29:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56815 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE2S3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:29:48 -0400
Date: Thu, 29 May 2014 20:29:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: dwalker@fifo99.com, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: msm: remove board file for Nexus One (ie.
 mahimahi)
Message-ID: <20140529182937.GA18230@amd.pavel.ucw.cz>
References: <1400101656.9826.4.camel@x220>
 <20140515174448.GA31159@fifo99.com>
 <1400177413.11786.11.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400177413.11786.11.camel@x220>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-05-15 20:10:13, Paul Bolle wrote:
> Daniel,
> 
> On Thu, 2014-05-15 at 17:44 +0000, dwalker@fifo99.com wrote:
> > On Wed, May 14, 2014 at 11:07:36PM +0200, Paul Bolle wrote:
> > > Commit 1b802ff79f03 ("arm: msm: add board file for Nexus One (ie.
> > > mahimahi)") added just board-mahimahi.c. It did not add
> > > board-mahimahi.h, Makefile changes or Kconfig changes.
> > > 
> > > Four years have passed and this file is still dangling. Remove it.
> > > 
> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > > ---
> > > Untested. But what to test here?
> > > 
> > I don't mine if Sapphire gets removed,
> 
> Could you ACK that patch, please?
> 
> >  but I'm working on this one now..
> 
> That's good to hear.
> 
> >  So I don't want it deleted.
> 
> This is not something I get to decide. Nevertheless, given that this
> file shouldn't have been merged to begin with, I'd appreciate it if some
> deadline could be agreed upon.

Daniel is working on solving that. That should be enough. It is not as
the file is great problem to anybody.

If it is not fixed within year, you may want to retransmit your patch.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
