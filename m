Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaAWI7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:59:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31936 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaAWI65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:58:57 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-7c-52e0d9cda40e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jenny TC'" <jenny.tc@intel.com>, linux-kernel@vger.kernel.org,
        "'Dmitry Eremin-Solenikov'" <dbaryshkov@gmail.com>
Cc: "'Anton Vorontsov'" <cbouatmailru@gmail.com>,
        "'Anton Vorontsov'" <anton.vorontsov@linaro.org>,
        "'Kim Milo'" <Milo.Kim@ti.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Rupesh Kumar'" <rupesh.kumar@stericsson.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "=?utf-8?Q?'Pali_Roh=C3=A1r'?=" <pali.rohar@gmail.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rhyland Klein'" <rklein@nvidia.com>, "'Pavel Machek'" <pavel@ucw.cz>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Sebastian Reichel'" <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
 <1390411194-21410-5-git-send-email-jenny.tc@intel.com>
In-reply-to: <1390411194-21410-5-git-send-email-jenny.tc@intel.com>
Subject: Re: [PATCH 4/4] power_supply: bq24261 charger driver
Date: Thu, 23 Jan 2014 17:58:52 +0900
Message-id: <000001cf1819$56eb3d60$04c1b820$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8XVEIOKxs1FM+eSuGiWmDEp44G1QAwRM4A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t8zA92zNx8EGbRfFLZY88LB4mLrbRaL
	f7NPsVnMPH+Z3eL6l+esFpOevGe2mLhyMrPF4696Fmu/9rBbXF54idViyeT5rBb3vx5ltLi8
	aw6bxewl/SwWty/zWiz/tY7FYuLp30wWd08dZbNYdnw1q8X7+bcYLU7+6WW0WP4pwmL/FS8H
	cY+j51+xerQ097B5fPs6icVj56y77B6Hvy5k8di8Qstj8Z6XTB53ru1h81jy5hCrR2/zOzaP
	lxN/s3nsPfSD3aNvyypGj+9L17B7HL+xncljxerv7AGCUVw2Kak5mWWpRfp2CVwZh+95FXy9
	z1hxsvM6YwPjt42MXYycHBICJhKrn/9ihrDFJC7cW8/WxcjFISSwjFGiefknuKLmq7sYIRLT
	GSWWz93PDuH8YpTYMreBDaSKTUBN4suXw+wgtohAqcTxZx+YQYqYBaawSVw6cgtsh5BAtcTC
	lVvAxnIKOEs8vQ3RLCxgK7H49H6wZhYBVYlD3TPA4rxA8ZeNP1ghbEGJH5PvsXQxcgANVZeY
	MiUXJMwsIC+xec1bZpCwBFD40V9diBOMJCYd2MMIUSIise/FO7AHJAQ2c0p87/3ECrFKQOLb
	5EMsEL2yEpsOQENCUuLgihssExglZiFZPAth8Swki2ch2bCAkWUVo2hqQXJBcVJ6kalecWJu
	cWleul5yfu4mRkgKm7iD8f4B60OMyUDbJzJLiSbnA1NgXkm8obGZkYWpiamxkbmlGWnCSuK8
	6Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwTsv7EyZR0blTO/WU1OR1he90nKpCOMRO
	/7TeLPnGtevs/a+PDyZ6eTwX8bwQaKPfo5wbwfffa/eE+mOmnzZ51HZ6cLYeu8MvxSV2/cTB
	7wabWTmzjIti437fVstzKz3XZRewR/2lbnaWZ9TD8y3d2/yr9cr3JWfWf3h/yN3iwaE6iaCp
	ha+UWIozEg21mIuKEwHP31p/dwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsVy+t9jQd2zNx8EGax5wWGx5oWDxcXW2ywW
	/2afYrOYef4yu8X1L89ZLSY9ec9sMXHlZGaLx1/1LNZ+7WG3uLzwEqvFksnzWS3ufz3KaHF5
	1xw2i9lL+lksbl/mtVj+ax2LxcTTv5ks7p46ymax7PhqVov3828xWpz808tosfxThMX+K14O
	4h5Hz79i9Whp7mHz+PZ1EovHzll32T0Of13I4rF5hZbH4j0vmTzuXNvD5rHkzSFWj97md2we
	Lyf+ZvPYe+gHu0ffllWMHt+XrmH3OH5jO5PHitXf2QMEoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAIaGkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzDh8z6vg633GipOd1xkbGL9tZOxi5OSQEDCRaL66C8oWk7hwbz1b
	FyMXh5DAdEaJ5XP3s0M4vxgltsxtYAOpYhNQk/jy5TA7iC0iUCpx/NkHZpAiZoEpbBKXjtxi
	BkkICVRLLFy5BWwsp4CzxNPbEM3CArYSi0/vB2tmEVCVONQ9AyzOCxR/2fiDFcIWlPgx+R5L
	FyMH0FB1iSlTckHCzALyEpvXvGUGCUsAhR/91YU4wUhi0oE9jBAlIhL7XrxjnMAoNAvJoFkI
	g2YhGTQLSccCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEJ8pn0DsZVDRaHGAU4GJV4
	eBO+3A8SYk0sK67MPcQowcGsJML778CDICHelMTKqtSi/Pii0pzU4kOMyUBvTmSWEk3OBybv
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgzLy5fBa307OY
	LfaB60Qin9xYZiCy/o25wdp/Syo3Vc7IfrGqS+iU4/5pT7f+Wh94kduSpUnlfknjk9Nd9778
	jjDPf7WCc3/R6wn32H/F/qn22Kuw896NzC+y5R/+3nd9MUeJN1UpSzslvWL9hyv6G+/OnuA1
	q+izcS0/87W7Tvc3mi1w3eu7QUCJpTgj0VCLuag4EQAO/vgi1AMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 23, 2014 2:20 AM, Jenny TC wrote:
