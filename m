Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaA2LVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:21:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:27143 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaA2LVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:21:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,741,1384329600"; 
   d="scan'208";a="472583359"
Date: Thu, 30 Jan 2014 00:43:24 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali Roh?r <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "freemangordon@abv.bg" <freemangordon@abv.bg>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] power_supply: Introduce Generic Power Supply
 charging driver
Message-ID: <20140129191324.GC15355@jenny-desktop>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
 <1390411194-21410-3-git-send-email-jenny.tc@intel.com>
 <20140125170402.GA27959@Nokia-N900>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125170402.GA27959@Nokia-N900>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 10:04:03AM -0700, Pavel Machek wrote:
> > +	* Write access using set_property
> > +		* Set Maximum charging current
> > +		* Action: Configure safety charging registers if any. If not no
> > +			  actions expected for this.
> 
> Having property that does nothing sounds evil to me.

No h/w actions expected. But driver action expected. Will fix in next patch set

> > +* POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING
> > +	* Write access using set_property
> > +		* Enable/Disable charging. Charger supplies power to platform,
> > +		  but charging is disabled
> 
> This is unclear. Charging is always disabled?

Writing 0, disables charger. Writing 1 enables charging. 

-Jenny
