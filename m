Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417Ab3GLUdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:33:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965377Ab3GLUdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:33:36 -0400
Date: Fri, 12 Jul 2013 13:33:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130712203334.GA24331@kroah.com>
References: <20130712005023.GB31005@thunk.org>
 <20130712025745.GA24086@tuxdriver.com>
 <20130712033430.GA3798@kroah.com>
 <51E03AEE.5010403@zytor.com>
 <20130712172836.GA7627@kroah.com>
 <20130712175718.GA342@thunk.org>
 <51E0480A.2040905@zytor.com>
 <51E04AB9.1000003@zytor.com>
 <CA+55aFw0PvYBguFmacL0FC6V_hjGVcUWsrZ6HO9tuQof=yw5PA@mail.gmail.com>
 <1373658797.17876.119.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373658797.17876.119.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 03:53:17PM -0400, Steven Rostedt wrote:
> On Fri, 2013-07-12 at 12:44 -0700, Linus Torvalds wrote:
> 
> > They can be useful for "local" notes (they can be very powerful for
> > certain workflows), but they won't be pulled and pushed by me.
> 
> Perhaps notes can be used as that reminder to send to stable. Tag a
> commit with a note, and have some automated process that monitors
> Linus's tree and when a commit makes it in, automate an email to stable
> with said commit.

Ick, no, I'm not going to be using git notes for anything, sorry.

Is it _really_ all that hard to remember what to mark for stable
inclusion?  If you figure it out after you have committed the patch,
then just put a copy of it somewhere to remind yourself.  That seems to
be what both David and I do with no problems, and I think we both deal
with more individual patches and developers than probably most everyone
else combined.

That's what mailboxes are for, use a script of 'git send-email' to send
it to yourself and save it somewhere.  Use patchwork.  Use a text file
to remind yourself.  Use quilt, like Andrew does, he has a great track
record of marking patches for the stable trees properly.  Use something,
it really isn't that hard, or at least, it sure shouldn't be, if you
really care about it.

greg k-h
