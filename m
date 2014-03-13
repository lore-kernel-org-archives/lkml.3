Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaCMEUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:20:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35629 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaCMEUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 00:20:13 -0400
Date: Thu, 13 Mar 2014 13:20:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 3/4] devfreq: exynos4: Add ppmu's clock control and code
 clean about regulator control
In-reply-to: <532114C0.3020800@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Message-id: <532131F4.8080502@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-AuditID: cbfee68f-b7f156d00000276c-c7-532131f4c1cc
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkSPeLoWKwwY+F6hYbZ6xntTjb9Ibd
	ovtHtsXlXXPYLD73HmG0uN24gs3izY+zTBaPV7xld+DwWLznJZNH35ZVjB7Hb2xn8vi8SS6A
	JYrLJiU1J7MstUjfLoEr49eUOewFM3Uq3rxax9rAeEC5i5GTQ0LARGLSrFZWCFtM4sK99Wxd
	jFwcQgJLGSWerXvPBFP06PB9ZojEIkaJ1Zs/MUI4rxglrnXeYAGp4hXQkrjaug1sFIuAqsS8
	j6eYQWw2oPj+FzfYQGxRgTCJldOvQNULSvyYfA/MFhGwkFi74i0LyFBmgT2MElP7foENEhbI
	kXj9fz4rxLZ9jBKXfr4Fu4lTQFti0cTbYFOZBXQk9rdOg7LlJTaveQt2q4TAOXaJ7p1bmSFO
	EpD4NvkQ0AoOoISsxKYDzBC/SUocXHGDZQKj2CwkR81CMnYWkrELGJlXMYqmFiQXFCelFxnr
	FSfmFpfmpesl5+duYgTG3ul/z/p3MN49YH2IMRlo5URmKdHkfGDs5pXEGxqbGVmYmpgaG5lb
	mpEmrCTOe/9hUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRr4Z1xM/pFn3ufreO7M61GvC
	Za1+R87WFHf+X4HHpytfd33KYcq5SDP59Z/kzATZOffK5UukH9oK/P5jv/3ExQ6Djy/PzWDr
	XPLr6apHlxbm8PdGGaTc2cPp5lFs5ZBlZPTz0jqW8/NdT19dUuDMr5Yq6/KIQXzltoiQzw1O
	i269aJ11mP2NoxJLcUaioRZzUXEiAHuFseLTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd0vhorBBvdmyFtsnLGe1eJs0xt2
	i+4f2RaXd81hs/jce4TR4nbjCjaLNz/OMlk8XvGW3YHDY/Gel0wefVtWMXocv7GdyePzJrkA
	lqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBm/psxhL5ipU/Hm1TrWBsYD
	yl2MnBwSAiYSjw7fZ4awxSQu3FvP1sXIxSEksIhRYvXmT4wQzitGiWudN1hAqngFtCSutm5j
	BbFZBFQl5n08BdbNBhTf/+IGG4gtKhAmsXL6Fah6QYkfk++B2SICFhJrV7xlARnKLLCHUWJq
	3y+wQcICORKv/89nhdi2j1Hi0s+3TCAJTgFtiUUTb4NNZRbQkdjfOg3KlpfYvOYt8wRGgVlI
	lsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGR/UxqB+PKBotDjAIcjEo8
	vCuWKwQLsSaWFVfmHmKU4GBWEuE9oKkYLMSbklhZlVqUH19UmpNafIgxGRgGE5mlRJPzgUkn
	ryTe0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYbT8sqv6l4e5w
	7wXnkqgvwoZa67q6ym5mMYSL2nG3NFncsdUQFvle76166MiEK+WSAfNl7u+OuVXwzWX2wQSH
	sukSWWbTEhUr/QtP2/6yXM1t58Nwj3ttUk9IjNFGttiwIs4FAReOvhHbNXefVovyuaWnah9L
	7FdrX7/Gw+/bF4tr8+W6m3SUWIozEg21mIuKEwFiRO8kMAMAAA==
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
 <1394624882-2989-4-git-send-email-cw00.choi@samsung.com>
 <1783132.ayF9Dpflf1@amdc1032> <532114C0.3020800@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On 03/13/2014 11:15 AM, Chanwoo Choi wrote:
