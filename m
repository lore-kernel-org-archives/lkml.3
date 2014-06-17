Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaFQASs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:18:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46353 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaFQASo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:18:44 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-e4-539f8962d25e
Message-id: <539F8961.3070009@samsung.com>
Date: Tue, 17 Jun 2014 09:18:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, k.kozlowski@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/3] mfd: sec-core: Add support for S2MPU02 device
References: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
 <1402893757-18957-2-git-send-email-cw00.choi@samsung.com>
 <20140616130306.GU14323@lee--X1>
In-reply-to: <20140616130306.GU14323@lee--X1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkUDepc36wwdVWVYvXLwwtzja9Ybe4
	//Uoo8XlXXPYLG43rmCzON3NanFxxRcmB3aPO9f2sHnMOxno0bdlFaPH501yASxRXDYpqTmZ
	ZalF+nYJXBkLDpxgLegXrpi47BJjA+Nvvi5GDg4JAROJ9vkiXYycQKaYxIV769m6GLk4hASW
	Mkqsm/aAFSJhIjHr5CEmiMR0Rok3f7YyQzivGSXam9+zgVTxCmhJ3JvYwQhiswioSnz9dJIF
	xGYDiu9/cQOsRlQgTGLl9CssEPWCEj8m32MBuUJEQEXi3BtzkDCzwDxGiUsPmEFsYQEPie1/
	r0NdtIRR4szBTnaQBKeArsS+45dZIBrUJSbNW8QMYctLbF7zlhni6kPsEpdmWEDcIyDxbfIh
	FoiPZSU2HYAqkZQ4uOIGywRGsVlILpqFZOosJFMXMDKvYhRNLUguKE5KLzLSK07MLS7NS9dL
	zs/dxAiMstP/nvXtYLx5wPoQYzLQyonMUqLJ+cAozSuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HD
	pCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjAYMjNVro1TcJ/Me5jnwLPhMyJ+JO5/2Pw2K
	NYh9l39Myc9HZ3FgQ+Wt2g2WT+LO9XPecVjjyPunnkumSXx3yBK9wmUNH7sWt0Wli6wIfuI2
	rbeA33d2SsfdqVvPXlQMcDdbypH44J6esY5qfXDG+kOF++UzpGW8nbfIuT/++vnaM8tLeRH1
	SizFGYmGWsxFxYkATE7xBcgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQd2kzvnBBhdWyVq8fmFocbbpDbvF
	/a9HGS0u75rDZnG7cQWbxeluVouLK74wObB73Lm2h81j3slAj74tqxg9Pm+SC2CJamC0yUhN
	TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHar6RQlphTChQK
	SCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWHDgBGtBv3DFxGWXGBsYf/N1MXJySAiY
	SMw6eYgJwhaTuHBvPVsXIxeHkMB0Rok3f7YyQzivGSXam9+zgVTxCmhJ3JvYwQhiswioSnz9
	dJIFxGYDiu9/cQOsRlQgTGLl9CssEPWCEj8m3wOyOThEBFQkzr0xBwkzC8xjlLj0gBnEFhbw
	kNj+9zrU4iWMEmcOdrKDJDgFdCX2Hb/MAtGgLjFp3iJmCFteYvOat8wTGAVmIVkxC0nZLCRl
	CxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Ez6R2MqxosDjEKcDAq8fA+kJ0fLMSa
	WFZcmXuIUYKDWUmEl8scKMSbklhZlVqUH19UmpNafIgxGRgCE5mlRJPzgSkmryTe0NjEzMjS
	yNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYkwMvTvvHsO/7RVfR1vJNbrUM
	Pid3NCztNQxakjhDKkvokHDrh0dPF03b4tB7a1P/P26LssyTCwqXb4qf7mSy0qVS/ovAOcWZ
	+x9+meFxNWPKL8VvVqrrmPyPfOyUCVU3/ikv9Pi2K+sHqZ4W4wbfs7wrbG68YcptED+68Wmc
	y0R/7WaJpeKrlViKMxINtZiLihMBfBog6ScDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 06/16/2014 10:03 PM, Lee Jones wrote:
> On Mon, 16 Jun 2014, Chanwoo Choi wrote:
> 
>> Add support for Samsung S2MPU02 PMIC device to the MFD sec-core driver.
>> The S2MPU02 device includes PMIC/RTC/Clock devices.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>  drivers/mfd/sec-core.c           | 19 +++++++++
>>  drivers/mfd/sec-irq.c            | 88 ++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/samsung/core.h |  1 +
>>  include/linux/mfd/samsung/irq.h  | 24 +++++++++++
>>  4 files changed, 132 insertions(+)
>>
>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
>> index be06d0a..5e8784b 100644
>> --- a/drivers/mfd/sec-core.c
>> +++ b/drivers/mfd/sec-core.c
>> @@ -89,6 +89,17 @@ static const struct mfd_cell s2mpa01_devs[] = {
>>  	},
>>  };
>>  
>> +static const struct mfd_cell s2mpu02_devs[] = {
>> +	{
>> +		.name = "s2mpu02-pmic",
>> +	}, {
>> +		.name = "s2mpu02-rtc",
> 
> Make these two one liners, so:
> 
>   { .name = "s2mpu02-pmic" },
>   { .name = "s2mpu02-rtc" ),

OK, I'll modify it.

> 
>> +	}, {
>> +		.name = "s2mpu02-clk",
>> +		.of_compatible = "samsung,s2mpu02-clk",
>> +	}
>> +};
>> +
>>  #ifdef CONFIG_OF
>>  static const struct of_device_id sec_dt_match[] = {
>>  	{	.compatible = "samsung,s5m8767-pmic",
>> @@ -103,6 +114,9 @@ static const struct of_device_id sec_dt_match[] = {
>>  		.compatible = "samsung,s2mpa01-pmic",
>>  		.data = (void *)S2MPA01,
>>  	}, {
>> +		.compatible = "samsung,s2mpu02-pmic",
>> +		.data = (void *)S2MPU02,
>> +	}, {
>>  		/* Sentinel */
>>  	},
>>  };
>> @@ -342,6 +356,11 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>>  		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps14_devs,
>>  				      ARRAY_SIZE(s2mps14_devs), NULL, 0, NULL);
>>  		break;
>> +	case S2MPU02:
>> +		ret = mfd_add_devices(sec_pmic->dev, -1, s2mpu02_devs,
>> +				      ARRAY_SIZE(s2mpu02_devs), NULL, 0, NULL);
>> +		break;
> 
> This is a bit bonkers.  Instead of passing S2MPU02, why don't you pass
> a new container which holds s2mpu02_devs and s2mpu02_irq_chip, then
> you won't need new mfd_add_devices() and regmap_add_irq_chip() calls
> for every device you want to support.

OK, I'll remove duplicate code of mfd_add_devices() and regmap_add_irq_chip().

Best Regards,
Chanwoo Choi






