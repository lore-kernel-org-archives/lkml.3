Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaFXLwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:52:19 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39717 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbaFXLwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:52:18 -0400
Message-ID: <1403610735.3140.32.camel@dabdike>
Subject: Re: [RFC] Tux3 for review
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Date: Tue, 24 Jun 2014 07:52:15 -0400
In-Reply-To: <3dd5be85-278b-4e20-a6c2-1e042dab2bef@phunq.net>
References: <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
	 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
	 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
	 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
	 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
	 <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
	 <1403448187.1949.9.camel@jarvis.lan>
	 <522aee97-34e7-4adc-adf2-c9b73aa0ef36@phunq.net>
	 <1403584890.3140.18.camel@dabdike>
	 <79582b70-6111-49f5-a1a9-f5701854e199@phunq.net>
	 <20140624105940.GH14887@thunk.org>
	 <3dd5be85-278b-4e20-a6c2-1e042dab2bef@phunq.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 04:27 -0700, Daniel Phillips wrote:
> On Tuesday, June 24, 2014 3:59:40 AM PDT, Theodore Ts'o wrote:
> > On Tue, Jun 24, 2014 at 02:10:52AM -0700, Daniel Phillips wrote:
> >> 
> >> That makes sense, because the patches to transform our workarounds
> >> into shiny new kernel hooks are still in progress, as I said. I would
> >> appreciate the courtesy of being permitted to take the time to do the
> >> work to the necessary quality without being subjected to endless
> >> carping about when the patches will be posted.
> >
> > The feedback which you have been getting, fairly consistently I
> > believe, is that it is the shiny new kernel hooks that need to be
> > reviewed, not the workarounds.  I don't think it's a matter of people
> > not being willing to give you the time to do this work (take all the
> > time you need!); but rather that it's premature for you to be asking
> > for tux3 to be merged before those patches have been posted and
> > reviewed and found to be shiny.
> 
> That is not quite right. Before posted the filesystem for review,
> we did not know whether core changes or workarounds would be the
> better route. Now we do know, and have duly turned our coding
> energy to producing a set of decent core hooks. That does not mean
> that we are taking Tux3 "out of play". That would just be stupid.

OK, but now we've explained the reason several times: The original set
of hacks is fragile against changes to writeback, which is the
maintenance problem.

> I emphatically disagree that it is premature for asking Tux3 to be
> merged. You might think so, but I do not. While I do not begrudge
> you your opinion, Linux did not get to the dominant position it has
> today by being shy about merging new functionality early. Did we
> suddenly lose our mojo just at Tux3 merge time?

But you've agreed to go the core hooks route, the patches for which
aren't yet ready, so what is there actually to review and merge until
the patches appear?

James

> If you really think that Tux3 has been offered for merge too early,
> then clone our tree, build it, break it and heap abuse on us. That
> should take you about one hour if you are right.
> 
> Regards,
> 
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



