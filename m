Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaBULKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:10:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45583 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138AbaBULKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:10:32 -0500
Date: Fri, 21 Feb 2014 11:10:30 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: patches@opensource.wolfsonmicro.com, lee.jones@linaro.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Remove cache_bypass from manual register
	patching
Message-ID: <20140221111030.GD5438@opensource.wolfsonmicro.com>
References: <1392913608-23479-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140220233058.GC12197@sirena.org.uk> <20140221093855.GC5438@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221093855.GC5438@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 09:38:55AM +0000, Charles Keepax wrote:
> On Fri, Feb 21, 2014 at 08:30:58AM +0900, Mark Brown wrote:
> > On Thu, Feb 20, 2014 at 04:26:48PM +0000, Charles Keepax wrote:
> > 
> > > As the cache_bypass is not strictly necessary for applying the patches
> > > (the device is always powered on whilst it is applied) remove the calls
> > > to regcache_cache_bypass to avoid this situation.
> > 
> 
> Good point on the manual patch application it could potentially
> clobber some user setup. Although the current register patch
> should not cause any issues on this front.

Except for the update to the noise gate control register that I
missed :-(

Thanks,
Charles
