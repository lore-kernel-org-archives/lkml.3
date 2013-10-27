Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3J0XlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 19:41:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24602 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3J0XlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 19:41:14 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-09-526da4978f44
Message-id: <526DA498.6000606@samsung.com>
Date: Mon, 28 Oct 2013 08:41:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 2/4] charger-manager: Use IIO subsystem to read battery
 temperature instead of legacy method
References: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
 <1382446317-32613-3-git-send-email-cw00.choi@samsung.com>
 <526BA578.3080306@metafoo.de>
In-reply-to: <526BA578.3080306@metafoo.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWyRsSkRHfGktwgg7lH2CwObtW0mH/kHKvF
	xJWTmS0O/NnBaHG26Q27xZLJ81kt5h15x2JxedccNovbjSvYLA6vOMDkwOWx4PMVdo8J/Z8Y
	PTav0PK4c20Pm8eSN4dYPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvjzYEXrAWf7Sp27rzI
	3sC42aiLkZNDQsBEovvWPVYIW0ziwr31bF2MXBxCAksZJXrvL2SGKfqy6hkLRGI6o8S9KevY
	IZxXjBJtq06ygFTxCmhJXN7cCTaKRUBVYuWVFWDdbEDx/S9usIHYogJhEiunX4GqF5T4Mfke
	mC0ioCHx/80ksKHMAp1MEkuaNrGDJIQFiiSWPPkIZgsJLGSUOHc1oYuRg4MTaOi9wyUgYWYB
	HYn9rdPYIGx5ic1r3kJd/ZVd4spFKYh7BCS+TT7EAtIqISArsekAVImkxMEVN1gmMIrNQnLR
	LCRTZyGZuoCReRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYJSe/vesbwfjzQPWhxiTgVZO
	ZJYSTc4HRnleSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamCU+GU0bW2pqLb4GS8d0wMRCyZlM2lvnrTT/1PjgZUblqb5HHPd+ddtXvs5Huai2xaq
	cRH+PUvU8w7ordvxKNlK2ySaT+aSlY78p3xlt061n+97HkXI2EbuesnW2Vd5idt/Us2MH1l3
	eZa/PLi/UcD2lGCVl2gkr0rhdPe2+0t+3SrQ+LJ4RYQSS3FGoqEWc1FxIgC++y446AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3pS3KDDFr6LC0ObtW0mH/kHKvF
	xJWTmS0O/NnBaHG26Q27xZLJ81kt5h15x2JxedccNovbjSvYLA6vOMDkwOWx4PMVdo8J/Z8Y
	PTav0PK4c20Pm8eSN4dYPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxpsDL1gLPttV7Nx5kb2BcbNRFyMnh4SAicSXVc9YIGwxiQv31rN1MXJxCAlM
	Z5S4N2UdO4TzilGibdVJsCpeAS2Jy5s7WUFsFgFViZVXVjCD2GxA8f0vbrCB2KICYRIrp1+B
	qheU+DH5HpgtIqAh8f/NJLChzAKdTBJLmjaxgySEBYokljz5CGYLCSxklDh3NaGLkYODE2jo
	vcMlIGFmAR2J/a3T2CBseYnNa94yT2AUmIVkxSwkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJEZwEnknvYFzVYHGIUYCDUYmHVyM0J0iINbGsuDL3EKMEB7OSCC9fRW6QEG9K
	YmVValF+fFFpTmrxIcZkYAhMZJYSTc4HJqi8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmk
	J5akZqemFqQWwWxh4uCUamAs7dfeoNDemp9X9vpGqkTR8c1z/0ruuvl/V+HWzH+F0sa33SYW
	iwaeCDxoYh2v9U5iouWRGvarJ8IF9uz3V/3w+I7SPpXncyaF+j3+IBsunR+f8PXPjoaAk18N
	Uv+mfp4pbF5x//gulv3p6/0j5+oa3W+c07d8tkqyo4PupPUbqip9Dm8XUI5TYinOSDTUYi4q
	TgQAdTxO+EYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2013 08:20 PM, Lars-Peter Clausen wrote:
