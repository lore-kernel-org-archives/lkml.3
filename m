Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3JJLqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:46:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14295 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3JJLqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:46:07 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-ba-5256937e9237
Message-id: <52569383.5050502@samsung.com>
Date: Thu, 10 Oct 2013 20:46:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] regulator: s5m8767: Modify parsing method of the
 voltage table of buck2/3/4
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
 <1381369296-17101-2-git-send-email-cw00.choi@samsung.com>
 <20131010103646.GH26954@e106331-lin.cambridge.arm.com>
In-reply-to: <20131010103646.GH26954@e106331-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkQLducliQQWsrt8XUh0/YLOYfOcdq
	cbbpDbvFtysdTBaXd81hs1h6/SKTxcUVX5gs9u6czOjA4bFm3hpGj52z7rJ7bFrVyebRt2UV
	o8fnTXIBrFFcNimpOZllqUX6dglcGStXf2AvOCxfsefmDtYGxplSXYycHBICJhLrJ91ng7DF
	JC7cWw9mCwksZZSY3qcKUzPxzW/WLkYuoPgiRon5jYugnFeMEi+eHgHr4BXQkph7t4cJxGYR
	UJVYcHsDWJwNKL7/xQ0wW1QgTGLl9CssEPWCEj8m3wOzRQTUJXp2fWEBGcoscJtJ4tS3GWCD
	hAXSJNavusEEsW0Xo8SRU2tZQRKcAs4Sq6fuZQaxmQV0JPa3TmODsOUlNq95ywzSICFwjV3i
	W+8dFoiTBCS+TT4EZHMAJWQlNh1ghvhNUuLgihssExjFZiE5ahaSsbOQjF3AyLyKUTS1ILmg
	OCm9yFCvODG3uDQvXS85P3cTIzAKT/971ruD8fYB60OMyUArJzJLiSbnA6M4ryTe0NjMyMLU
	xNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M6rZrxT/cvqxtfEjv
	vnZ+QfvCjW8q9TUOuN1SuejVY1m+vDIp4vLe6oLFP92aCzbL99deKG2umXHl5vuuxYV5exc9
	Dfk/IcFTQ/Z74oSCy48WWsS/vafxrclG/MaZ5k7J5zXuVTMuvcj9P41f2oxfZ/qlp4Kfry7p
	etzz57yZUMhyzTClNcU6SizFGYmGWsxFxYkAhPQwYdgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd26yWFBBrdXMVlMffiEzWL+kXOs
	Fmeb3rBbfLvSwWRxedccNoul1y8yWVxc8YXJYu/OyYwOHB5r5q1h9Ng56y67x6ZVnWwefVtW
	MXp83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj5eoP7AWH5Sv2
	3NzB2sA4U6qLkZNDQsBEYuKb36wQtpjEhXvr2boYuTiEBBYxSsxvXMQK4bxilHjx9AgbSBWv
	gJbE3Ls9TCA2i4CqxILbG8DibEDx/S9ugNmiAmESK6dfYYGoF5T4MfkemC0ioC7Rs+sLC8hQ
	ZoHbTBKnvs0AGyQskCaxftUNJohtuxgljpxaC3YTp4CzxOqpe5lBbGYBHYn9rdPYIGx5ic1r
	3jJPYBSYhWTJLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHOXPpHcwrmqw
	OMQowMGoxMNbURYaJMSaWFZcmXuIUYKDWUmEd055WJAQb0piZVVqUX58UWlOavEhxmRgGExk
	lhJNzgcmoLySeENjEzMjSyNzQwsjY3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYJyY
	FrDRPqXa9s2EMuvi01saVKT0RCy3z0177xbwXcP1zeJMzkyH8n7efB7Ou3MlX8Svywm9bhF2
	7+apiznem4w3+KW/rY+7V2nqKPFsftfNgiVvWVJ6Cng/Lvmx9ubvOLu5bZZ1u27FKou/jOXi
	m7npbb67Unle5fSYV+en9Mba/ty+ycU5X4mlOCPRUIu5qDgRAMyrMgU2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 07:36 PM, Mark Rutland wrote:
