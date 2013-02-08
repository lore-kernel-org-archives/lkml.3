Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946063Ab3BHHa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:30:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:16750 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3BHHax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:30:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,627,1355126400"; 
   d="scan'208";a="288179801"
Date: Fri, 8 Feb 2013 09:34:28 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: zergmk2 <zergmk2@gmail.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 00/10] spi/pxa2xx: add Intel Lynxpoint SPI controller
 support
Message-ID: <20130208073428.GG20771@intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACb1VKtD+pc5cAJAqBg82uCXH_icm9fk1yLB_UnwmEq4Lq-NVQ@mail.gmail.com>
 <20130201102247.GM869@intel.com>
 <20130204094548.GA4720@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204094548.GA4720@opensource.wolfsonmicro.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark/Grant,

On Mon, Feb 04, 2013 at 05:45:49PM +0800, Mark Brown wrote:
> On Fri, Feb 01, 2013 at 12:22:47PM +0200, Mika Westerberg wrote:
> 
> > Mark, thank you for applying patches 1-4/10. Is there anything you want me
> > to do for the rest of the patches in order to get those merged?
> 
> I stopped at patch 4 mostly because it's very large but also because you
> said you were hoping for an ack from Linus.

It is large because I had to break out the private PXA DMA implementation
from the driver and I'm not sure if it can be split into a smaller patches.
The series has been tested on PXA by Lu Cao at Marvell and Linus W acked
the DMA patches.

Do you think you could take this for 3.9 or is there anything (besides the
one patch being large) preventhing this?

Thanks!
