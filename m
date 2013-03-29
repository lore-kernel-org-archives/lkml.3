Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3C2SYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:24:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34950 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3C2SYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:24:13 -0400
Date: Fri, 29 Mar 2013 12:24:11 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 3.9-rc
Message-ID: <20130329182411.GD2567@kernel.dk>
References: <20130329153831.GQ19488@kernel.dk>
 <CA+55aFwoj=g0YrFOrpoKNY43o8qDAhDEHSP-zrtpWCXciwz_-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwoj=g0YrFOrpoKNY43o8qDAhDEHSP-zrtpWCXciwz_-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29 2013, Linus Torvalds wrote:
> On Fri, Mar 29, 2013 at 8:38 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > Please pull! As per usual, it's tagged and signed.
> 
> No it's not.
> 
> You have a *branch* called for-linus that contains the commits you mention.
> 
> And then you have a *tag* called for-linus, but that's just my old
> head that you've gone ahead and signed, which is entirely and utterly
> pointless.

Oops, that was a mistake. I must have been on the wrong branch at that
point. In past requests, I've signed the for-linus (or topic) branch
specifically.

> Christ, the amount of confusion in that tree.  Don't alias tags and
> branches. And if you do, make it clear which one you mean by *saying*
> so, ie "tags/for-linus", not just the ambiguous "for-linus". Now
> you've confused yourself, and because of the ambiguity you never even
> noticed, because the *branch* for-linus had the right commits.

Agree, the aliasing is nasty and git checkout usually doesn't like it a
whole lot either...

> Don't do this kind of thing. That branch is pointless, and just
> confused you.

Tag, you mean?

-- 
Jens Axboe