> 
> This patch introduces BQ24261 charger driver. The driver makes use of power
> supply charging driver to setup charging. So the driver does hardware
> abstraction and handles h/w specific corner cases. The charging logic resides
> with power supply charging driver
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>

Hi Jenny,

Thank you for including me.
I added some minor comments. :-)

> ---
>  drivers/power/Kconfig                 |   10 +
>  drivers/power/Makefile                |    1 +
>  drivers/power/bq24261_charger.c       | 1447 +++++++++++++++++++++++++++++++++
>  include/linux/power/bq24261_charger.h |   33 +
>  4 files changed, 1491 insertions(+)
>  create mode 100644 drivers/power/bq24261_charger.c
>  create mode 100644 include/linux/power/bq24261_charger.h
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 655457b..3f32f61 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -408,6 +408,16 @@ config BATTERY_GOLDFISH
>  	  Say Y to enable support for the battery and AC power in the
>  	  Goldfish emulator.
> 
> +config BQ24261_CHARGER
> +	tristate "BQ24261 charger driver"
> +	select POWER_SUPPLY_CHARGER
> +	depends on I2C
> +	help
> +	  Say Y to include support for BQ24261 Charger driver. This driver
> +	  makes use of power supply charging driver. So the driver gives
> +	  the charger hardware abstraction only. Charging logic is abstracted
> +	  in the power supply charging driver.
> +
>  source "drivers/power/reset/Kconfig"
> 
>  endif # POWER_SUPPLY
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
> diff --git a/drivers/power/bq24261_charger.c b/drivers/power/bq24261_charger.c
> new file mode 100644
> index 0000000..6ac063b
> --- /dev/null
> +++ b/drivers/power/bq24261_charger.c
> @@ -0,0 +1,1447 @@
> +/*
> + * bq24261_charger.c - BQ24261 Charger I2C client driver
> + *
> + * Copyright (C) 2011 Intel Corporation
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
> + * General Public License for more details.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + * Author: Jenny TC <jenny.tc@intel.com>
> + */
> +#define DEBUG

Please insert one line between the comment and the "#define".

> +#include <linux/version.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/power_supply.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/io.h>
> +#include <linux/sched.h>
> +#include <linux/delay.h>
> +#include <linux/usb/otg.h>
> +#include <linux/power/power_supply_charger.h>
> +#include <linux/power/bq24261_charger.h>
> +#include <linux/seq_file.h>

Would you re-order these headers alphabetically?
It enhances the readability.

