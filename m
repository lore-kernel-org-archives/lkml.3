Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3IVWGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:06:36 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:49892 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3IVWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130922215520.GE31014@kernel.dk>
References: <20130922215520.GE31014@kernel.dk>
Date: Sun, 22 Sep 2013 15:06:34 -0700
X-Google-Sender-Auth: L9Punbecz3CdNkni4jhsTBRBXlc
Message-ID: <CA+55aFygOYa1aCv02S04PvH+gfWi2GSKQ1PPcYTGVpz8UJs-eA@mail.gmail.com>
Subject: Re: [GIT PULL] Block IO fixes for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 2:55 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Mike Christie (1):
>       If the queue is dying then we only call the rq->end_io callout.     This leaves bios setup on the request, because the caller assumes when     the blk_execute_rq_nowait/blk_execute_rq call has completed that     the rq->bios have been cleaned up.

Christ people.

We have rules for commit messages. Those rules have things like
"one-line commit summary at the top", because without that things like
summary logs (ie "git shortlog") and "gitk" don't do a good job.

How long have we been doing this? I'm used to seeing some odd commit
messages outside the kernel repo, but am used to kernel people getting
the trivial details right.

That's not the only one. Look at commit 577cee1e8db6 for some other
cruddy commit messages. Just because somebody said "Hello" in email
doesn't mean that it should remain that way in a commit message.

So out of seven commit messages, two were badly formatted. That's not
a sign of good quality control.

               Linus
