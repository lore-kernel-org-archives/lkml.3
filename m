Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaCJDkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:40:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:17128 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaCJDko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,621,1389772800"; 
   d="scan'208";a="416766837"
Date: Mon, 10 Mar 2014 09:10:37 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: Re: [PATCHv8 1/4] power_supply: Add inlmt,iterm, min/max temp props
Message-ID: <20140310034037.GA27798@jenny-desktop>
References: <1394170174-21959-1-git-send-email-jenny.tc@intel.com>
 <1394170174-21959-2-git-send-email-jenny.tc@intel.com>
 <20140307201240.GC27645@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307201240.GC27645@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 09:12:40PM +0100, Pavel Machek wrote:
> On Fri 2014-03-07 10:59:31, Jenny TC wrote:
> > Add new power supply properties for input current, charge termination
> > current, min and max temperature
> > 
> > POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
> > POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature
> > 
> > POWER_SUPPLY_PROP_INLMT - input current limit programmed by charger. Indicates
> > the input current for a charging source.
> > 
> > POWER_SUPPLY_PROP_CHARGE_TERM_CUR - Charge termination current used to detect
> > the end of charge condition
> > 
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> 
> The patch no longer matches the description, otherwise it looks good.

Will fix it in next patch set
