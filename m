Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaA3RB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:01:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51137 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaA3RBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:01:55 -0500
Date: Thu, 30 Jan 2014 18:01:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jenny TC <jenny.tc@intel.com>
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
Message-ID: <20140130170154.GA16503@amd.pavel.ucw.cz>
References: <1391103052-10954-1-git-send-email-jenny.tc@intel.com>
 <1391103052-10954-5-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391103052-10954-5-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 77535fd..6d184c8 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -59,4 +59,5 @@ obj-$(CONFIG_CHARGER_BQ24735)	+= bq24735-charger.o
>  obj-$(CONFIG_POWER_AVS)		+= avs/
>  obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
>  obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
> +obj-$(CONFIG_BQ24261_CHARGER)	+= bq24261_charger.o
>  obj-$(CONFIG_POWER_RESET)	+= reset/

I believe I commented on this one before. Spot two inconsistencies.

> +	int (*set_inlmt) (int val);
> +	int (*set_iterm) (int val);

And stop using cryptic names.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
