Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3A2Aqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:46:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3A2Aql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:46:41 -0500
Date: Mon, 28 Jan 2013 16:46:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bret Towe <magnade@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: crash in ocfs2_fast_symlink_readpage in kernel 3.5.0
Message-Id: <20130128164640.5a468999.akpm@linux-foundation.org>
In-Reply-To: <CALjC5hZaVwJBuR17dcM7hG1EMEoAYoUt0S-x6avCxRBuF54RGg@mail.gmail.com>
References: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
	<CALjC5hZwVwRdY6muizzK-+jrq0RH43H6f2kgXstZuco7oM7FyQ@mail.gmail.com>
	<CALjC5hbMq+bc-X8Ad+=gEZLuWy3ZXm4Z0Y2w44k5UZjL4g7vqg@mail.gmail.com>
	<20130124143007.39c8545f.akpm@linux-foundation.org>
	<CALjC5hZaVwJBuR17dcM7hG1EMEoAYoUt0S-x6avCxRBuF54RGg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013 19:40:34 -0800
Bret Towe <magnade@gmail.com> wrote:

> On Thu, Jan 24, 2013 at 2:30 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Sat, 19 Jan 2013 20:15:33 -0800
> > Bret Towe <magnade@gmail.com> wrote:
> >
> >> >
> >> > it looks like you have a patch for this problem in a queue somewhere
> >> > (email found on ocfs2-dev:
> >> > https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008677.html )
> >> > but its not in 3.6, any reason for the delay?
> >> > I've been running that patch on 3.5 for a while now likely since
> >> > around the time i found that email
> >> > and its been working well
> >>
> >> doesn't look to be in 3.7 or 3.8-git
> >> and from what i see on ocfs2-dev there are at least 16 other patches
> >> that are also being ignored?
> >> I'm sure if I'm bothering at this point to maintain my own patchset to
> >> keep ocfs2 from crashing
> >> that there is other folks doing the same
> >
> > Please resend all OCFS2 patches, cc'ing myself, Mark, Joel and
> > ocfs2-devel@oss.oracle.com.
> >
> > I shall then review them, merge them into -mm (and hence linux-next) so
> > they can get a bit of visibility and testing while the maintainers are
> > checking them over.
> >
> > Thanks.
> 
> I've just been browsing the ocfs2-dev archives do you want me to pull them
> and resend or should i just link to the archive?
> keep in mind I'm just a end user not really a dev persay

Well, someone needs to resend them.  If you're prepared to do that then
thanks, and please remember to add your Tested-by where you feel that's
appropriate.

> if you do want me to send the patches however I assume there is a document
> i should read first?

Documentation/SubmittingPatches is good.

These patches should have a From: line at the start of the changelog
indicating the original author.  They should have the original author's
Signed-off-by: (if that was in the original patch) and also your
Signed-off-by: as you were on the delivery path.  And optionally your
Tested-by, as above.

Be sure to cc everyone (ocfs2-devel, linux-kernel, Mark, Joel, myself
and the original author(s).

Lots of email clients like to mangle patches, including gmail :( Email
the patchset to yourself first and check that what you received still
applies.  Try using text/plain attachments if they are being mangled.