> On 10/22/2013 02:51 PM, Chanwoo Choi wrote:
>> This patch support charger-manager use IIO(Industrial I/O) subsystem to read
>> current battery temperature instead of legacy methor about callback function.
> 
> How does this look in hardware? Do you have a general purpose ADC connected
> to a temperature sensor that has a temperature dependent voltage output? And
> at some point during the board design you measure the raw value of the ADC
> both for the lower and the upper threshold temperatures?

As you comment, I have to convert ADC value with h/w constraint(voltage ouput, resistance).
Previously, I used exynos-adc driver(drivers/iio/adc/exynos_adc.c) to get ADC value
about temperature and then use ntc_thermistor(drivers/hwmon/ntc_thermistor.c)
for converting temperature. But, I didn't find same driver of ntc_thermistor
in drivers/iio for converting. So, this patchset only connected with iio drvier
to get ADC value. In next, I'm cosidering how to get the correct temperature from iio driver.

If you possible, could you give me advices about this issue?

Also, I will support POWER_SUPPLY_PROP_TEMP* property of power_supply class
to get temperature from fuel-gauge or charger device.


> 
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> ---
>>  drivers/power/Kconfig                 |  1 +
>>  drivers/power/charger-manager.c       | 88 +++++++++++++++++++++++++++++++++--
>>  include/linux/power/charger-manager.h | 13 ++++++
>>  3 files changed, 97 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index e6f92b4..6700191 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -309,6 +309,7 @@ config CHARGER_MANAGER
>>  	bool "Battery charger manager for multiple chargers"
>>  	depends on REGULATOR && RTC_CLASS
>>  	select EXTCON
>> +	select IIO
> 
> Are you sure you want to force select the IIO framework? It looks like we do
> not stub out iio_channel_get() and friends yet if CONFIG_IIO is not
> selected. But I think that will the better solution here.
> 
>>  	help
>>            Say Y to enable charger-manager support, which allows multiple
>>            chargers attached to a battery and multiple batteries attached to a
>> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
>> index cc720f9..02a395c 100644
>> --- a/drivers/power/charger-manager.c
>> +++ b/drivers/power/charger-manager.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/sysfs.h>
>>  #include <linux/of.h>
>> +#include <linux/iio/consumer.h>
>>  
>>  static const char * const default_event_names[] = {
>>  	[CM_EVENT_UNKNOWN] = "Unknown",
>> @@ -542,6 +543,50 @@ static int check_charging_duration(struct charger_manager *cm)
>>  }
>>  
>>  /**
>> + * read_battery_temperature - Read current battery temperature
>> + * @cm: the Charger Manager representing the battery.
>> + * @last_temp_mC: store current battery temperature
>> + *
>> + * Returns current state of temperature by using IIO or legacy method
>> + * - CM_TEMP_NORMAL
>> + * - CM_TEMP_OVERHEAT
>> + * - CM_TEMP_COLD
>> + */
>> +static int read_battery_temperature(struct charger_manager *cm,
>> +				    int *last_temp_mC)
>> +{
>> +	struct charger_desc *desc = cm->desc;
>> +	int temp;
>> +
>> +	if (desc->channel) {
>> +		temp = iio_read_channel_raw(desc->channel, last_temp_mC);
>> +
>> +		/*
>> +		 * The charger-manager use IIO subsystem to read ADC raw data
>> +		 * from IIO ADC device drvier. The each device driver has
>> +		 * own non-standard ADC table. If user of charger-manager
>> +		 * would like to get correct temperature value, have to convert
>> +		 * 'last_temp_mC' variable according to proper calculation
>> +		 * method and own ADC table.
>> +		 */
>> +
>> +		if (*last_temp_mC >= desc->iio_adc_overheat)
>> +			temp = CM_TEMP_NORMAL;	/* Overheat */
> 
> temp = CM_TEMP_OVERHEAT ?

I found this problem after send patchset. I'll fix it.

> 
>> +		else if (*last_temp_mC <= desc->iio_adc_cold)
>> +			temp = CM_TEMP_COLD;	/* Cold */
>> +		else
>> +			temp = CM_TEMP_NORMAL;	/* Normal */
>> +
>> +	} else if (desc->temperature_out_of_range) {
>> +		temp = desc->temperature_out_of_range(last_temp_mC);
>> +	} else {
>> +		temp = INT_MAX;
>> +	}
>> +
>> +	return temp;
>> +}
>> +
>> +/**
>>   * _cm_monitor - Monitor the temperature and return true for exceptions.
>>   * @cm: the Charger Manager representing the battery.
>>   *
>> @@ -551,7 +596,7 @@ static int check_charging_duration(struct charger_manager *cm)
>>  static bool _cm_monitor(struct charger_manager *cm)
>>  {
>>  	struct charger_desc *desc = cm->desc;
>> -	int temp = desc->temperature_out_of_range(&cm->last_temp_mC);
>> +	int temp = read_battery_temperature(cm, &cm->last_temp_mC);
>>  
>>  	dev_dbg(cm->dev, "monitoring (%2.2d.%3.3dC)\n",
>>  		cm->last_temp_mC / 1000, cm->last_temp_mC % 1000);
>> @@ -805,7 +850,7 @@ static int charger_get_property(struct power_supply *psy,
>>  	case POWER_SUPPLY_PROP_TEMP:
>>  		/* in thenth of centigrade */
>>  		if (cm->last_temp_mC == INT_MIN)
>> -			desc->temperature_out_of_range(&cm->last_temp_mC);
>> +			read_battery_temperature(cm, &cm->last_temp_mC);
> 
> So this will now return the raw ADC value to userspace on a property that is
> supposed to indicate milli-degree Celsius. That doesn't seem to be right.

