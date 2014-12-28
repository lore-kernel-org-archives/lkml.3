Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaL1RxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 12:53:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37315 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaL1RxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 12:53:19 -0500
Date: Sun, 28 Dec 2014 18:53:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        linux-api@vger.kernel.org, john.stultz@linaro.org,
        viro@zeniv.linux.org.uk, arve@android.com
Subject: Andoid Binder sneaking in [was Re: [GIT PULL] Staging driver patches
 for 3.19-rc1]
Message-ID: <20141228175316.GC3922@amd>
References: <20141215175535.GA4665@kroah.com>
 <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
 <20141215183915.GA15554@infradead.org>
 <20141215184103.GA6761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215184103.GA6761@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-12-15 10:41:03, Greg KH wrote:
> On Mon, Dec 15, 2014 at 10:39:15AM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 15, 2014 at 07:23:35PM +0100, Richard Weinberger wrote:
> > > I don't understand this kind of logic.
> > > a) Binder is considered a piece of shite.
> > > b) Google is working on a (hopefully sane) replacement.
> > > 
> > > Why moving it out of staging then? What is the benefit?
> > 
> > There is none, and Greg didn't even bother addressing the various
> > comments when this first came up.
> 
> I thought I did, it was a long thread at the time, and I was on the road
> for 3 weeks, sorry if I missed something.

I pointed quite a lot of simple cleanups that could be done, but got
no feedback...

You should really post new version for review to people that commented
on the old one.

Plus "I set a rule that code must be cleaned in staging, and this is
not happening here, so it has to be moved to mainline, ignoring all
the usual rules" is quite interesting justification.

> > So a clear NAK from me on this one.
> 
> You don't have to maintain it, I do, so why does it concern you?

You ignored even NAKs from people that maintain stuff this interfaces with.

Late NAK here, too, FWIW. Because it is going to be used as an
argument "it is in mainline, so it must be ok". You are willing to
ignore mainline rules for this; it should be way easier to ignore
single staging rule for this one.
									
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
