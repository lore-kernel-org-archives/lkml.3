Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3KTKpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:45:34 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45277 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3KTKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:45:31 -0500
Date: Wed, 20 Nov 2013 10:45:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ASoC: wm5110: Expose input high pass filter controls
Message-ID: <20131120104526.GA30524@lee--X1>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131120091636.GA30012@lee--X1>
 <20131120102045.GW2674@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131120102045.GW2674@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Mark Brown wrote:

> On Wed, Nov 20, 2013 at 09:16:36AM +0000, Lee Jones wrote:
> 
> > For the MFD parts: Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> > How do you want to play this ASoC?
> 
> I expect this to collide with future changes from Wolfson so it'll need
> to go via ASoC.

Okay, what if I make you a branch to pull from? Or visa-versa?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
