Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaAHLSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:18:23 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:52529 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaAHLSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:18:21 -0500
Date: Wed, 8 Jan 2014 11:18:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] ASoC: twl4030: Remove local reg cache
Message-ID: <20140108111816.GH19974@lee--X1>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
 <1388755676-16036-9-git-send-email-peter.ujfalusi@ti.com>
 <20140108080535.GA19974@lee--X1>
 <52CD318E.3090706@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52CD318E.3090706@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Depend on the regmap reg cache implementation for register caching done in
> >> the twl-core driver.
> >> The local register cache can be removed and we can keep only shadow copies
> >> of certain ctl registers for pop noise reduction.
> >>
> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >> ---
> >>  sound/soc/codecs/twl4030.c | 207 ++++++++++++++-------------------------------
> >>  1 file changed, 63 insertions(+), 144 deletions(-)
> > 
> > Which commit is the patch-set based on? This patch doesn't apply.
> 
> When I have sent it it was mainline 3.13-rc6, Now I rebased my series on
> 3.13-rc7 locally.
> 
> > At a guess I'd say it's becuase this commit is applied on my tree:
> > 
> >   mfd: twl6040: reg_defaults support for regmap
> 
> I also have the twl6040 series underneath the twl4030 patches in my working
> branch and the two series does not touch the same files.
> 
> > Would you mind rebasing on my ASoC branch please?
> > 
> >   git://git.linaro.org/people/lee.jones/mfd.git  ib-asoc
> 
> I have applied this twl4030 series on this branch and all patches (from 01 to
> 11) applied w/o issue, not even offset difference.
> 
> Not sure what is going on since the sound/soc/codecs/twl4030.c file is
> identical in 3.13-rc7 and in your ib-asoc branch so the series should apply
> cleanly for you.

Now that is strange. I just attempted to apply them again and they did
so cleanly. I'm not sure what happened, but they're find now.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