> Hi Batlomiej,
> 
> On 03/13/2014 12:17 AM, Bartlomiej Zolnierkiewicz wrote:
>>
>> Hi,
>>
>> On Wednesday, March 12, 2014 08:48:01 PM Chanwoo Choi wrote:
>>> There are not the clock controller of ppmudmc0/1. This patch control the clock
>>> of ppmudmc0/1 which is used for monitoring memory bus utilization.
>>>
>>> Also, this patch code clean about regulator control and free resource
>>> when calling exit/remove function.
>>>
>>> For example,
>>> busfreq@106A0000 {
>>> 	compatible = "samsung,exynos4x12-busfreq";
>>>
>>> 	/* Clock for PPMUDMC0/1 */
>>> 	clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
>>> 	clock-names = "ppmudmc0", "ppmudmc1";
>>>
>>> 	/* Regulator for MIF/INT block */
>>> 	vdd_mif-supply = <&buck1_reg>;
>>> 	vdd_int-supply = <&buck3_reg>;
>>> };
>>
>> This should be in Documentation/devicetree/bindings/ documentation.
> 
> OK, I will add documentation about it.
> 
>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> ---
>>>  drivers/devfreq/exynos/exynos4_bus.c | 107 ++++++++++++++++++++++++++++++-----
>>>  1 file changed, 93 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
>>> index 16fb3cb..0c5b99e 100644
>>> --- a/drivers/devfreq/exynos/exynos4_bus.c
>>> +++ b/drivers/devfreq/exynos/exynos4_bus.c
>>> @@ -62,6 +62,11 @@ enum exynos_ppmu_idx {
>>>  	PPMU_END,
>>>  };
>>>  
>>> +static const char *exynos_ppmu_clk_name[] = {
>>> +	[PPMU_DMC0]	= "ppmudmc0",
>>> +	[PPMU_DMC1]	= "ppmudmc1",
>>> +};
>>> +
>>>  #define EX4210_LV_MAX	LV_2
>>>  #define EX4x12_LV_MAX	LV_4
>>>  #define EX4210_LV_NUM	(LV_2 + 1)
>>> @@ -86,6 +91,7 @@ struct busfreq_data {
>>>  	struct regulator *vdd_mif; /* Exynos4412/4212 only */
>>>  	struct busfreq_opp_info curr_oppinfo;
>>>  	struct exynos_ppmu ppmu[PPMU_END];
>>> +	struct clk *clk_ppmu[PPMU_END];
>>>  
>>>  	struct notifier_block pm_notifier;
>>>  	struct mutex lock;
>>> @@ -722,8 +728,26 @@ static int exynos4_bus_get_dev_status(struct device *dev,
>>>  static void exynos4_bus_exit(struct device *dev)
>>>  {
>>>  	struct busfreq_data *data = dev_get_drvdata(dev);
>>> +	int i;
>>>  
>>> -	devfreq_unregister_opp_notifier(dev, data->devfreq);
>>> +	/*
>>> +	 * Un-map memory man and disable regulator/clocks
>>> +	 * to prevent power leakage.
>>> +	 */
>>> +	regulator_disable(data->vdd_int);
>>> +	if (data->type == TYPE_BUSF_EXYNOS4x12)
>>> +		regulator_disable(data->vdd_mif);
>>> +
>>> +	for (i = 0; i < PPMU_END; i++) {
>>> +		if (data->clk_ppmu[i])
>>> +			clk_disable_unprepare(data->clk_ppmu[i]);
>>> +	}
>>> +
>>> +	for (i = 0; i < PPMU_END; i++) {
>>> +		if (data->ppmu[i].hw_base)
>>> +			iounmap(data->ppmu[i].hw_base);
>>> +
>>> +	}
>>>  }
>>>  
>>>  static struct devfreq_dev_profile exynos4_devfreq_profile = {
>>> @@ -987,6 +1011,7 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
>>>  {
>>>  	struct device *dev = data->dev;
>>>  	struct device_node *np = dev->of_node;
>>> +	const char **clk_name = exynos_ppmu_clk_name;
>>>  	int i, ret;
>>>  
>>>  	if (!np) {
>>> @@ -1005,8 +1030,67 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
>>>  		}
>>>  	}
>>>  
>>> +	/*
>>> +	 * Get PPMU's clocks to control them. But, if PPMU's clocks
>>> +	 * is default 'pass' state, this driver don't need control
>>> +	 * PPMU's clock.
>>> +	 */
>>> +	for (i = 0; i < PPMU_END; i++) {
>>> +		data->clk_ppmu[i] = devm_clk_get(dev, clk_name[i]);
>>> +		if (IS_ERR_OR_NULL(data->clk_ppmu[i])) {
>>> +			dev_warn(dev, "Cannot get %s clock\n", clk_name[i]);
>>> +			data->clk_ppmu[i] = NULL;
>>> +		}
>>> +
>>> +		ret = clk_prepare_enable(data->clk_ppmu[i]);
>>> +		if (ret < 0) {
>>> +			dev_warn(dev, "Cannot enable %s clock\n", clk_name[i]);
>>> +			data->clk_ppmu[i] = NULL;
>>> +			goto err_clocks;
>>> +		}
>>> +	}
>>> +
>>> +
>>> +	/* Get regulators to control voltage of int/mif block */
>>> +	data->vdd_int = devm_regulator_get(dev, "vdd_int");
>>> +	if (IS_ERR(data->vdd_int)) {
>>> +		dev_err(dev, "Failed to get the regulator of vdd_int\n");
>>> +		ret = PTR_ERR(data->vdd_int);
>>> +		goto err_clocks;
>>> +	}
>>> +	ret = regulator_enable(data->vdd_int);
>>> +	if (ret < 0) {
>>> +		dev_err(dev, "Failed to enable regulator of vdd_int\n");
>>> +		goto err_clocks;
>>> +	}
>>> +
>>> +	switch (data->type) {
>>> +	case TYPE_BUSF_EXYNOS4x12:
>>> +		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
>>> +		if (IS_ERR(data->vdd_mif)) {
>>> +			dev_err(dev, "Failed to get the regulator vdd_mif\n");
>>> +			ret = PTR_ERR(data->vdd_mif);
>>> +			goto err_clocks;
>>
>> This won't disable vdd_int regulator.
> 
> I don't understand. This patch contro/enable always vdd_int regualor as following:
> 	>> +	data->vdd_int = devm_regulator_get(dev, "vdd_int");
> 	>> +	ret = regulator_enable(data->vdd_int);
> You can check this code on this patch. upper
> 
>>
>>> +		}
>>> +		ret = regulator_enable(data->vdd_mif);
>>> +		if (ret < 0) {
>>> +			dev_err(dev, "Failed to enable regulator of vdd_mif\n");
>>> +			goto err_clocks;
>>
>> ditto
> 
>>
>>> +		}
>>> +		break;
>>> +	case TYPE_BUSF_EXYNOS4210:
>>> +	default:
>>> +		dev_err(data->dev, "Unknown device type\n");
>>> +		return -EINVAL;
>>
>> This looks very wrong for Exynos4210.
> 
> What is wrong for Exynos4210?
> Always, exynos4210/exynos4x12 control vdd_int regulator uppper this patch.

It is my mistake. I'll modify it.

Best Regards,
Chanwoo Choi
