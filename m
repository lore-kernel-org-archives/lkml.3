Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3ILMTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:19:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:60275 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab3ILMTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:19:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,890,1371106800"; 
   d="scan'208";a="359488590"
Date: Thu, 12 Sep 2013 15:25:03 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@kernel.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 8/9] spi: prepare runtime PM support for SPI devices
Message-ID: <20130912122503.GS7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130912093145.GA29403@sirena.org.uk>
 <20130912094302.GM7393@intel.com>
 <14222641.vVF4lKBqCB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14222641.vVF4lKBqCB@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 01:04:55PM +0200, Rafael J. Wysocki wrote:
> On Thursday, September 12, 2013 12:43:02 PM Mika Westerberg wrote:
> > On Thu, Sep 12, 2013 at 10:31:45AM +0100, Mark Brown wrote:
> > > On Thu, Sep 12, 2013 at 12:27:43PM +0300, Mika Westerberg wrote:
> > > > On Wed, Sep 11, 2013 at 04:51:20PM +0100, Mark Brown wrote:
> > > 
> > > > > I would be able to have this and the other patch in the SPI tree in case
> > > > > it overlaps with other work - I'm not sure what the plan will be for
> > > > > merging this stuff but if there were a branch which I could merge into
> > > > > the SPI tree that'd be good.
> > > 
> > > > I think these two can go via your SPI tree as they shouldn't have
> > > > dependencies to the I2C tree.
> > > 
> > > There's all the driver changes though - it seems best to push the whole
> > > series through one branch so there's fewer bisection problems.
> > 
> > Ah, right. Then I suppose the right tree would be the I2C tree (as majority
> > of the patches are I2C related)?
> > 
> > Wolfram, are you OK with this?
> 
> Alternatively, I can apply them too if everyone is OK with that.

Sounds good to me, thanks!
