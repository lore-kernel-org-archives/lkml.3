Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3GPAIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:08:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38214 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758342Ab3GPAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:08:07 -0400
X-Sasl-enc: cdUgTXiT3ktFWCj2fz+o8V25h1kGp920aySARrFjEHZl 1373933286
Date: Mon, 15 Jul 2013 17:06:23 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130716000623.GB26261@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
 <1373925699.17876.218.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373925699.17876.218.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 06:01:39PM -0400, Steven Rostedt wrote:
> On Mon, 2013-07-15 at 14:44 -0700, Greg KH wrote:
> 
> > I don't like this at all, just for the simple reason that it will push
> > the majority of the work of stable kernel development on to the
> > subsystem maintainers, who have enough work to do as it is.
> > 
> > Stable tree stuff should cause almost _no_ extra burden on the kernel
> > developers, because it is something that I, and a few other people, have
> > agreed to do with our time.  It has taken me 8 _years_ to finally get
> > maintainers to agree to mark stuff for the stable tree, and fine-tune a
> > development process that makes it easy for us to do this backport work.
> 
> Although, since those 8 years, the stable tree has proven its
> importance.
> 
> Is a extra "ack" also too much to ask?

Maintainers are our most limited resource, I'm getting their "ack" when
they themselves tag the patch to be backported with the Cc: line.

I then cc: them when the patch goes into the patch queue.

I then cc: them again when the patch is in the -rc1 phase.

How many times do I need to do this to give people a chance to say
"nak"?

> The big problem with the above is that the process depends highly on
> this guy named "Greg".
> 
> If "Greg" gets tired of doing this, or gets sick, or "see other KS topic
> about mortality of maintainers", then the entire process fails.

"Greg" has documented how he does all of this work, and the scripts I
use are all published as well.

"Greg" has also asked for help with all of this, a number of times, with
a specific list of things that he needs help with.  And almost no one
has ever offered to help.  That's fine, I can live with that, we all
have jobs to do in other areas, and the LF now lets me do this as part
of my job, so I can focus on it.

> OK, you are not the only one that does the stable release. There's Ben
> and Luis doing it as well, and various others. But there seems to be a
> bit of an issue here. How much should go into stable? Who really
> decides?

The subsystem maintainers do by tagging the patches.  Every once in a
while I dig stuff up on my own, but again, I give the subsystem
maintainer at least two separate chances to NAK the patch, so it's not
like I'm doing anything in private here.

> How important is the stable releases? Are maintainers willing to do a
> little more work now to make sure their subsystems work fine in older
> kernels? This isn't the same stable as it was 8 years ago.

And that annoys the hell out of some Linux companies who feel that the
stable kernels compete with them.  So people working for those companies
might not get as much help with doing any additional work for stable
kernel releases (this is not just idle gossip, I've heard it directly
from management's mouths.)

So I need to, for both a resource management issue, and a business
issue, make this as painless for maintainers as possible, which I have
tried to do.

And given the uptick in the past few years of maintainers tagging
patches, I think it's worked out so well that people are now doing it
too much, which gets back to my original complaints last week that I am
now working to address in a different manner.

thanks,

greg k-h
