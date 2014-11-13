Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaKMCvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:51:15 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:34561 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaKMCvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:51:13 -0500
Date: Thu, 13 Nov 2014 11:51:09 +0900
From: Simon Horman <horms@verge.net.au>
To: Joe Perches <joe@perches.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH][resend] of: Add vendor 2nd prefix for Asahi Kasei Corp
Message-ID: <20141113025105.GA16652@verge.net.au>
References: <5398A53D.3020706@wwwdotorg.org>
 <20140611190444.GN5099@sirena.org.uk>
 <5398AB07.4040304@wwwdotorg.org>
 <87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
 <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>
 <20140922130026.GK3290@leverpostej>
 <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
 <20140922132743.GM3290@leverpostej>
 <87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>
 <1415845309.4269.6.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415845309.4269.6.camel@perches.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 06:21:49PM -0800, Joe Perches wrote:
> On Thu, 2014-11-13 at 02:18 +0000, Kuninori Morimoto wrote:
> > > > Still missing is an update for checkpatch to warn when a deprecated
> > > > vendor prefix is used.
> > > 
> > > Marking it deprecated and warning with checkpatch is certainly
> > > preferable.
> > 
> > I guess removing "ak" line from vendor-prefixes.txt is very enough
> > for warn for a deprecated vendor prefix on checkpatch ?
> 
> Huh?  No idea what you mean.
> What are you suggesting about checkpatch?

Hi Joe,

I think that what Morimoto-san wanted to say was something like this:

  I guess that removing the "ak" line from vendor-prefixes.txt would
  be sufficient to cause checkpatch to generate a warning about
  using the deprecated "ak" vendor prefix. Is that a good approach?
