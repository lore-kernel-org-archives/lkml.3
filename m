Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaA2Jgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:36:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37029 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaA2Jgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:36:41 -0500
Date: Wed, 29 Jan 2014 10:36:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jenny Tc <jenny.tc@intel.com>
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
Subject: Re: [PATCH 4/4] power_supply: bq24261 charger driver
Message-ID: <20140129093633.GA16691@amd.pavel.ucw.cz>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
 <1390411194-21410-5-git-send-email-jenny.tc@intel.com>
 <20140128141445.GC8713@xo-6d-61-c0.localdomain>
 <20140129132334.GB15355@jenny-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129132334.GB15355@jenny-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-01-29 18:53:34, Jenny Tc wrote:
> On Tue, Jan 28, 2014 at 07:14:45AM -0700, Pavel Machek wrote:
> > > +#define BQ24261_ICHRG_MASK		(0x1F << 3)
> > > +#define BQ24261_ICHRG_100ma		(0x01 << 3)
> > > +#define BQ24261_ICHRG_200ma		(0x01 << 4)
> > > +#define BQ24261_ICHRG_400ma		(0x01 << 5)
> > > +#define BQ24261_ICHRG_800ma		(0x01 << 6)
> > > +#define BQ24261_ICHRG_1600ma		(0x01 << 7)
> > 
> > First, its mA, not ma.
> 
> Camel Case allowed? Ignore Checkpatch.pl warning?

This is not camel case, this is mili ampers. 

> > (x/50) << 3, right ?
> 
> Few register settings need table mapping, but some can have logic as your
> comment say. Just wanted to keep same logic for all register settings.
> Doesn't it make more readable?

No, it is definitely not readable. Please use logic where you can.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
