Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3IVX5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 19:57:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38448 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3IVX47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 19:56:59 -0400
Date: Sun, 22 Sep 2013 17:56:53 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [GIT PULL] Block IO fixes for 3.12
Message-ID: <20130922235653.GH31014@kernel.dk>
References: <20130922215520.GE31014@kernel.dk>
 <CA+55aFygOYa1aCv02S04PvH+gfWi2GSKQ1PPcYTGVpz8UJs-eA@mail.gmail.com>
 <20130922231214.GF31014@kernel.dk>
 <CA+55aFxm5EvebWkHCJMrULSTHQskCFTswhNPPRf_jsc+KgSQTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxm5EvebWkHCJMrULSTHQskCFTswhNPPRf_jsc+KgSQTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22 2013, Linus Torvalds wrote:
> On Sun, Sep 22, 2013 at 4:12 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > Not necessarily bad quality control, but yeah, the commit messages
> > could've been prettier. Those two should have been git ammended, most of
> > them are directly applied byt git am fwiw.
> 
> No, one of them was clearly *not* done with git am, because git am
> uses the subject like to create that summary message.

So make that a combo of git am and shitty mailer. I forget why it
happens, but it does happen often for me and I (usually remember) to fix
it up.

> And the other one you should have edited the mbox before feeding it to
> git am - or pushed back on the submitter to write email in a format
> where no such editing is necessary.
> 
> "I used git am" is not an excuse for bad formatting of commits. It's
> just a tool, you need to make sure the tool is fed valid data.

Sure, not disagreeing. It is my fault :-)

-- 
Jens Axboe

