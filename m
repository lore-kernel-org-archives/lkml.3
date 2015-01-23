Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbbAWJc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:32:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:51059 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbbAWJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:32:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,453,1418112000"; 
   d="scan'208";a="641488800"
Date: Fri, 23 Jan 2015 11:32:46 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de,
        maxime.ripard@free-electrons.com, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, skuribay@pobox.com, Romain.Baeriswyl@abilis.com,
        wenkai.du@intel.com, christian.ruppert@abilis.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V4 2/2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20150123093246.GK1850@lahna.fi.intel.com>
References: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1421313137-1613-3-git-send-email-david.e.box@linux.intel.com>
 <20150122142819.GG1850@lahna.fi.intel.com>
 <20150122204851.GA11246@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122204851.GA11246@pathfinder>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:48:51PM -0800, David E. Box wrote:
> > It would be nice if it was possible to compile this as a module.
> 
> In the makefile the driver is now part of the composite object for
> I2C_DESIGNWARE_PLATFORM. So if selected it will compile as the platform driver
> is compiled. This makes the most sense since the linking doesn't work right if
> both drivers aren't built the same. This is really an extension to the platform
> driver anyway and not standalone code.

Makes sense. Thanks for the explanation.
