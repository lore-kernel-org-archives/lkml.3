Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3GPG2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:28:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45111 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab3GPG2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:28:30 -0400
X-Sasl-enc: P+GXyIBA3k05IOPgig4waoJVZUyzESs6610Y6nU76bKW 1373956108
Date: Mon, 15 Jul 2013 23:28:23 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130716062823.GA26957@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
 <1373925699.17876.218.camel@gandalf.local.home>
 <20130716000623.GB26261@kroah.com>
 <1373955031.2148.18.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373955031.2148.18.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:10:31AM +0400, James Bottomley wrote:
> On Mon, 2013-07-15 at 17:06 -0700, Greg KH wrote:
> > On Mon, Jul 15, 2013 at 06:01:39PM -0400, Steven Rostedt wrote:
> > > On Mon, 2013-07-15 at 14:44 -0700, Greg KH wrote:
> > > 
> > > > I don't like this at all, just for the simple reason that it will push
> > > > the majority of the work of stable kernel development on to the
> > > > subsystem maintainers, who have enough work to do as it is.
> > > > 
> > > > Stable tree stuff should cause almost _no_ extra burden on the kernel
> > > > developers, because it is something that I, and a few other people, have
> > > > agreed to do with our time.  It has taken me 8 _years_ to finally get
> > > > maintainers to agree to mark stuff for the stable tree, and fine-tune a
> > > > development process that makes it easy for us to do this backport work.
> > > 
> > > Although, since those 8 years, the stable tree has proven its
> > > importance.
> > > 
> > > Is a extra "ack" also too much to ask?
> > 
> > Maintainers are our most limited resource, I'm getting their "ack" when
> > they themselves tag the patch to be backported with the Cc: line.
> > 
> > I then cc: them when the patch goes into the patch queue.
> > 
> > I then cc: them again when the patch is in the -rc1 phase.
> > 
> > How many times do I need to do this to give people a chance to say
> > "nak"?
> 
> Just to pick up on this, the problem from my perspective is that this
> cc: goes into my personal inbox.  From a list perspective this just
> doesn't work.  The entirety of my workflow is set up to operate from the
> mailing lists.  My inbox is for my day job.  It gets about 100 emails or
> more a day and anything that goes in there and doesn't get looked at for
> a day gets lost.  I sometimes feel guilty about seeing stable reviews
> whiz by, but not necessarily guilty enough to go back and try to find
> them.  I have thought of using filtering to manually place these into a
> deferred mailbox for later use.  However, the problem is that my work
> inbox is exchange, and the only tags I could filter on seem to be in the
> body (exchange does body filtering about as elegantly as a penguin
> flies).
> 
> That's where the suggestion to drop cc: stable@ came from.  I realise
> the workflow just isn't working for me.
> 
> I say we have the discussion at KS then I'll investigate a different
> workflow for SCSI.

KS is in November, feel free to not tag patches Cc: stable for scsi if
you don't want to use the existing workflow, and try something else now.

All I need, at the least, is a list of git ids to apply to the stable
tree(s), send them to stable@vger.kernel.org and I can take it from
there with my tools.

If you want to test things separately, send me a tree to pull, or a mbox
to apply, that works as well.  You can do all of these without having to
wait until November.

thanks,

greg k-h
