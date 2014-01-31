Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaAaEFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 23:05:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:16451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbaAaEFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 23:05:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,754,1384329600"; 
   d="scan'208";a="473662731"
Date: Fri, 31 Jan 2014 09:35:05 +0530
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
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: Re: [PATCH 4/4] power_supply: bq24261 charger driver
Message-ID: <20140131040505.GA32607@jenny-desktop>
References: <1391103052-10954-1-git-send-email-jenny.tc@intel.com>
 <1391103052-10954-5-git-send-email-jenny.tc@intel.com>
 <20140130170154.GA16503@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130170154.GA16503@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 06:01:54PM +0100, Pavel Machek wrote:
> Hi!
> 
> > diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> > index 77535fd..6d184c8 100644
> > --- a/drivers/power/Makefile
> > +++ b/drivers/power/Makefile
> > @@ -59,4 +59,5 @@ obj-$(CONFIG_CHARGER_BQ24735)	+= bq24735-charger.o
> >  obj-$(CONFIG_POWER_AVS)		+= avs/
> >  obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
> >  obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
> > +obj-$(CONFIG_BQ24261_CHARGER)	+= bq24261_charger.o
> >  obj-$(CONFIG_POWER_RESET)	+= reset/
> 
> I believe I commented on this one before. Spot two inconsistencies.

Sorry, couldn't find two inconsistencies. One is use of _. And the other?
