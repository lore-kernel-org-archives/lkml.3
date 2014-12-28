Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaL1RxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 12:53:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37216 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaL1RxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 12:53:00 -0500
Date: Sun, 28 Dec 2014 18:52:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
Message-ID: <20141228175255.GB3922@amd>
References: <20141215175535.GA4665@kroah.com>
 <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
 <20141215183038.GA6120@kroah.com>
 <548F2A10.5070601@nod.at>
 <20141215184407.GB6761@kroah.com>
 <548F30D5.9020109@nod.at>
 <20141215193222.GA9842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215193222.GA9842@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon 2014-12-15 11:32:22, Greg KH wrote:
> On Mon, Dec 15, 2014 at 08:04:53PM +0100, Richard Weinberger wrote:
> > > Fact is, this is useful code, in this area.  In the domain it is used
> > > in, it works properly, and the abi is sufficient.  Yes, it's ugly in
> > > spaces, and insecure if used outside of Android, but that's ok for the
> > > users of the code.
> > 
> > Let's discuss this while having a few beers.
> > It is going to be philosophic.
> 
> I'm all for beers and philosopic talk, sounds good :)
> 
> > >> Is there a change that Android will pick it up?
> > > 
> > > Yes.
> > 
> > So then wait until this happens and ignore binder.
> 
> I have been, for years now.
> 
> But the issue is, drivers/staging/ should not just be a "dumping ground"
> for code.  Code in there needs to either move forward in being cleaned
> up and accepted, or it needs to be deleted.
> 
> This is the reason why I deleted the binder code from the tree a few
> years ago.  Turns out, that's the first commit vendors revert when they
> make an android product.  Then they add on a mis-match of patches on top
> of it, bringing the code kind-of-up-to-date with the newer kernel, and
> ship it.  That has caused problems by people not knowing what to apply
> and fix in order to handle abi changes.
> 
> So the code went back into staging, and got fixed up, and now that's as
> far as I can take it without either deleting it, or moving it out of
> staging.  So I'm trying to move it out of staging.
> 
> Now I know this is a "special case" for stuff that might be "ugly".
> Fact is, we are stuck with this user api due to ignoring this code for
> many years on the community side, as well as Google not taking the time
> and effort originally to push it upstream.  There is fault on both sides
> here, I agree.
> 
> And because of that, I'm willing to maintain this on our side.  I have
> confirmation that Google employees will also co-maintain it as well.
> But the userspace api is something that we just have to live with, as
> ugly as it is, until someone, who has the ability to commit to the
> Android userspace side, does the work.

Do we have to live with _all_ the parts of userspace API? I asked
about the debugfs parts before, but I don't think I got any reply.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
