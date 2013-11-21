Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3KUMVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:21:25 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53549 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3KUMVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:21:24 -0500
Date: Thu, 21 Nov 2013 12:21:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] mfd: Immutable branch for ASoC
Message-ID: <20131121122116.GE23067@lee--X1>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131120091636.GA30012@lee--X1>
 <20131120102045.GW2674@sirena.org.uk>
 <20131120104526.GA30524@lee--X1>
 <20131120113400.GY2674@sirena.org.uk>
 <20131121090724.GB19368@lee--X1>
 <20131121114105.GO2674@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131121114105.GO2674@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Mark Brown wrote:

> On Thu, Nov 21, 2013 at 09:07:24AM +0000, Lee Jones wrote:
> 
> > ----------------------------------------------------------------
> > ASoC immutable branch, as requested by Mark Brown.
> > ----------------------------------------------------------------
> > Charles Keepax (1):
> >       ASoC: wm5110: Expose input high pass filter controls
> 
> I was expecting patch 1 in the series as well (the DSP stuff won't work
> properly without the register map updates to go with it).

Yes, makes sense. Bear with me.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
