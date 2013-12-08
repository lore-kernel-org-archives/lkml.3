Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3LHMrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 07:47:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53424 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3LHMro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 07:47:44 -0500
Date: Sun, 8 Dec 2013 13:47:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessarily gendered language
Message-ID: <20131208124742.GD14108@amd.pavel.ucw.cz>
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
 <20131205104808.GA6455@amd.pavel.ucw.cz>
 <20131205165429.34468e1b@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205165429.34468e1b@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > (And I'm pretty sure most people will parse it the wrong way.)
> > 
> > > @@ -23,7 +24,7 @@ Quota netlink interface
> > >  When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
> > >  quota subsystem traditionally printed a message to the controlling terminal of
> > >  the process which caused the excess. This method has the disadvantage that
> > > -when user is using a graphical desktop he usually cannot see the message.
> > > +when user is using a graphical desktop they usually cannot see the
> > >  message.
> > 
> > Is this even correct english?
> 
> That would depend who you ask and English has no "correct". There are
> people who will go to the grave refusing to split an infinitive let alone
> use "their" in this fashion, but it does reflect modern English language
> usage in much of the UK. Some areas of the UK ascribe gender to a lot of
> objects not just the usual bizarre exception of ships and trains 8) so
> don't expect consensus.

Usually, "would newspaper be willing to print it" is used test for
"correct".

> really wants fixing for other language reasons anyway. In fact the whole
> paragraph wants a rewrite - but I appreciate the author of that text was
> not first language English.

Well, a lot of kernel users/developers do not have English as first
language. Yes, documentation would use many improvements, but banning
word "he" does not seem like one of them. "They" convention is quite
confusing for non-native speakers...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
