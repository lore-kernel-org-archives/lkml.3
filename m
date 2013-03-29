Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3C2TAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:00:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53216
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251Ab3C2TAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:00:20 -0400
Date: Fri, 29 Mar 2013 13:00:17 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 3.9-rc
Message-ID: <20130329190017.GE2567@kernel.dk>
References: <20130329153831.GQ19488@kernel.dk>
 <CA+55aFwoj=g0YrFOrpoKNY43o8qDAhDEHSP-zrtpWCXciwz_-Q@mail.gmail.com>
 <20130329182411.GD2567@kernel.dk>
 <CA+55aFwWFma7qK3v7QtxRqp=GHnON8DF0kO84yDvsxu3nkb-xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwWFma7qK3v7QtxRqp=GHnON8DF0kO84yDvsxu3nkb-xA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29 2013, Linus Torvalds wrote:
> On Fri, Mar 29, 2013 at 11:24 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> >> Don't do this kind of thing. That branch is pointless, and just
> >> confused you.
> >
> > Tag, you mean?
> 
> No. Branch. Why would you have a public branch called "for-linus",
> when you intend to tag the end result before sending it to me?

Outside of "that's what I have always done", the intent was for others
that send patches through me to know what to base it off, if not
previous release. All those folks know that for-3.x/drivers is for the
next x release, and that for-linus is for the existing tree.

> It would make much more sense if you just did your development in your
> "master" branch, perhaps with a separate branch for fixes during
> stabilization (so that you don't mix up fixes with your future
> development. Call it "fixes" or "stable" or whatever. No "for-linus"
> branches anywhere. After all, the branch isn't for me at all. It's for
> me only once you're ready. And at that point you tag it, so having a
> *tag* called for-linus makes sense and gives us the nice signing etc.

I see your point, it's not for you YET but it will be soon. I'd rather
just keep that naming to avoid confusion with others, but tag it
appropriately (for-linus-<date>?) when it's headed your way. Then use
that proper signed tag name as the reference to you.

I prefer keeping 'master' pristine.

-- 
Jens Axboe

