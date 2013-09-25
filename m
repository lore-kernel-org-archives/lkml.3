Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3IYXxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:53:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35146 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab3IYXxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:53:31 -0400
Date: Thu, 26 Sep 2013 01:53:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130925235329.GA25480@amd.pavel.ucw.cz>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130918092027.GA8325@amd.pavel.ucw.cz>
 <20130918141106.GH21559@radagast>
 <2758936.kqHJ9YzqCC@amdc1032>
 <20130925203558.GV10746@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925203558.GV10746@radagast>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Pavel, Felipe's remark was valid..
> > 
> > > > No, I'll not polish patch for hardware I don't have and have little
> > > > interest in.  wanted to help you, but according to your first reply,
> > > > you do not really want help.
> > > 
> > > that's your call. Now how about you stop being such a baby and go fix
> > > your mistakes to start with ? Just because I'm the maintainer of the
> > > gadget framework, doesn't mean I'm the maintainer of s3c-hsotc.c file.
> > > Maintainer != author too, btw.
> > > 
> > > Anyway, I got much better stuff to do than babysitting grown ups.
> > 
> > ..even if it could have been communicated in a gentler way.
> > 
> > Anyway s3c-hsotg.c is a driver for our hardware so I'm going to pick this
> > patch up, polish it and then re-submit it later. Thanks.
> 
> I tried a few times being nice and the response was always in the lines
> of "you should go fix the patch yourself if you don't like it" (not
> exactly these words, but same message). After some time of being nice
> and get nowhere, I just got fed up.

For the record, this is Felipe's idea of being nice:

> > > > > this is not how you send a patch, please read
> > > > > Documentation/SubmittingPatches

(What an useless reply. Yes, I know how to submit patches. I also know
that patches need to be tested, so I was not interested in "proper"
submission. I tried to explain the difference between submit patch for
inclusion and make someone look at the patch and fix the code...)

> > > > Have you considered possibility that this is how you nudge maintainer
> > > > into fix their coding style?

(Felipe)
> > > cute...
> > > 
> > > Seriously though, read that file, you're commit log has garbage in it
> > > which shouldn't go to git history.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
