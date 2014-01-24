Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaAXPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:25:29 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:46634 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaAXPZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:25:25 -0500
Message-ID: <52E285DF.5020708@gmail.com>
Date: Fri, 24 Jan 2014 19:25:19 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jenny TC <jenny.tc@intel.com>
CC: linux-kernel@vger.kernel.org, Kim Milo <Milo.Kim@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH 1/4] power_supply: Add inlmt,iterm, min/max temp props
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com> <1390411194-21410-2-git-send-email-jenny.tc@intel.com>
In-Reply-To: <1390411194-21410-2-git-send-email-jenny.tc@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/14 21:19, Jenny TC wrote:
> Add new power supply properties for input current, charge termination
> current, min and max temperature
> 
> POWER_SUPPLY_PROP_TEMP_MIN - minimum operatable temperature
> POWER_SUPPLY_PROP_TEMP_MAX - maximum operatable temperature

What is the difference from TEMP_ALERT_MIN/TEMP_ALERT_MAX ?
There is a difference in definitions, but what is the logical difference?

> POWER_SUPPLY_PROP_INLMT - input current limit programmed by charger. Indicates
> the input current for a charging source.
> POWER_SUPPLY_PROP_CHARGE_TERM_CUR - Charge termination current used to detect
> the end of charge condition

For both of them:

1) Please don't use obscure abbreviations
2) Is this generic enough? I.e. besides your charge manager who will
use that?

-- 
With best wishes
Dmitry