You're right. It isn't correct temperature as below my comment:
I have to fix this issue.

		/*
		 * The charger-manager use IIO subsystem to read ADC raw data
		 * from IIO ADC device drvier. The each device driver has
		 * own non-standard ADC table. If user of charger-manager
		 * would like to get correct temperature value, have to convert
		 * 'last_temp_mC' variable according to proper calculation
		 * method and own ADC table.
		 */

> 
>>  		val->intval = cm->last_temp_mC / 100;
>>  		if (!desc->meaure_battery_temp)
>>  			ret = -ENODEV;
>> @@ -813,7 +858,7 @@ static int charger_get_property(struct power_supply *psy,
>>  	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
>>  		/* in thenth of centigrade */
>>  		if (cm->last_temp_mC == INT_MIN)
>> -			desc->temperature_out_of_range(&cm->last_temp_mC);
>> +			read_battery_temperature(cm, &cm->last_temp_mC);
>>  		val->intval = cm->last_temp_mC / 100;
>>  		if (desc->measure_battery_temp)
>>  			ret = -ENODEV;
>> @@ -1586,6 +1631,32 @@ static int charger_manager_dt_parse_regulator(struct device *dev,
>>  	return 0;
>>  }
>>  
>> +static int charger_manager_dt_parse_iio(struct device *dev,
>> +					      struct charger_desc *desc)
>> +{
>> +	struct device_node *np = dev->of_node;
>> +
>> +	if (of_property_read_u32(np, "iio-adc-overheat",
>> +				&desc->iio_adc_overheat)) {
>> +		dev_warn(dev, "cannot get standard value for hot temperature\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (of_property_read_u32(np, "iio-adc-cold",
>> +				&desc->iio_adc_cold)) {
>> +		dev_warn(dev, "cannot get standard value for cold temperature\n");
>> +		return -EINVAL;
>> +	}
> 
> iio-adc-overheat and iio-adc-cold are definitely not good names for
> devicetree properties. The term IIO is really Linux specific and should not
> appear in the devicetree. 'temperature-lower-threshold' and
> 'temperature-upper-threshold' might be better names.

OK. I'll fix it in accordance with your comment.

> 
>> +
>> +	desc->channel = iio_channel_get(dev, NULL);
> 
> You need to free the channel on the error paths in your probe function.

OK. I'll fix it.
> 
>> +	if (IS_ERR(desc->channel)) {
>> +		dev_err(dev, "cannot get iio channel\n");
>> +		return PTR_ERR(desc->channel);
>> +	}
>> +
>> +	return 0;
>> +}
> 

Thanks for your comment.

Best Regards,
Chanwoo Choi

