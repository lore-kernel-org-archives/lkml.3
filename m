Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950AbaA2FQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 00:16:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:58880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaA2FQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 00:16:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,740,1384329600"; 
   d="scan'208";a="474193862"
Date: Wed, 29 Jan 2014 18:38:25 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "freemangordon@abv.bg" <freemangordon@abv.bg>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH 1/4] power_supply: Add inlmt,iterm, min/max temp props
Message-ID: <20140129130825.GA15355@jenny-desktop>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
 <1390411194-21410-2-git-send-email-jenny.tc@intel.com>
 <52E285DF.5020708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E285DF.5020708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 08:25:19AM -0700, Dmitry Eremin-Solenikov wrote:
> On 22/01/14 21:19, Jenny TC wrote:
> > Add new power supply properties for input current, charge termination
> > current, min and max temperature
> > 
> > POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
> > POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature
> 
> What is the difference from TEMP_ALERT_MIN/TEMP_ALERT_MAX ?
> There is a difference in definitions, but what is the logical difference?
TEMP_ALERT_MIN/MAX is to ALERT when temperature cross the threshold.
TEMP_MIN/MAX is to stop charging/discharging when cross the threshold.

> 
> > POWER_SUPPLY_PROP_INLMT - input current limit programmed by charger. Indicates
> > the input current for a charging source.
> > POWER_SUPPLY_PROP_CHARGE_TERM_CUR - Charge termination current used to detect
> > the end of charge condition
> 
> For both of them:
> 
> 1) Please don't use obscure abbreviations
 Agreed
> 2) Is this generic enough? I.e. besides your charge manager who will
> use that?
Generic and all charger drivers can use this.

> > -- 
> With best wishes
> Dmitry

-Jenny
