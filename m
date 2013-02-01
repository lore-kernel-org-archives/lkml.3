Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3BAKTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:19:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:48886 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab3BAKTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:19:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="256093043"
Date: Fri, 1 Feb 2013 12:22:47 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: zergmk2 <zergmk2@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 00/10] spi/pxa2xx: add Intel Lynxpoint SPI controller
 support
Message-ID: <20130201102247.GM869@intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACb1VKtD+pc5cAJAqBg82uCXH_icm9fk1yLB_UnwmEq4Lq-NVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACb1VKtD+pc5cAJAqBg82uCXH_icm9fk1yLB_UnwmEq4Lq-NVQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 02:32:03PM +0800, zergmk2 wrote:
> I've verified your patch and spi bus worked properly on PXA910 platform.
> I used a debug tool to send data on spi bus, and I connected spi out pin
> and spi in pin.
> So when I read data from spi bus, it should be what I sent from spi bus.
> The test showed the expected result.
> Tested-by: Lu Cao <lucao@marvell.com>

Thank you very much for testing!

Mark, thank you for applying patches 1-4/10. Is there anything you want me
to do for the rest of the patches in order to get those merged?
