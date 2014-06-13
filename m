Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaFMKcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:32:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50337 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaFMKcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:32:18 -0400
Date: Fri, 13 Jun 2014 12:32:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Daniel Phillips <daniel@phunq.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140613103216.GA4589@amd.pavel.ucw.cz>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard>
 <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520031802.GF18954@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > As I said, the glaring omission is proper ENOSPC handling, which is
> > work in progress. I do not view that as an obstacle to merging.
> >
> > After all, Btrfs did not have proper ENOSPC handling when it was
> > merged.
> 
> Yup, and that was a big mistake. Hence not having working ENOSPC
> detection is a major strike against merging a new filesystem now.

Hmm, it seems that merging filesystems is getting harder over
time. Soon, it will be impossible to merge new filesystem.

> > The design is here:
> 
> So come back when you've implemented it properly and proven that you
> have a sound design and clean implementation.

People submit code early to get feedback... but this is not exactly
helpful feedback, I'm afraid...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
