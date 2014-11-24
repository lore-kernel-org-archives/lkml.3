Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaKXKq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:46:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21078 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaKXKqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:46:54 -0500
X-AuditID: cbfee68d-f79296d000004278-07-54730c9b5a30
Message-id: <54730C9B.20807@samsung.com>
Date: Mon, 24 Nov 2014 19:46:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: a.zummo@towertech.it
Cc: Chanwoo Choi <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, lgirdwood@gmail.com,
        sbkim73@samsung.com, sameo@linux.intel.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 4/5] rtc: s5m: Add the support for S2MPS13 RTC
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
 <1416301183-10478-5-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416301183-10478-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkQHcOT3GIwcM4iyUXr7JbTH34hM3i
	+pfnrBbzj5xjtfgzoZXNYtL9CSwWr18YWpxtesNucf/rUUaLb1c6mCwu75rDZvF0wkU2i9Pd
	rBYXV3xhcuDz2DnrLrvHplWdbB53ru1h85h3MtCjb8sqRo/p834yeXzeJBfAHsVlk5Kak1mW
	WqRvl8CV8XfKY9aCq/IVC04eZmpg7JDsYuTkkBAwkbiw5iELhC0mceHeerYuRi4OIYGljBIr
	bq1igSn6cuctM0RiOqPEzndbWSCc14wSlw9uYQOp4hXQkPg+az0riM0ioCox+9VjJhCbTUBL
	Yv+LG2A1ogJhEiunX2GBqBeU+DH5HpgtIiAhsWTOHUaQocwC55kkZs+5wAiSEBZwkbhwpYER
	Ylsjo8SrycvYuxg5ODgF3CTOz0kBqWEW0JHY3zqNDcKWl9i8BuJUCYGpHBIbW58xQVwkIPFt
	8iEWkF4JAVmJTQeYIV6TlDi44gbLBEaxWUhumoVk7CwkYxcwMq9iFE0tSC4oTkovMtQrTswt
	Ls1L10vOz93ECIzm0/+e9e5gvH3A+hCjAAejEg/vh41FIUKsiWXFlbmHGE2BrpjILCWanA9M
	GXkl8YbGZkYWpiamxkbmlmZK4ryKUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBebnDf
	tNpKWPRuxNTy3ztXKh6b0sSy1lTmzgUH49wzH28KuNdu3GhydGn228wMe+e0q7Ip7O82LWQq
	vHwnxWGuX2jXmxMWfmzV3xbLfve0U3vCrCt67HrmvvDUvek/VrC0dm2a5Nnixpjst/DTNw+d
	t5tcXqaJRy45Gyp75b3L/Ak/zU8sO3lciaU4I9FQi7moOBEAI16FW+ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd3ZPMUhBvvPmVgsuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsXj9wtDibNMbdov7X48yWny70sFkcXnXHDaLpxMuslmc
	7ma1uLjiC5MDn8fOWXfZPTat6mTzuHNtD5vHvJOBHn1bVjF6TJ/3k8nj8ya5APaoBkabjNTE
	lNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCLlRTKEnNKgUIB
	icXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZf6c8Zi24Kl+x4ORhpgbGDskuRk4OCQET
	iS933jJD2GISF+6tZ+ti5OIQEpjOKLHz3VYWCOc1o8Tlg1vYQKp4BTQkvs9azwpiswioSsx+
	9ZgJxGYT0JLY/+IGWI2oQJjEyulXWCDqBSV+TL4HZosISEgsmXOHEWQos8B5JonZcy4wgiSE
	BVwkLlxpYITY1sgo8WryMvYuRg4OTgE3ifNzUkBqmAV0JPa3TmODsOUlNq95yzyBUWAWkh2z
	kJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwsngmvYNxVYPFIUYBDkYlHt4Z
	64tChFgTy4orcw8xSnAwK4nw7mMsDhHiTUmsrEotyo8vKs1JLT7EaAoMgonMUqLJ+cBEllcS
	b2hsYmZkaWRuaGFkbK4kznvjZm6IkEB6YklqdmpqQWoRTB8TB6dUA+Nc9huNffq8v/71qOyW
	+Cb2uTpv5VbH/oau3ctqi8J9Hkacbv50fodh3r+MRyfXx9ayf7SZoDXxom/fub/71mX/YzR7
	bnA5MrJdQ8yaP1D0i8X+IsXPy+sey8R0xP1dv/XSc62C1eozWC8s/Jy83mnK349hfwJX6gp9
	c9yn3TQh/zOv15mZS1mVWIozEg21mIuKEwEorSUoLAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alessandro,

Could you please review these patchset?
Other patches of these patchset ended up getting Ack message from each Maintainer.

Best Regards,
Chanwoo Choi

On 11/18/2014 05:59 PM, Chanwoo Choi wrote:
> This patch adds only the compatible string for S2MPS13 RTC which is identical
> with S2MPS14 RTC driver.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/rtc/rtc-s5m.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
> index 8754c33..e5fdfd3 100644
> --- a/drivers/rtc/rtc-s5m.c
> +++ b/drivers/rtc/rtc-s5m.c
> @@ -191,6 +191,7 @@ static inline int s5m_check_peding_alarm_interrupt(struct s5m_rtc_info *info,
>  		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
>  		val &= S5M_ALARM0_STATUS;
>  		break;
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
>  				&val);
> @@ -254,6 +255,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
>  	case S5M8767X:
>  		data &= ~S5M_RTC_TIME_EN_MASK;
>  		break;
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		data |= S2MPS_RTC_RUDR_MASK;
>  		break;
> @@ -311,7 +313,9 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>  	u8 data[info->regs->regs_count];
>  	int ret;
>  
> -	if (info->device_type == S2MPS14X) {
> +	switch (info->device_type) {
> +	case S2MPS13X:
> +	case S2MPS14X:
>  		ret = regmap_update_bits(info->regmap,
>  				info->regs->rtc_udr_update,
>  				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
> @@ -333,6 +337,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
>  		break;
> @@ -359,6 +364,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
>  		s5m8763_tm_to_data(tm, data);
>  		break;
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		ret = s5m8767_tm_to_data(tm, data);
>  		break;
> @@ -406,6 +412,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
>  		alrm->enabled = 0;
> @@ -454,6 +461,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		for (i = 0; i < info->regs->regs_count; i++)
>  			data[i] &= ~ALARM_ENABLE_MASK;
> @@ -498,6 +506,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		data[RTC_SEC] |= ALARM_ENABLE_MASK;
>  		data[RTC_MIN] |= ALARM_ENABLE_MASK;
> @@ -537,6 +546,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  		break;
>  
>  	case S5M8767X:
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		s5m8767_tm_to_data(&alrm->time, data);
>  		break;
> @@ -641,6 +651,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
>  		ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
>  		break;
>  
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
>  		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
> @@ -678,6 +689,7 @@ static int s5m_rtc_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	switch (pdata->device_type) {
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		regmap_cfg = &s2mps14_rtc_regmap_config;
>  		info->regs = &s2mps_rtc_regs;
> @@ -831,6 +843,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
>  
>  static const struct platform_device_id s5m_rtc_id[] = {
>  	{ "s5m-rtc",		S5M8767X },
> +	{ "s2mps13-rtc",	S2MPS13X },
>  	{ "s2mps14-rtc",	S2MPS14X },
>  };
>  
> 

