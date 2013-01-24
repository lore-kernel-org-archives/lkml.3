Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab3AXWaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:30:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab3AXWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:30:09 -0500
Date: Thu, 24 Jan 2013 14:30:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bret Towe <magnade@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: crash in ocfs2_fast_symlink_readpage in kernel 3.5.0
Message-Id: <20130124143007.39c8545f.akpm@linux-foundation.org>
In-Reply-To: <CALjC5hbMq+bc-X8Ad+=gEZLuWy3ZXm4Z0Y2w44k5UZjL4g7vqg@mail.gmail.com>
References: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
	<CALjC5hZwVwRdY6muizzK-+jrq0RH43H6f2kgXstZuco7oM7FyQ@mail.gmail.com>
	<CALjC5hbMq+bc-X8Ad+=gEZLuWy3ZXm4Z0Y2w44k5UZjL4g7vqg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jan 2013 20:15:33 -0800
Bret Towe <magnade@gmail.com> wrote:

> >
> > it looks like you have a patch for this problem in a queue somewhere
> > (email found on ocfs2-dev:
> > https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008677.html )
> > but its not in 3.6, any reason for the delay?
> > I've been running that patch on 3.5 for a while now likely since
> > around the time i found that email
> > and its been working well
> 
> doesn't look to be in 3.7 or 3.8-git
> and from what i see on ocfs2-dev there are at least 16 other patches
> that are also being ignored?
> I'm sure if I'm bothering at this point to maintain my own patchset to
> keep ocfs2 from crashing
> that there is other folks doing the same

Please resend all OCFS2 patches, cc'ing myself, Mark, Joel and
ocfs2-devel@oss.oracle.com.

I shall then review them, merge them into -mm (and hence linux-next) so
they can get a bit of visibility and testing while the maintainers are
checking them over.

Thanks.
