Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab3IBIaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:30:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:29232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab3IBIaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="scan'208";a="372142087"
Date: Mon, 2 Sep 2013 10:29:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: twl6040: Use regmap for register cache
Message-ID: <20130902082941.GN20329@zurbaran>
References: <1377967699-10277-1-git-send-email-broonie@kernel.org>
 <20130902081759.GC12341@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902081759.GC12341@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Sep 02, 2013 at 09:17:59AM +0100, Lee Jones wrote:
> On Sat, 31 Aug 2013, Mark Brown wrote:
> 
> > From: Mark Brown <broonie@linaro.org>
> > 
> > Rather then open coding a cache of the vibra control registers use the
> > regmap cache code.  Also cache the interrupt mask register, providing
> > a small performance improvement for the interrupt code.
> > 
> > Signed-off-by: Mark Brown <broonie@linaro.org>
> > ---
> > 
> > I'm hoping to have some ASoC improvements to build on top of this (there
> > is ASoC level register caching for the device) so it might make sense to
> > apply this via ASoC.
> > 
> >  drivers/mfd/twl6040.c       | 43 ++++++++++++++++++++++++++++++-------------
> >  include/linux/mfd/twl6040.h |  1 -
> >  2 files changed, 30 insertions(+), 14 deletions(-)
> 
> Applied with Peter's Ack, thanks.
Please hold on. I'm preparing a branch for Mark to pull from and it will
contain that patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
