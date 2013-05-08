Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3EHOG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:06:29 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34435 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3EHOG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:06:28 -0400
Date: Wed, 8 May 2013 15:06:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
Message-ID: <20130508140618.GI3459@gmail.com>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
 <20130508103401.GX7478@sirena.org.uk>
 <20130508110451.GC3459@gmail.com>
 <20130508113124.GH7478@sirena.org.uk>
 <20130508120326.GF3459@gmail.com>
 <20130508123902.GL7478@sirena.org.uk>
 <20130508130554.GG3459@gmail.com>
 <20130508134814.GQ7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508134814.GQ7478@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Mark Brown wrote:

> On Wed, May 08, 2013 at 02:05:54PM +0100, Lee Jones wrote:
> 
> > I'm saying, from experience, from the developer side, that if a
> > reviewer goes though a patch-set taking the ones s/he likes leaving
> > the rest behind, there are bound to be merge conflicts and semantic
> > issues which the developer will then have to resolve. Stuff that I
> > believe is added, unnecessary burden which would be easily avoided if
> > the set is firstly reviewed and _then_ applied after the Acks have
> > been awarded.
> 
> So, you have to assume a bit of taste on the part of the people applying
> the patches here.  If you're seeing merge conflicts that's probably an
> issue, but then it's very surprising that the patches would apply
> successfully in the first place since the conflicts generally come up
> when the patches are applied too.
> 
> The other thing to bear in mind here is that a patch series which is
> "here's a bunch of random changes to this driver" isn't the same as a
> patch series which builds something up through a series of changes.
> This series is a good example of the former - there's a few related
> things but really there's no visible relationship between most of the
> changes except that they happen to be for the same driver and sent at
> the same time.
> 
> The big downsides of not applying patches are that it takes longer to
> get the benefit of the bits that are good out to people and the big
> increase in reviewer fatigue from having to re-read the same patches
> over and over again.  This is one of the major ways problematic code
> gets in, reviewers eyes glaze over and they just start missing things.
> There's also the fact that serieses often end up having separate bugfix
> and development components which need to be routed differently anyway.

I understand your points and certainly sympathise with a great many of
them. I also understand the difference between random changes, which
aren't related in any systematic way and changes which are build upon
each other. It was the latter type to which I was referring to having
issues with.

Bringing this back on subject, whilst trying not to drag this out for
longer than we have to. I think replying to one's first patch with a
subsequent version has its merits. And as long as the thread hasn't
become too overgrown I see it as a useful tool to obtain an Ack or
further comment easily and without churn overhead. This also aids in
your quest to save maintainers from reviewing the same code
repeatedly, as once the Ack is in place it's easy to see which patches
are in need of further review and which ones can be skipped.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
