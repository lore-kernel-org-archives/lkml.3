Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab3GPGYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:24:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33820 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab3GPGYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:24:14 -0400
X-Sasl-enc: Fnjd3TKKxEfcSSan7iiHa8bo+wUDz3sEDC2Rl8Hk6ucG 1373955852
Date: Mon, 15 Jul 2013 23:20:58 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: KS Topic request: Handling the Stable kernel, let's dump the cc:
 stable tag
Message-ID: <20130716062058.GB19052@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
 <1373951852.2148.9.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373951852.2148.9.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:17:32AM +0400, James Bottomley wrote:
> On Mon, 2013-07-15 at 14:44 -0700, Greg KH wrote:
> > On Mon, Jul 15, 2013 at 11:27:56PM +0400, James Bottomley wrote:
> > > Before the "3.10.1-stable review" thread degenerated into a disagreement
> > > about habits of politeness, there were some solid points being made
> > > which, I think, bear consideration and which may now be lost.
> > > 
> > > The problem, as Ji???? Kosina put is succinctly is that the distributions
> > > are finding stable less useful because it contains to much stuff they'd
> > > classify as not stable material.

And I'm going to be working on that.

But I need, from the distros, specific examples of what they object to.
So far all I've gotten is one security patch (that was needed), and one
patch for sysfs that I backported too far in the version numbers (my
fault.)

Given the huge number of stable patches over the past few years, only
having 2 patches be an issue sounds like things are working well for
people here.

If I don't get pushback, with specifics, from the distros, I will not
know what to change, so if people can provide me that, it will help out
a lot.

> > I don't like this at all, just for the simple reason that it will push
> > the majority of the work of stable kernel development on to the
> > subsystem maintainers, who have enough work to do as it is.
> 
> Well, I think of this as a feature not a bug because it enables scaling,
> but we can certainly debate the topic; it's probably one of the more
> important things that should be discussed.

How does this scale?  It makes the maintainers do more work, which does
not scale at all.

> > Stable tree stuff should cause almost _no_ extra burden on the kernel
> > developers, because it is something that I, and a few other people, have
> > agreed to do with our time.  It has taken me 8 _years_ to finally get
> > maintainers to agree to mark stuff for the stable tree, and fine-tune a
> > development process that makes it easy for us to do this backport work.
> > 
> > I _want_ the exact same commit that is in Linus's tree for the backport
> > because if I have to rely on a maintainer to do the backport and resend
> > it, I _know_ it will usually be a changed patch, and the git commit id
> > will be lost.
> 
> This is fixable with process and tools, surely.

That's crazy, and it implies that there is a problem today with the Cc:
tag.

Is there?  What is the problem that you are seeing that you wish to help
resolve?

I don't think it's the same problem that I am seeing, as adding more
tools and processes sure isn't going to fix that.

> > Have I missed anything else that the distros are objecting to?  The
> > "smaller" distros (i.e. ones without lots of kernel developers) have
> > been giving me nothing but _thanks_ and appreciation with the way that
> > I've been sucking in all of the different fixes.  Do we want to mess
> > with a process that is really working out well for them, and only causes
> > annoyance at times by the larger ones?
> 
> I still think the scaling problem remains plus, if you push back more,
> it's going to increase friction: you aren't necessarily in the best
> position to know what should be a stable fix for a given subsystem, and
> if you push back incorrectly it's going to annoy the maintainer.

Making a subsystem maintainer answer "why is this needed" is really
going to annoy people?  Seriously?

Let's try it out, and see what happens.

I think the real stable issue that _everyone_ keeps ignoring, is my
original complaint, in that people are using the -rc1 merge window to
get fixes in they should have sent to Linus for .0.

I don't see anything you have written so far that will help resolve that
issue, which is not good, as that needs to be taken care of.

greg k-h