> +
> +#include <asm/intel_scu_ipc.h>
> +
> +#define DEV_NAME "bq24261_charger"
> +#define DEV_MANUFACTURER "TI"
> +#define MODEL_NAME_SIZE 8
> +#define DEV_MANUFACTURER_NAME_SIZE 4
> +
> +#define EXCEPTION_MONITOR_DELAY (60 * HZ)
> +#define WDT_RESET_DELAY (15 * HZ)
> +
> +/* BQ24261 registers */
> +#define BQ24261_STAT_CTRL0_ADDR		0x00
> +#define BQ24261_CTRL_ADDR		0x01
> +#define BQ24261_BATT_VOL_CTRL_ADDR	0x02
> +#define BQ24261_VENDOR_REV_ADDR		0x03
> +#define BQ24261_TERM_FCC_ADDR		0x04
> +#define BQ24261_VINDPM_STAT_ADDR	0x05
> +#define BQ24261_ST_NTC_MON_ADDR		0x06
> +
> +#define BQ24261_RESET_MASK		(0x01 << 7)
> +#define BQ24261_RESET_ENABLE		(0x01 << 7)
> +
> +#define BQ24261_FAULT_MASK		0x07
> +#define BQ24261_STAT_MASK		(0x03 << 4)
> +#define BQ24261_BOOST_MASK		(0x01 << 6)
> +#define BQ24261_TMR_RST_MASK		(0x01 << 7)
> +#define BQ24261_TMR_RST			(0x01 << 7)
> +
> +#define BQ24261_ENABLE_BOOST		(0x01 << 6)
> +
> +#define BQ24261_VOVP			0x01
> +#define BQ24261_LOW_SUPPLY		0x02
> +#define BQ24261_THERMAL_SHUTDOWN	0x03
> +#define BQ24261_BATT_TEMP_FAULT		0x04
> +#define BQ24261_TIMER_FAULT		0x05
> +#define BQ24261_BATT_OVP		0x06
> +#define BQ24261_NO_BATTERY		0x07
> +#define BQ24261_STAT_READY		0x00
> +
> +#define BQ24261_STAT_CHRG_PRGRSS	(0x01 << 4)
> +#define BQ24261_STAT_CHRG_DONE		(0x02 << 4)
> +#define BQ24261_STAT_FAULT		(0x03 << 4)
> +
> +#define BQ24261_CE_MASK			(0x01 << 1)
> +#define BQ24261_CE_DISABLE		(0x01 << 1)
> +
> +#define BQ24261_HZ_MASK			(0x01)
> +#define BQ24261_HZ_ENABLE		(0x01)
> +
> +#define BQ24261_ICHRG_MASK		(0x1F << 3)
> +#define BQ24261_ICHRG_100ma		(0x01 << 3)
> +#define BQ24261_ICHRG_200ma		(0x01 << 4)
> +#define BQ24261_ICHRG_400ma		(0x01 << 5)
> +#define BQ24261_ICHRG_800ma		(0x01 << 6)
> +#define BQ24261_ICHRG_1600ma		(0x01 << 7)
> +
> +#define BQ24261_ITERM_MASK		(0x03)
> +#define BQ24261_ITERM_50ma		(0x01 << 0)
> +#define BQ24261_ITERM_100ma		(0x01 << 1)
> +#define BQ24261_ITERM_200ma		(0x01 << 2)
> +
> +#define BQ24261_VBREG_MASK		(0x3F << 2)
> +
> +#define BQ24261_INLMT_MASK		(0x03 << 4)
> +#define BQ24261_INLMT_100		0x00
> +#define BQ24261_INLMT_150		(0x01 << 4)
> +#define BQ24261_INLMT_500		(0x02 << 4)
> +#define BQ24261_INLMT_900		(0x03 << 4)
> +#define BQ24261_INLMT_1500		(0x04 << 4)
> +#define BQ24261_INLMT_2500		(0x06 << 4)
> +
> +#define BQ24261_TE_MASK			(0x01 << 2)
> +#define BQ24261_TE_ENABLE		(0x01 << 2)
> +#define BQ24261_STAT_ENABLE_MASK	(0x01 << 3)
> +#define BQ24261_STAT_ENABLE		(0x01 << 3)
> +
> +#define BQ24261_VENDOR_MASK		(0x07 << 5)
> +#define BQ24261_VENDOR			(0x02 << 5)
> +#define BQ24261_REV_MASK		(0x07)
> +#define BQ24261_REV			(0x02)
> +#define BQ24260_REV			(0x01)
> +
> +#define BQ24261_TS_MASK			(0x01 << 3)
> +#define BQ24261_TS_ENABLED		(0x01 << 3)
> +#define BQ24261_BOOST_ILIM_MASK		(0x01 << 4)
> +#define BQ24261_BOOST_ILIM_500ma	(0x0)
> +#define BQ24261_BOOST_ILIM_1A		(0x01 << 4)
> +
> +#define BQ24261_SAFETY_TIMER_MASK	(0x03 << 5)
> +#define BQ24261_SAFETY_TIMER_40MIN	0x00
> +#define BQ24261_SAFETY_TIMER_6HR	(0x01 << 5)
> +#define BQ24261_SAFETY_TIMER_9HR	(0x02 << 5)
> +#define BQ24261_SAFETY_TIMER_DISABLED	(0x03 << 5)
> +
> +/* 1% above voltage max design to report over voltage */
> +#define BQ24261_OVP_MULTIPLIER			1010
> +#define BQ24261_OVP_RECOVER_MULTIPLIER		990
> +#define BQ24261_DEF_BAT_VOLT_MAX_DESIGN		4200000
> +
> +/* Settings for Voltage / DPPM Register (05) */
> +#define BQ24261_VBATT_LEVEL1		3700000
> +#define BQ24261_VBATT_LEVEL2		3960000
> +#define BQ24261_VINDPM_MASK		(0x07)
> +#define BQ24261_VINDPM_320MV		(0x01 << 2)
> +#define BQ24261_VINDPM_160MV		(0x01 << 1)
> +#define BQ24261_VINDPM_80MV		(0x01 << 0)
> +#define BQ24261_CD_STATUS_MASK		(0x01 << 3)
> +#define BQ24261_DPM_EN_MASK		(0x01 << 4)
> +#define BQ24261_DPM_EN_FORCE		(0x01 << 4)
> +#define BQ24261_LOW_CHG_MASK		(0x01 << 5)
> +#define BQ24261_LOW_CHG_EN		(0x01 << 5)
> +#define BQ24261_LOW_CHG_DIS		(~BQ24261_LOW_CHG_EN)
> +#define BQ24261_DPM_STAT_MASK		(0x01 << 6)
> +#define BQ24261_MINSYS_STAT_MASK	(0x01 << 7)
> +
> +#define BQ24261_MIN_CC			500
> +
> +u16 bq24261_sfty_tmr[][2] = {
> +	{0, BQ24261_SAFETY_TIMER_DISABLED}
> +	,
> +	{40, BQ24261_SAFETY_TIMER_40MIN}
> +	,
> +	{360, BQ24261_SAFETY_TIMER_6HR}
> +	,
> +	{540, BQ24261_SAFETY_TIMER_9HR}
> +	,
> +};
> +
> +
> +u16 bq24261_inlmt[][2] = {
> +	{100, BQ24261_INLMT_100}
> +	,
> +	{150, BQ24261_INLMT_150}
> +	,
> +	{500, BQ24261_INLMT_500}
> +	,
> +	{900, BQ24261_INLMT_900}
> +	,
> +	{1500, BQ24261_INLMT_1500}
> +	,
> +	{2500, BQ24261_INLMT_2500}
> +	,
> +};
> +
> +u16 bq24261_iterm[][2] = {
> +	{0, 0x00}
> +	,
> +	{50, BQ24261_ITERM_50ma}
> +	,
> +	{100, BQ24261_ITERM_100ma}
> +	,
> +	{150, BQ24261_ITERM_100ma | BQ24261_ITERM_50ma}
> +	,
> +	{200, BQ24261_ITERM_200ma}
> +	,
> +	{250, BQ24261_ITERM_200ma | BQ24261_ITERM_50ma}
> +	,
> +	{300, BQ24261_ITERM_200ma | BQ24261_ITERM_100ma}
> +	,
> +	{350, BQ24261_ITERM_200ma | BQ24261_ITERM_100ma | BQ24261_ITERM_50ma}
> +	,
> +};
> +
> +u16 bq24261_cc[][2] = {
> +
> +	{500, 0x00}
> +	,
> +	{600, BQ24261_ICHRG_100ma}
> +	,
> +	{700, BQ24261_ICHRG_200ma}
> +	,
> +	{800, BQ24261_ICHRG_100ma | BQ24261_ICHRG_200ma}
> +	,
> +	{900, BQ24261_ICHRG_400ma}
> +	,
> +	{1000, BQ24261_ICHRG_400ma | BQ24261_ICHRG_100ma}
> +	,
> +	{1100, BQ24261_ICHRG_400ma | BQ24261_ICHRG_200ma}
> +	,
> +	{1200, BQ24261_ICHRG_400ma | BQ24261_ICHRG_200ma | BQ24261_ICHRG_100ma}
> +	,
> +	{1300, BQ24261_ICHRG_800ma}
> +	,
> +	{1400, BQ24261_ICHRG_800ma | BQ24261_ICHRG_100ma}
> +	,
> +	{1500, BQ24261_ICHRG_800ma | BQ24261_ICHRG_200ma}
> +	,
> +};

