Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3ILJT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:19:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:11817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab3ILJTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,890,1371106800"; 
   d="scan'208";a="400487505"
Date: Thu, 12 Sep 2013 12:24:47 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 6/9] mfd: wm8994: convert to use I2C core runtime PM
Message-ID: <20130912092447.GJ7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-7-git-send-email-mika.westerberg@linux.intel.com>
 <20130911161242.GA13015@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911161242.GA13015@zurbaran>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 06:12:43PM +0200, Samuel Ortiz wrote:
> Hi Mika,
> 
> On Wed, Sep 11, 2013 at 06:32:37PM +0300, Mika Westerberg wrote:
> > The I2C core now prepares runtime PM on behalf of the I2C client device, so
> > only thing the driver needs to do is to call pm_runtime_put() at the end of
> > its ->probe().
> > 
> > This patch converts wm8994 driver to use this model.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Thanks!

> I think it would make more sense for you to merge that one together with
> the related i2c changes. If you prefer that I take it through MFD,
> please let me know.

I'm hoping that Wolfram takes all the I2C related patches to his tree.
