Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbbARRr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 12:47:59 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53693 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbARRrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 12:47:55 -0500
Date: Sun, 18 Jan 2015 17:47:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        sameo@linux.intel.com, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com
Subject: Re: [PATCH 0/3] X-Power AXP288 PMIC Fuel Gauge Driver
Message-ID: <20150118174750.GG3574@x1>
References: <20150107212328.GA3440@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150107212328.GA3440@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So now I have this odd looking front cover letter randomly in my
inbox.

Please sent patch-sets threaded, so that they cling together.

> X-Power AXP288 PMIC Fuel Gauge Driver
> 
>  new power_supply driver at driver/power
>  interfaces with the axp20x mfd driver as a cell
>  provides battery info and monitors for changes
>  generates alerts on temperature and capacity issues

Use the full 76 chars for full sentences, or if this is a
bullet-pointed list, use actual bullet points.

> (1/3) mfd/axp20x.c: change the battery cell name to fuel_gauge
> (2/3) mfd/axp20x.h: add the register defs and platform struct for fuel gauge
> (3/3) power/axp288_fuel_gauge.c: axp288 fuel gauge driver

Don't hand-roll your own cover letters, use --cover-letter when
creating your patch-sets instead.

> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> ----
>  drivers/mfd/axp20x.c              |   10 +-
>  drivers/power/Kconfig             |    9 +
>  drivers/power/Makefile            |    1 +
>  drivers/power/axp288_fuel_gauge.c | 1108 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/axp20x.h        |   43 ++-
>  5 files changed, 1164 insertions(+), 7 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
