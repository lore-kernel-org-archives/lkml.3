Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaAFQKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:10:09 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34561 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaAFQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:10:07 -0500
Date: Mon, 6 Jan 2014 16:10:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] ASoC/MFD: twl4030 codec local register cache
 removal
Message-ID: <20140106161001.GJ30156@lee--X1>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
 <20140106131920.GT31886@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140106131920.GT31886@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Jan 2014, Mark Brown wrote:

> On Fri, Jan 03, 2014 at 03:27:45PM +0200, Peter Ujfalusi wrote:
> > Hi,
> > 
> > After the twl6040 codec, now it is time for the twl4030 codec driver to loose
> > it's local reg cache and let the MFD core's regmap to take care of the caching.
> 
> This all looks good to me - Lee/Samuel how do you want to handle this,
> are you OK with merging the MFD bits via ASoC or something else?

Are you planning on taking this in for v3.14? Only we're on -rc7 already.

It also depends how closely knit the MFD changes are to the ASoC ones.

Are they completely dependant? 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
