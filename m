Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaIZOWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:22:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:48725 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbaIZOWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597280296"
Message-ID: <1411741357.22717.4.camel@linux.intel.com>
Subject: Re: [PATCH] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Weike Chen <alvin.chen@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>
Date: Fri, 26 Sep 2014 17:22:37 +0300
In-Reply-To: <20140926100832.GE27755@sirena.org.uk>
References: <1411752349-31490-1-git-send-email-alvin.chen@intel.com>
	 <1411752349-31490-2-git-send-email-alvin.chen@intel.com>
	 <20140926100832.GE27755@sirena.org.uk>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 11:08 +0100, Mark Brown wrote:
> On Fri, Sep 26, 2014 at 10:25:49AM -0700, Weike Chen wrote:

[]

>   It might also be helpful for review to have two
> patches, one splitting things out into the functions and another adding
> the Quark support.

I also suggest to go this way.

> 
> > +/*  see Quark SPI data sheet for implementation rationale */
> > +static u32 quark_x1000_set_clk_regvals(u32 rate, u32 *dds, u32 *clk_div)
> > +{
> 
> Please document this in the driver - I don't know if this datasheet is
> public but even if it is it may not stay that way.

Datasheet is public.
I'm just wondering if we can use just a formula instead of table.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