These 'u16 bq24261_*' looks to be used in only this file.
Would you change these 'u16 bq24261_*' to 'static u16 bq24261_*'?

For example,
static u16 bq24261_sfty_tmr[][2] = {

[.....]

> +static void lookup_regval(u16 tbl[][2], size_t size, u16 in_val, u8 *out_val)
> +{
> +	int i;
> +	for (i = 1; i < size; ++i)

Please insert one line between variable and 'for' loop.


> +		if (in_val < tbl[i][0])
> +			break;
> +
> +	*out_val = (u8) tbl[i - 1][1];
> +}
> +
> +void bq24261_cc_to_reg(int cc, u8 *reg_val)
> +{
> +	return lookup_regval(bq24261_cc, ARRAY_SIZE(bq24261_cc), cc, reg_val);
> +
> +}
> +
> +void bq24261_cv_to_reg(int cv, u8 *reg_val)
> +{
> +	int val;
> +
> +	val = clamp_t(int, cv, BQ24261_MIN_CV, BQ24261_MAX_CV);
> +	*reg_val =
> +		(((val - BQ24261_MIN_CV) / BQ24261_CV_DIV)
> +			<< BQ24261_CV_BIT_POS);
> +}
> +
> +void bq24261_inlmt_to_reg(int inlmt, u8 *regval)
> +{
> +	return lookup_regval(bq24261_inlmt, ARRAY_SIZE(bq24261_inlmt),
> +			     inlmt, regval);
> +}

How about making these functions static?
For instance,
static void bq24261_cc_to_reg(int cc, u8 *reg_val)

> +
> +static inline void bq24261_iterm_to_reg(int iterm, u8 *regval)
> +{
> +	return lookup_regval(bq24261_iterm, ARRAY_SIZE(bq24261_iterm),
> +			     iterm, regval);
> +}
> +
> +static inline void bq24261_sfty_tmr_to_reg(int tmr, u8 *regval)
> +{
> +	return lookup_regval(bq24261_sfty_tmr, ARRAY_SIZE(bq24261_sfty_tmr),
> +			     tmr, regval);
> +}
> +
> +static inline int bq24261_read_reg(struct i2c_client *client, u8 reg)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(client, reg);
> +	if (ret < 0)
> +		dev_err(&client->dev, "Error(%d) in reading reg %d\n", ret,
> +			reg);
> +
> +	return ret;
> +}
> +
> +static inline int bq24261_write_reg(struct i2c_client *client, u8 reg, u8 data)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(client, reg, data);
> +	if (ret < 0)
> +		dev_err(&client->dev, "Error(%d) in writing %d to reg %d\n",
> +			ret, data, reg);
> +
> +	return ret;
> +}
> +
> +static inline int bq24261_read_modify_reg(struct i2c_client *client, u8 reg,
> +					  u8 mask, u8 val)
> +{
> +	int ret;
> +
> +	ret = bq24261_read_reg(client, reg);
> +	if (ret < 0)
> +		return ret;
> +	ret = (ret & ~mask) | (mask & val);
> +	return bq24261_write_reg(client, reg, ret);
> +}
> +
> +static inline int bq24261_tmr_ntc_init(struct bq24261_charger *chip)
> +{
> +	u8 reg_val;
> +	int ret;
> +
> +	bq24261_sfty_tmr_to_reg(chip->pdata->safety_timer, &reg_val);
> +
> +	if (chip->pdata->is_ts_enabled)
> +		reg_val |= BQ24261_TS_ENABLED;
> +
> +	ret = bq24261_read_modify_reg(chip->client, BQ24261_ST_NTC_MON_ADDR,
> +			BQ24261_TS_MASK|BQ24261_SAFETY_TIMER_MASK|
> +			BQ24261_BOOST_ILIM_MASK, reg_val);
> +
> +	return ret;
> +}
> +
> +static inline int bq24261_enable_charging(
> +	struct bq24261_charger *chip, bool val)
> +{
> +	int ret;
> +	u8 reg_val;
> +	bool is_ready;
> +
> +	ret = bq24261_read_reg(chip->client,
> +					BQ24261_STAT_CTRL0_ADDR);
> +	if (ret < 0) {
> +		dev_err(&chip->client->dev,
> +			"Error(%d) in reading BQ24261_STAT_CTRL0_ADDR\n", ret);
> +	}
> +
> +	is_ready =  (ret & BQ24261_STAT_MASK) != BQ24261_STAT_FAULT;
> +
> +	/* If status is fault, wait for READY before enabling the charging */
> +
> +	if (!is_ready) {
> +		ret = wait_event_timeout(chip->wait_ready,
> +			(chip->chrgr_stat != BQ24261_CHRGR_STAT_READY),
> +				HZ);
> +		dev_info(&chip->client->dev,
> +			"chrgr_stat=%x\n", chip->chrgr_stat);
> +		if (ret == 0) {
> +			dev_err(&chip->client->dev,
> +				"Waiting for Charger Ready Failed.Enabling charging anyway\n");
> +		}
> +	}
> +
> +	if (val) {
> +		reg_val = (~BQ24261_CE_DISABLE & BQ24261_CE_MASK);
> +		if (chip->is_hw_chrg_term)
> +			reg_val |= BQ24261_TE_ENABLE;
> +	} else {
> +		reg_val = BQ24261_CE_DISABLE;
> +	}
> +
> +	reg_val |=  BQ24261_STAT_ENABLE;
> +
> +	ret = bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +		       BQ24261_STAT_ENABLE_MASK|BQ24261_RESET_MASK|
> +				BQ24261_CE_MASK|BQ24261_TE_MASK,
> +					reg_val);
> +	if (ret || !val) {
> +		cancel_delayed_work_sync(&chip->notify_work);
> +		return ret;
> +	}
> +
> +	bq24261_set_iterm(chip, chip->iterm);
> +	schedule_delayed_work(&chip->notify_work, 0);
> +	bq24261_enable_hw_charge_term(chip, true);
> +	return bq24261_tmr_ntc_init(chip);
> +}
> +
> +static inline int bq24261_reset_timer(struct bq24261_charger *chip)
> +{
> +	return bq24261_read_modify_reg(chip->client, BQ24261_STAT_CTRL0_ADDR,
> +			BQ24261_TMR_RST_MASK, BQ24261_TMR_RST);
> +}
> +
> +static inline int bq24261_enable_charger(
> +	struct bq24261_charger *chip, int val)
> +{
> +
> +	/* TODO: Implement enable/disable HiZ mode to enable/
> +	*  disable charger
> +	*/

According to the Coding Style, the preferred style for long (multi-line)
comments is:

+	/*
+	 *  TODO: Implement enable/disable HiZ mode to enable/
+	 *  disable charger
+	 */


> +	u8 reg_val;
> +	int ret;
> +
> +	reg_val = val ? (~BQ24261_HZ_ENABLE & BQ24261_HZ_MASK)  :
> +			BQ24261_HZ_ENABLE;
> +
> +	ret = bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +		       BQ24261_HZ_MASK|BQ24261_RESET_MASK, reg_val);
> +	if (ret)
> +		return ret;
> +
> +	return bq24261_reset_timer(chip);
> +}
> +
> +static inline int bq24261_set_cc(struct bq24261_charger *chip, int cc)
> +{
> +	u8 reg_val;
> +	int ret;
> +
> +	dev_dbg(&chip->client->dev, "cc=%d\n", cc);
> +
> +	if (cc && (cc < BQ24261_MIN_CC)) {
> +		dev_dbg(&chip->client->dev, "Set LOW_CHG bit\n");
> +		reg_val = BQ24261_LOW_CHG_EN;
> +		ret = bq24261_read_modify_reg(chip->client,
> +				BQ24261_VINDPM_STAT_ADDR,
> +				BQ24261_LOW_CHG_MASK, reg_val);
> +	} else {
> +		dev_dbg(&chip->client->dev, "Clear LOW_CHG bit\n");
> +		reg_val = BQ24261_LOW_CHG_DIS;
> +		ret = bq24261_read_modify_reg(chip->client,
> +				BQ24261_VINDPM_STAT_ADDR,
> +				BQ24261_LOW_CHG_MASK, reg_val);
> +	}
> +
> +	bq24261_cc_to_reg(cc, &reg_val);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_TERM_FCC_ADDR,
> +			BQ24261_ICHRG_MASK, reg_val);
> +}
> +
> +static inline int bq24261_set_cv(struct bq24261_charger *chip, int cv)
> +{
> +	int bat_volt;
> +	int ret;
> +	u8 reg_val;
> +	u8 vindpm_val = 0x0;
> +
> +	/*
> +	* Setting VINDPM value as per the battery voltage
> +	*  VBatt           Vindpm     Register Setting
> +	*  < 3.7v           4.2v       0x0 (default)
> +	*  3.71v - 3.96v    4.36v      0x2
> +	*  > 3.96v          4.6v       0x5
> +	*/
> +	ret = get_battery_voltage(&bat_volt);
> +	if (ret) {
> +		dev_err(&chip->client->dev,
> +			"Error getting battery voltage!!\n");
> +	} else {
> +		if (bat_volt > BQ24261_VBATT_LEVEL2)
> +			vindpm_val =
> +				(BQ24261_VINDPM_320MV | BQ24261_VINDPM_80MV);
> +		else if (bat_volt > BQ24261_VBATT_LEVEL1)
> +			vindpm_val = BQ24261_VINDPM_160MV;
> +	}
> +
> +	ret = bq24261_read_modify_reg(chip->client,
> +			BQ24261_VINDPM_STAT_ADDR,
> +			BQ24261_VINDPM_MASK,
> +			vindpm_val);
> +	if (ret) {
> +		dev_err(&chip->client->dev,
> +			"Error setting VINDPM setting!!\n");
> +		return ret;
> +	}
> +
> +
> +	bq24261_cv_to_reg(cv, &reg_val);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_BATT_VOL_CTRL_ADDR,
> +				       BQ24261_VBREG_MASK, reg_val);
> +}
> +
> +static inline int bq24261_set_inlmt(struct bq24261_charger *chip, int inlmt)
> +{
> +	u8 reg_val;
> +
> +	bq24261_inlmt_to_reg(inlmt, &reg_val);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +		       BQ24261_RESET_MASK|BQ24261_INLMT_MASK, reg_val);
> +
> +}
> +
> +static inline void resume_charging(struct bq24261_charger *chip)
> +{
> +
> +	if (chip->is_charger_enabled)
> +		bq24261_enable_charger(chip, true);
> +	if (chip->inlmt)
> +		bq24261_set_inlmt(chip, chip->inlmt);
> +	if (chip->cc)
> +		bq24261_set_cc(chip, chip->cc);
> +	if (chip->cv)
> +		bq24261_set_cv(chip, chip->cv);
> +	if (chip->is_charging_enabled)
> +		bq24261_enable_charging(chip, true);
> +}
> +
> +static inline int bq24261_set_iterm(struct bq24261_charger *chip, int iterm)
> +{
> +	u8 reg_val;
> +
> +	bq24261_iterm_to_reg(iterm, &reg_val);
> +
> +	return bq24261_read_modify_reg(chip->client, BQ24261_TERM_FCC_ADDR,
> +				       BQ24261_ITERM_MASK, reg_val);
> +}
> +
> +static inline int bq24261_enable_hw_charge_term(
> +	struct bq24261_charger *chip, bool val)
> +{
> +	u8 data;
> +	int ret;
> +
> +	data = val ? BQ24261_TE_ENABLE : (~BQ24261_TE_ENABLE & BQ24261_TE_MASK);
> +
> +
> +	ret = bq24261_read_modify_reg(chip->client, BQ24261_CTRL_ADDR,
> +			       BQ24261_RESET_MASK|BQ24261_TE_MASK, data);
> +
> +	if (ret)
> +		return ret;
> +
> +	chip->is_hw_chrg_term = val ? true : false;
> +
> +	return ret;
> +}
> +
> +

