Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3IVX1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 19:27:54 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:62328 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3IVX1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 19:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130922231214.GF31014@kernel.dk>
References: <20130922215520.GE31014@kernel.dk>
	<CA+55aFygOYa1aCv02S04PvH+gfWi2GSKQ1PPcYTGVpz8UJs-eA@mail.gmail.com>
	<20130922231214.GF31014@kernel.dk>
Date: Sun, 22 Sep 2013 16:27:52 -0700
X-Google-Sender-Auth: fvnw8f39R5Dt3id0kx3PAtpVnUw
Message-ID: <CA+55aFxm5EvebWkHCJMrULSTHQskCFTswhNPPRf_jsc+KgSQTA@mail.gmail.com>
Subject: Re: [GIT PULL] Block IO fixes for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 4:12 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Not necessarily bad quality control, but yeah, the commit messages
> could've been prettier. Those two should have been git ammended, most of
> them are directly applied byt git am fwiw.

No, one of them was clearly *not* done with git am, because git am
uses the subject like to create that summary message.

And the other one you should have edited the mbox before feeding it to
git am - or pushed back on the submitter to write email in a format
where no such editing is necessary.

"I used git am" is not an excuse for bad formatting of commits. It's
just a tool, you need to make sure the tool is fed valid data.

            Linus
