Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab3FRUhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:37:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59794 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab3FRUhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:37:15 -0400
Date: Tue, 18 Jun 2013 22:37:12 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Detlev Zundel <dzu@denx.de>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        trivial <trivial@kernel.org>
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
Message-ID: <20130618203712.GA29924@amd.pavel.ucw.cz>
References: <20130617134957.GA15602@amd.pavel.ucw.cz>
 <CACxGe6sO6Tes8en905cyJwP69w82PHjwKV9+XxxXhAPMRyGYkA@mail.gmail.com>
 <20130618125235.GA15122@amd.pavel.ucw.cz>
 <CACxGe6tLPfJ3KS6+4aO8s8emq8=ajuc+gmBtaEDqd60m4_vx6w@mail.gmail.com>
 <20130618142634.GB17361@amd.pavel.ucw.cz>
 <20130618175822.GB8386@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618175822.GB8386@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If device is initialized from device tree, but has no interrupt
> > assigned, uio will still try to request and interrupt old way,
> > fails, and fails registration.
> > 
> > This is wrong; don't try initializing irq using platform data if
> > device tree is available.
> > 
> > Simplified code based on suggestion by Grant Likely.
> > 
> > Fixed memory leak in "irq can not be registered" error path.
> > 
> > Signed-off-by: Pavel Machek <pavel@denx.de>
> > Reported-by: Detlev Zundel <dzu@denx.de>
> 
> I see a ton of patches in this thread, and have no idea which one is
> "newest" and correct.
> 
> Please resend, in a format that I do not have to edit at all (hint, the
> subject line counts), that I can apply properly.

I resent both patches, hopefully I got subject lines right this time.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