Remove unnecessary line.

> +static inline bool bq24261_is_vsys_on(struct bq24261_charger *chip)
> +{
> +	int ret;
> +	struct i2c_client *client = chip->client;
> +
> +	ret = bq24261_read_reg(client, BQ24261_CTRL_ADDR);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Error(%d) in reading BQ24261_CTRL_ADDR\n", ret);
> +		return false;
> +	}
> +
> +	if (((ret & BQ24261_HZ_MASK) == BQ24261_HZ_ENABLE) &&
> +			chip->is_charger_enabled) {
> +		dev_err(&client->dev, "Charger in Hi Z Mode\n");
> +		return false;
> +	}
> +
> +	ret = bq24261_read_reg(client, BQ24261_VINDPM_STAT_ADDR);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Error(%d) in reading BQ24261_VINDPM_STAT_ADDR\n", ret);
> +		return false;
> +	}
> +
> +	if (ret & BQ24261_CD_STATUS_MASK) {
> +		dev_err(&client->dev, "CD line asserted\n");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +

Remove unnecessary line.

> +static inline bool is_bq24261_enabled(struct bq24261_charger *chip)
> +{
> +	if (chip->cable_type == PSY_CHARGER_CABLE_TYPE_NONE)
> +		return false;
> +	else if (!chip->is_charger_enabled)
> +		return false;
> +	/* BQ24261 gives interrupt only on stop/resume charging.
> +	 * If charging is already stopped, we need to query the hardware
> +	 * to see charger is still active and can supply vsys or not.
> +	 */

According to the Coding Style, the preferred style for long (multi-line)
comments is:

+	/*
+	 * BQ24261 gives interrupt only on stop/resume charging.
+	 * If charging is already stopped, we need to query the hardware
+	 * to see charger is still active and can supply vsys or not.
+	 */


> +	else if ((chip->chrgr_stat == BQ24261_CHRGR_STAT_FAULT) ||
> +		 (!chip->is_charging_enabled))
> +		return bq24261_is_vsys_on(chip);
> +	else
> +		return chip->is_vsys_on;
> +}
> +
> +static int bq24261_usb_psyc_set_property(struct power_supply_charger *psyc,
> +				    enum power_supply_charger_property pscp,
> +				    const union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip = container_of(psyc,
> +						    struct bq24261_charger,
> +						    psyc_usb);
> +	int ret = 0;

For the readability, how about the following?

	struct bq24261_charger *chip;
	int ret = 0;

	chip = container_of(psyc, struct bq24261_charger, psyc_usb);

> +
> +	mutex_lock(&chip->lock);
> +	dev_dbg(&chip->client->dev, "%s: prop=%d, val=%d\n",
> +			__func__, pscp, val->intval);
> +
> +	switch (pscp) {
> +
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING:
> +		ret = bq24261_enable_charging(chip, val->intval);
> +
> +		if (ret)
> +			dev_err(&chip->client->dev,
> +				"Error(%d) in %s charging", ret,
> +				(val->intval ? "enable" : "disable"));
> +		else
> +			chip->is_charging_enabled = val->intval;
> +
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER:
> +		/* Don't enable the charger unless overvoltage is recovered */
> +
> +		if (chip->bat_health != POWER_SUPPLY_HEALTH_OVERVOLTAGE) {
> +			ret = bq24261_enable_charger(chip, val->intval);
> +
> +			if (ret)
> +				dev_err(&chip->client->dev,
> +					"Error(%d) in %s charger", ret,
> +					(val->intval ? "enable" : "disable"));
> +			else
> +				chip->is_charger_enabled = val->intval;
> +		} else {
> +			dev_info(&chip->client->dev, "Battery Over Voltage. Charger will be disabled\n");
> +		}
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE:
> +		chip->cable_type = val->intval;
> +		chip->psy_usb.type = get_power_supply_type(chip->cable_type);
> +		if (chip->cable_type != PSY_CHARGER_CABLE_TYPE_NONE) {
> +			chip->chrgr_health = POWER_SUPPLY_HEALTH_GOOD;
> +			chip->chrgr_stat = BQ24261_CHRGR_STAT_UNKNOWN;
> +
> +			/* Adding this processing in order to check
> +			for any faults during connect */
> +
> +			ret = bq24261_read_reg(chip->client,
> +						BQ24261_STAT_CTRL0_ADDR);
> +			if (ret < 0)
> +				dev_err(&chip->client->dev,
> +				"Error (%d) in reading status register(0x00)\n",
> +				ret);
> +			else
> +				bq24261_handle_irq(chip, ret);
> +		} else {
> +			chip->chrgr_stat = BQ24261_CHRGR_STAT_UNKNOWN;
> +			chip->chrgr_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +			cancel_delayed_work_sync(&chip->low_supply_fault_work);
> +		}
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_RESET_WDT:
> +		bq24261_reset_timer(chip);
> +		break;
> +	default:
> +		ret = -ENODATA;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +static int bq24261_usb_set_property(struct power_supply *psy,
> +				    enum power_supply_property psp,
> +				    const union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip = container_of(psy,
> +						    struct bq24261_charger,
> +						    psy_usb);
> +	int ret = 0;

For the readability, how about the following?

	struct bq24261_charger *chip;
	int ret = 0;

	chip = container_of(psyc, struct bq24261_charger, psyc_usb);

> +
> +	mutex_lock(&chip->lock);
> +
> +	switch (psp) {
> +
> +	case POWER_SUPPLY_PROP_PRESENT:
> +		chip->present = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_ONLINE:
> +		chip->online = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
> +		ret = bq24261_set_cc(chip, val->intval);
> +		if (!ret)
> +			chip->cc = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
> +		ret = bq24261_set_cv(chip, val->intval);
> +		if (!ret)
> +			chip->cv = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
> +		chip->max_cc = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
> +		chip->max_cv = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_TERM_CUR:
> +		ret = bq24261_set_iterm(chip, val->intval);
> +		if (!ret)
> +			chip->iterm = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_INLMT:
> +		ret = bq24261_set_inlmt(chip, val->intval);
> +		if (!ret)
> +			chip->inlmt = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT:
> +		chip->cntl_state = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_TEMP_MAX:
> +		chip->max_temp = val->intval;
> +		break;
> +	case POWER_SUPPLY_PROP_TEMP_MIN:
> +		chip->min_temp = val->intval;
> +		break;
> +	default:
> +		ret = -ENODATA;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +static int bq24261_usb_psyc_get_property(struct power_supply_charger *psyc,
> +				    enum power_supply_charger_property pscp,
> +				    union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip = container_of(psyc,
> +						    struct bq24261_charger,
> +						    psyc_usb);
> +

For the readability, how about the following?

	struct bq24261_charger *chip;

	chip = container_of(psyc, struct bq24261_charger, psyc_usb);


> +	mutex_lock(&chip->lock);
> +
> +	switch (pscp) {
> +	case POWER_SUPPLY_CHARGER_PROP_CABLE_TYPE:
> +		val->intval = chip->cable_type;
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGING:
> +		val->intval = (chip->is_charging_enabled &&
> +			(chip->chrgr_stat == BQ24261_CHRGR_STAT_CHARGING));
> +
> +		break;
> +	case POWER_SUPPLY_CHARGER_PROP_ENABLE_CHARGER:
> +		val->intval = is_bq24261_enabled(chip);
> +		break;
> +	default:
> +		mutex_unlock(&chip->lock);
> +		return -EINVAL;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return 0;
> +}
> +
> +static int bq24261_usb_get_property(struct power_supply *psy,
> +				    enum power_supply_property psp,
> +				    union power_supply_propval *val)
> +{
> +	struct bq24261_charger *chip = container_of(psy,
> +						    struct bq24261_charger,
> +						    psy_usb);
> +

For the readability, how about the following?

	struct bq24261_charger *chip;

	chip = container_of(psyc, struct bq24261_charger, psyc_usb);


[.....]

> +
> +MODULE_DEVICE_TABLE(i2c, bq24261_id);
> +
> +static struct i2c_driver bq24261_driver = {
> +	.driver = {
> +		   .name = DEV_NAME,
> +		   },

Please fix indent problem as below:

+	},


> +	.probe = bq24261_probe,
> +	.remove = bq24261_remove,
> +	.id_table = bq24261_id,
> +};
> +
> +static int __init bq24261_init(void)
> +{
> +	return i2c_add_driver(&bq24261_driver);
> +}
> +
> +module_init(bq24261_init);
> +
> +static void __exit bq24261_exit(void)
> +{
> +	i2c_del_driver(&bq24261_driver);
> +}
> +
> +module_exit(bq24261_exit);

Please use module_i2c_driver() macro in order to make the code
simpler. Then, above 13 lines can be one line as below.

module_i2c_driver(bq24261_driver);

> +
> +MODULE_AUTHOR("Jenny TC <jenny.tc@intel.com>");
> +MODULE_DESCRIPTION("BQ24261 Charger Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/power/bq24261_charger.h b/include/linux/power/bq24261_charger.h
> new file mode 100644
> index 0000000..e6b399f
> --- /dev/null
> +++ b/include/linux/power/bq24261_charger.h
> @@ -0,0 +1,33 @@
> +/*
> + * bq24261_charger.h: platform data structure for bq24261 driver
> + *
> + * (C) Copyright 2012 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#ifndef __BQ24261_CHARGER_H__
> +#define __BQ24261_CHARGER_H__
> +
> +struct bq24261_plat_data {
> +	char **supplied_to;
> +	size_t num_supplicants;
> +	struct psy_throttle_state *throttle_states;
> +	size_t num_throttle_states;
> +	int safety_timer;
> +	bool is_ts_enabled;
> +
> +	int (*enable_charging) (bool val);
> +	int (*enable_charger) (bool val);
> +	int (*set_inlmt) (int val);
> +	int (*set_cc) (int val);
> +	int (*set_cv) (int val);
> +	int (*set_iterm) (int val);
> +	int (*enable_vbus) (int val);
> +};
> +
> +

Remove unnecessary line. One line is good.

> +#endif
> --
> 1.7.9.5

