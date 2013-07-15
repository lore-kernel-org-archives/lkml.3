Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3GOWBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:01:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18612 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3GOWBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:01:44 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=BBtWuzEN6uUUJ7lm7j8A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373925699.17876.218.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 18:01:39 -0400
In-Reply-To: <20130715214422.GA2478@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 14:44 -0700, Greg KH wrote:

> I don't like this at all, just for the simple reason that it will push
> the majority of the work of stable kernel development on to the
> subsystem maintainers, who have enough work to do as it is.
> 
> Stable tree stuff should cause almost _no_ extra burden on the kernel
> developers, because it is something that I, and a few other people, have
> agreed to do with our time.  It has taken me 8 _years_ to finally get
> maintainers to agree to mark stuff for the stable tree, and fine-tune a
> development process that makes it easy for us to do this backport work.

Although, since those 8 years, the stable tree has proven its
importance.

Is a extra "ack" also too much to ask?

> 
> I _want_ the exact same commit that is in Linus's tree for the backport
> because if I have to rely on a maintainer to do the backport and resend
> it, I _know_ it will usually be a changed patch, and the git commit id
> will be lost.

This is a good point and a valid concern.


> 
> I know this because it happens today.  I get patches from maintainers
> that are radically changed from what is in Linus's tree without any
> justification for why that is.  That's not ok.
> 
> Let me work with the distros on the issues they have raised.  So far I
> have the following issues they have complained about:
>   - patches that shouldn't be there because they don't really do
>     anything.
>   - patches that aren't obvious why they are there.
> 
> The first one I am going to be pushing back on, and have already, much
> to the dismay of some subsystem maintainers.
> 
> The second one is almost always due to security issues that were unknown
> to the distro.  The announcement of security problems to the distros has
> now been addressed, and since that has changed, I haven't heard any
> problems about this.
> 
> Have I missed anything else that the distros are objecting to?  The
> "smaller" distros (i.e. ones without lots of kernel developers) have
> been giving me nothing but _thanks_ and appreciation with the way that
> I've been sucking in all of the different fixes.  Do we want to mess

This is proof of how important stable has been.

> with a process that is really working out well for them, and only causes
> annoyance at times by the larger ones?


The big problem with the above is that the process depends highly on
this guy named "Greg".

If "Greg" gets tired of doing this, or gets sick, or "see other KS topic
about mortality of maintainers", then the entire process fails.

OK, you are not the only one that does the stable release. There's Ben
and Luis doing it as well, and various others. But there seems to be a
bit of an issue here. How much should go into stable? Who really
decides?

How important is the stable releases? Are maintainers willing to do a
little more work now to make sure their subsystems work fine in older
kernels? This isn't the same stable as it was 8 years ago.

I guess this is a great topic for KS, as it seems to be going all over
the place via email, and would probably be much better sorted out face
to face.

-- Steve