> On Thu, Oct 10, 2013 at 02:41:36AM +0100, Chanwoo Choi wrote:
>> The s5m8767 regulator driver parse always the voltage table of buck2/3/4.
>> If gpio_dvs feature isn't used and dts haven't included the voltage table
>> of buck2/3/4, s5m8767 regulator driver return error and file probe state.
>>
>> This patch check only voltage table of buck on s5m8767_pmic_dt_parse_pdata()
>> if buck[2-4]_gpiodvs is true.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/regulator/s5m8767.c | 54 +++++++++++++++++++++++----------------------
>>  1 file changed, 28 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
>> index cb6cdb3..29999c0 100644
>> --- a/drivers/regulator/s5m8767.c
>> +++ b/drivers/regulator/s5m8767.c
>> @@ -522,7 +522,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
>>  	struct device_node *pmic_np, *regulators_np, *reg_np;
>>  	struct sec_regulator_data *rdata;
>>  	struct sec_opmode_data *rmode;
>> -	unsigned int i, dvs_voltage_nr = 1, ret;
>> +	unsigned int i, dvs_voltage_nr = 8, ret;
>>  
>>  	pmic_np = iodev->dev->of_node;
>>  	if (!pmic_np) {
>> @@ -586,15 +586,39 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
>>  		rmode++;
>>  	}
>>  
>> -	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL))
>> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL)) {
>>  		pdata->buck2_gpiodvs = true;
> 
> As this line is being changed, please switch to of_property_read_bool.

OK.

> 
>>  
>> -	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-uses-gpio-dvs", NULL))
>> +		if (of_property_read_u32_array(pmic_np,
>> +				"s5m8767,pmic-buck2-dvs-voltage",
>> +				pdata->buck2_voltage, dvs_voltage_nr)) {
> 
> Won't this break existing (not conforming to the binding) dts?
> 
> $(git grep s5m8767,pmic-buck2-dvs-voltage) shows me
> arch/arm/boot/dts/exynos5250-arndale.dts is only has one entry in its
> s5m8767,pmic-buck3-uses-gpio-dvs property's list.

I checked it but exynos5250-arndale.dts haven't included pmic-buck3-uses-gpio-dvs property.
What is reference code?

> 
>> +			dev_err(iodev->dev, "buck2 voltages not specified\n");
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-uses-gpio-dvs", NULL)) {
>>  		pdata->buck3_gpiodvs = true;
> 
> Another of_proeprty_read_bool candidate.

OK.

> 
>>  
>> -	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-uses-gpio-dvs", NULL))
>> +		if (of_property_read_u32_array(pmic_np,
>> +				"s5m8767,pmic-buck3-dvs-voltage",
>> +				pdata->buck3_voltage, dvs_voltage_nr)) {
>> +			dev_err(iodev->dev, "buck3 voltages not specified\n");
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-uses-gpio-dvs", NULL)) {
>>  		pdata->buck4_gpiodvs = true;
> 
> Similarly.
> 
> In general I'm confused by the need for the *-uses-gpio-dvs properties.
> Are they not implied by the presence of *-dvs-voltage properties?
> 

The s5m8767 support the power control using DVS(Dynamic Voltage scaling) by using
GPIO or I2C interface between PMIC and AP. 

When controlling DVS by using GPIO interface, *-uses-gpio-dvs/*-dvs-voltage properties is used.
The s5m8767 pmic control DVS of one only buck using GPIO. If specific target use GPIO interface
to control buck2 DVS, must set buck2-uses-gpio-dvs as true and buck3/4-uses-gpio-dvs is false.
Also, GPIO interface include three gpio pin which select total 8 step voltage according to
three gpio state. *-dvs-voltage properties include the voltage table of 8 step.

Also, you can check the aim of *-uses-gpio-dvs/*-dvs-voltage properties
on Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt.




