Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaFMUUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:20:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40231 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaFMUUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:20:41 -0400
Date: Fri, 13 Jun 2014 22:20:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <daniel@phunq.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140613202039.GA23872@amd.pavel.ucw.cz>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard>
 <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard>
 <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri 2014-06-13 10:49:39, Daniel Phillips wrote:
> Hi Pavel, On Friday, June 13, 2014 3:32:16 AM PDT, Pavel Machek wrote:
> >Hmm, it seems that merging filesystems is getting harder over
> >time. Soon, it will be impossible to merge new filesystem.
> 
> My thought exactly, but it carries more weight coming from you.
> 
> It is getting more unpleasant to discuss things on LKML in
> general, which tends to drive the design process away from
> public view, leaving only the dregs of politics and infighting
> for the public record. Perhaps some participants prefer it that
> way, but I am certainly not one of them.
> 
> I thought this issue was going to be addressed at last year's
> kernel summit.

Actually, would it make sense to have staging/fs/?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
