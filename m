Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaKMCV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:21:56 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:32870 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752969AbaKMCVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:21:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3350:3622:3867:3868:3871:3872:3873:4321:5007:6119:6261:6742:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pear44_2d3789d279702
X-Filterd-Recvd-Size: 2366
Message-ID: <1415845309.4269.6.camel@perches.com>
Subject: Re: [PATCH][resend] of: Add vendor 2nd prefix for Asahi Kasei Corp
From: Joe Perches <joe@perches.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>, Simon <horms@verge.net.au>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Wed, 12 Nov 2014 18:21:49 -0800
In-Reply-To: <87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>
References: <20140611165410.GK5099@sirena.org.uk>
	 <CAMuHMdUT0hEBGbN+W-Oz5zJ0N8S2VDMndqtDO=EtWF3jG2MEew@mail.gmail.com>
	 <20140611170233.GL5099@sirena.org.uk> <5398A53D.3020706@wwwdotorg.org>
	 <20140611190444.GN5099@sirena.org.uk> <5398AB07.4040304@wwwdotorg.org>
	 <87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
	 <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>
	 <20140922130026.GK3290@leverpostej>
	 <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
	 <20140922132743.GM3290@leverpostej>
	 <87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 02:18 +0000, Kuninori Morimoto wrote:
> > > Still missing is an update for checkpatch to warn when a deprecated
> > > vendor prefix is used.
> > 
> > Marking it deprecated and warning with checkpatch is certainly
> > preferable.
> 
> I guess removing "ak" line from vendor-prefixes.txt is very enough
> for warn for a deprecated vendor prefix on checkpatch ?

Huh?  No idea what you mean.
What are you suggesting about checkpatch?


