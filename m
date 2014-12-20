Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaLTPLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 10:11:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58547 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaLTPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 10:11:10 -0500
Date: Sat, 20 Dec 2014 16:11:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>, mjg59@srcf.ucam.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Message-ID: <20141220151108.GA11752@amd>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
 <201412052207.35676@pali>
 <20141203180329.GB20370@vmdeb7>
 <201412201010.18151@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412201010.18151@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Ok, I agree that it is subjective how serious it is...
> > > Just to remind that patch fixing problem described in
> > > 
> > > http://www.spinics.net/lists/platform-driver-x86/msg05922.ht
> > > ml
> > > http://www.spinics.net/lists/platform-driver-x86/msg05924.h
> > > tml
> > 
> > I don't have any objection to sending this back to stable.
> > Stable is for fixing REAL bugs, as opposed to theorhetical
> > races, etc. This is a "real" bug.
> > 
> > As to not chaning behavior, if it's OK for mainline, it's OK
> > for stable. At least that is my understanding of it. Folks
> > are free to verify with Greg if they disagree.
> 
> Darren, so how you decided? Now when patches are in linus tree, 
> are you going to send them to stable tree?

Please don't. -stable is for serious mainline bugs people are actually
hitting. Null pointer dereference counts, if people actually hit
it. This is more behaviour change, and yes, the new behaviour is
better, but it is really different class.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
