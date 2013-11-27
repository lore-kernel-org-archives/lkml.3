Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3K0QmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:42:10 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:40645 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab3K0QmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:42:08 -0500
Date: Wed, 27 Nov 2013 16:42:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
 as readable
Message-ID: <20131127164202.GX3296@lee--X1>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131127132442.GJ3296@lee--X1>
 <20131127151639.GX14725@sirena.org.uk>
 <20131127152701.GQ3296@lee--X1>
 <20131127160707.GC14725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127160707.GC14725@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Mark Brown wrote:

> On Wed, Nov 27, 2013 at 03:27:01PM +0000, Lee Jones wrote:
> > On Wed, 27 Nov 2013, Mark Brown wrote:
> 
> > > That seems excessive and it probably ought to go in as a bug fix
> > > afterwards.  Given that it's just an addition of data to the table I'd
> > > expect we could cope, we've routinely done that with similar updates in
> > > the past without incident.
> 
> > Ah, is the depends patch in Mainline already? I assumed it was due to
> > go in during the v3.14 merge window? If it's already in Mainline, then
> > sure I don't mind if it goes in -fixes via ASoC, no problem.
> 
> No, it's for v3.14 - it just seemed like for the size/impact of the
> change we should be able to handle the situation more smoothly.

I see. Well I'm not sure how. If we apply it to either ASoC or MFD and
other patches pertaining to that file subsequently appear, then
conflict is likely. As you know, the commonly used mitigation
technique we usually employ is immutable branches, but this was not
employed in this case for one reason or another. So if we apply it now
to either one of the trees we will be hedging our bets.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
