Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3IVXMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 19:12:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38116 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3IVXMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 19:12:20 -0400
Date: Sun, 22 Sep 2013 17:12:14 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [GIT PULL] Block IO fixes for 3.12
Message-ID: <20130922231214.GF31014@kernel.dk>
References: <20130922215520.GE31014@kernel.dk>
 <CA+55aFygOYa1aCv02S04PvH+gfWi2GSKQ1PPcYTGVpz8UJs-eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFygOYa1aCv02S04PvH+gfWi2GSKQ1PPcYTGVpz8UJs-eA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22 2013, Linus Torvalds wrote:
> On Sun, Sep 22, 2013 at 2:55 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > Mike Christie (1):
> >       If the queue is dying then we only call the rq->end_io callout.     This leaves bios setup on the request, because the caller assumes when     the blk_execute_rq_nowait/blk_execute_rq call has completed that     the rq->bios have been cleaned up.
> 
> Christ people.
> 
> We have rules for commit messages. Those rules have things like
> "one-line commit summary at the top", because without that things like
> summary logs (ie "git shortlog") and "gitk" don't do a good job.
> 
> How long have we been doing this? I'm used to seeing some odd commit
> messages outside the kernel repo, but am used to kernel people getting
> the trivial details right.
> 
> That's not the only one. Look at commit 577cee1e8db6 for some other
> cruddy commit messages. Just because somebody said "Hello" in email
> doesn't mean that it should remain that way in a commit message.
> 
> So out of seven commit messages, two were badly formatted. That's not
> a sign of good quality control.

Not necessarily bad quality control, but yeah, the commit messages
could've been prettier. Those two should have been git ammended, most of
them are directly applied byt git am fwiw.

-- 
Jens Axboe

