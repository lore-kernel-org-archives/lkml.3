Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3LHMcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 07:32:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53176 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3LHMcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 07:32:08 -0500
Date: Sun, 8 Dec 2013 13:32:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>,
        pali.rohar@gmail.com, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
Message-ID: <20131208123205.GB14108@amd.pavel.ucw.cz>
References: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <52A16932.8020909@gmail.com>
 <20131206151030.GA22559@kroah.com>
 <52A2DF40.9070707@gmail.com>
 <20131208071857.GA12104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131208071857.GA12104@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> I guess the initial mail somehow didn't make it through your spam filter:
> > >> https://lkml.org/lkml/2013/12/1/70
> > > It did, but I thought that people asked for it to be changed in the
> > > thread afterwards, so I was expecting an updated version from you.
> > >
> > > Care to fix things up and resend it?
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Sure, the change I was asked for is trivial, but I didn't get the reason 
> > why it is needed. Neither there is a reply to my follow-up comment [0]. 
> > Sorry, I am pretty much new on LKML and could miss things that are 
> > supposed to be clear from the start, but my impression is that when 
> > someone says "it is better", he/she should explain why it is better or 
> > at least what is wrong with the patch he/she wants  to be changed.
> > 
> > However, I don't want to enter some arguing loop, so if you think I 
> > should change the code as per Joe's comment, just confirm it and I'll do it.
> 
> Please try.

Not checking sscanf() return is un-nice, so yes, it would be nice to
fix it, even if it will not happen in practice. 0 / -EINVAL is
acceptable return value.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
