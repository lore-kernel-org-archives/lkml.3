Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3KDXAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 18:00:07 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44620 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3KDXAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 18:00:05 -0500
X-Greylist: delayed 3760 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2013 18:00:05 EST
Date: Mon, 4 Nov 2013 21:57:16 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0
 plans?
Message-ID: <20131104215716.0a575db2@alan.etchedpixels.co.uk>
In-Reply-To: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason I mention it is because I've been mulling over something
> Dirk Hohndel said during LinuxCon EU and the kernel summit. He asked
> at the Q&A session whether we could do a release with just stability
> and bug-fixes, and I pooh-poohed it because I didn't see most of us
> having the attention span required for that
> (cough*cough*moronic*woodland creature*cough*cough).

I'm slightly back, so it's time to get the oar out ;)

I think there are two problems

1. It takes a lot of time to identify the stability fixes you need so
simply doesn't fit the release cycle.

2. You often need them in the unstable release to work out if they are
the right solution.

We have several "stable-ish" trees of 3.x.y format.

> So I may be pessimistic, but I'd expect many developers would go
> "Let's hunt bugs.. Wait. Oooh, shiny" and go off doing some new
> feature after all instead. Or just take that release off.

A look at some of the bug data shows that is all too true, and also that
despite the NSA fiasco and the like we have an awful lot of open,
probably real hits in coverity and the like which are effectively widely
available to the bad guys to analyse too.

> But I do wonder.. Maybe it would be possible, and I'm just unfairly
> projecting my own inner squirrel onto other kernel developers. If we
> have enough heads-up that people *know* that for one release (and
> companies/managers know that too) the only patches that get accepted
> are the kind that fix bugs, maybe people really would have sufficient
> attention span that it could work.

That ought to be happening every release. Every maintainer should be
asking "is my tree full of shit that needs cleaning up" and prioritising
it, including pushing back on developers to find a good balance between
fixing and new stuff.

> And the reason I mention "4.0" is that it would be a lovely time to do
> that. Roughly a years heads-up that "ok, after 3.19 (or whatever),
> we're doing a release with *just* fixes, and then that becomes 4.0".

It would be a good time as you went towards it to ask "what code is
buggy, problematic and simply not being maintained", and chuck it. It's
in the git history so if someone cares in the future they can ressurect
it but the tree has a lot of crap in it that slows down other work and
simply doesn't matter to anyone. (and if it does them rm -rf is a great
way to create new maintainers)

It might be very instructive to find the set of devices and archs that are

- not looking maintained
- not shipped by any vendor anyone has ever heard of
- or shipped by every vendor but no users show up in their collected data


Alan
