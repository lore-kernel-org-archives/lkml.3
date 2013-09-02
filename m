Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3IBIpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:45:44 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:37180 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3IBIpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:45:43 -0400
Date: Mon, 2 Sep 2013 09:45:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: twl6040: Use regmap for register cache
Message-ID: <20130902084538.GD12341@lee--X1>
References: <1377967699-10277-1-git-send-email-broonie@kernel.org>
 <20130902081759.GC12341@lee--X1>
 <20130902082941.GN20329@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130902082941.GN20329@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Sep 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Mon, Sep 02, 2013 at 09:17:59AM +0100, Lee Jones wrote:
> > On Sat, 31 Aug 2013, Mark Brown wrote:
> > 
> > > From: Mark Brown <broonie@linaro.org>
> > > 
> > > Rather then open coding a cache of the vibra control registers use the
> > > regmap cache code.  Also cache the interrupt mask register, providing
> > > a small performance improvement for the interrupt code.
> > > 
> > > Signed-off-by: Mark Brown <broonie@linaro.org>
> > > ---
> > > 
> > > I'm hoping to have some ASoC improvements to build on top of this (there
> > > is ASoC level register caching for the device) so it might make sense to
> > > apply this via ASoC.
> > > 
> > >  drivers/mfd/twl6040.c       | 43 ++++++++++++++++++++++++++++++-------------
> > >  include/linux/mfd/twl6040.h |  1 -
> > >  2 files changed, 30 insertions(+), 14 deletions(-)
> > 
> > Applied with Peter's Ack, thanks.
> Please hold on. I'm preparing a branch for Mark to pull from and it will
> contain that patch.

Ah, I thought that was another set.

No problem. I've removed it from my branch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
