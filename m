Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3EHMDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:03:35 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43063 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3EHMDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:03:34 -0400
Date: Wed, 8 May 2013 13:03:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
Message-ID: <20130508120326.GF3459@gmail.com>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
 <20130508103401.GX7478@sirena.org.uk>
 <20130508110451.GC3459@gmail.com>
 <20130508113124.GH7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508113124.GH7478@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Mark Brown wrote:

> On Wed, May 08, 2013 at 12:04:51PM +0100, Lee Jones wrote:
> > On Wed, 08 May 2013, Mark Brown wrote:
> 
> > > Ugh, please don't do stuff like this - you're posting an individual
> > > revision of a patch buried in the middle of a thread.  This just makes
> > > things hard to follow and error prone.  Repost the patch series
> 
> > It's so much more convenient to do it this way. Re-sending entire
> > patch-sets for small fixups is clumsy and annoying at best. Creating
> > even more prone to error.
> 
> Then consider what happens as soon as you get more than one update to
> the patch, or there's any meaningful discussion on the patches - picking
> out which of many versions in bifurcating threads.  You shouldn't even
> assume that followups to the patches are being read, for example if it's
> clear that there's revision required and it's all device specific
> discussion rather than framework stuff I'll often just stop reading the
> thread and wait for the respost.

<snip>

> > Surely most people have their mail setup as threaded? Then the
> > time-line and subsequent patch versions are very easy to follow aren't
> > they? I get a nice trace like this:

<snip>

> This doesn't work nearly so well once you start getting meaningful
> discussion, multiple branches on the thread and indentation can make it
> hard to spot where the latest patch is and it's still more effort to
> find the latest version.

Yes, of course one still has to use common sense. If this happens then
I'd say a re-post would be the obvious thing to do. I'm speaking more
about situations such as this, where the discussion is trivial and the
fixup, less so.

> > > or wait until what can be applied is applied then repost.
> 
> > Taking patches out-of-order, or 'willy-nilly', is asking for trouble.
> 
> We've been through this repeatedly.  If your early patches won't work
> without the later patches then you need to improve your early patches so
> they stand alone.

It's never okay for early patches to rely on later ones and yes, all
patches should be as orthogonal as possible. But it is okay for later
patches to rely on earlier ones.

Besides, I was more referencing the massively increased effort
imparted to the developer by applying patches in an arbitrary order.
Forcing the developer to rearranging and rebase the patch-set causing
unnecessary merge conflicts. It's better if the maintainer takes the
patch-set in the order it was written to prevent unnecessary (which is
the key word here) such things.

> Asking people to re-review an enormous patch series
> because of a change at the end isn't helpful

I completely agree. Hence why I reap Acks and apply them on next
submission to show the maintainer what they have reviewed and accepted
already. 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
