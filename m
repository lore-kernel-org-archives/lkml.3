Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaIQEPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:15:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62483 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaIQEPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:15:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ce6d00000115a-83-54190ad4daa0
Content-transfer-encoding: 8BIT
Message-id: <54190AD3.7020006@samsung.com>
Date: Wed, 17 Sep 2014 13:15:15 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, jdelvare@suse.de
Subject: Re: [PATCH RESEND v2] hwmon: ntc_thermistor: Add ntc thermistor to
 thermal subsystem as a sensor.
References: <1410921693-3291-1-git-send-email-jonghwa3.lee@samsung.com>
 <54190983.9030906@roeck-us.net>
In-reply-to: <54190983.9030906@roeck-us.net>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSoHuFSzLEYNJiLouldz+xWVzeNYfN
	4snCM0wWd6btZXNg8XgwcTebx87vDewem09Xe3zeJBfAEsVlk5Kak1mWWqRvl8CVca5nDnvB
	PcWKQ7vWMzcwrpfqYuTkkBAwkbjR28YKYYtJXLi3nq2LkYtDSGApo8T5L3tZYIr2XDnODJGY
	ziix+NBLsASvgKDEj8n3gGwODmYBeYkjl7JBwswC6hKT5i1iBrGFBF4zSlzakw9RriWx69QP
	RhCbRUBVYlHrIbDFbAJyEm+bvoHFRQXCJK5OOA42XkRATaL5VAsbxExfiYf3j4PZwgI5EpM3
	LmGBmJ8p8e76K3aQEzgFdCQe/ouGOHkdu8Tlu+UQqwQkvk0+BHalhICsxKYDzBAlkhIHV9xg
	mcAoNgvJL7MQfpmF5JcFjMyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MQKj6PS/ZxN2MN47
	YH2IUYCDUYmHd8NliRAh1sSy4srcQ4ymQEdMZJYSTc4HxmpeSbyhsZmRhamJqbGRuaWZkjjv
	a6mfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYTaNaN4ZrPnp5vHdWk/3ekFuXqjeb2l5I
	3/vS+6DYm5/aUip3u+au+HNBPEj13sslJ1qeLGb5unbK3DPbQ57qLvmgl8yqvCFcPlYv9sDZ
	57Z2q5slldvPJ67YyNd3OuLa9qmtvF0i7H84WeYdbzFMmrxK+oyAt7JKlYnsDs2zHkvTPp63
	z5r9S4mlOCPRUIu5qDgRAOrTG3idAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQd0rXJIhBueamS2W3v3EZnF51xw2
	iycLzzBZ3Jm2l82BxePBxN1sHju/N7B7bD5d7fF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGENY8a5njnsBfcUKw7tWs/cwLheqouRk0NCwERiz5XjzBC2mMSFe+vZ
	uhi5OIQEpjNKLD70kgUkwSsgKPFj8j0gm4ODWUBe4silbJAws4C6xKR5i8B6hQReM0pc2pMP
	Ua4lsevUD0YQm0VAVWJR6yFWEJtNQE7ibdM3sLioQJjE1QnHwcaLCKhJNJ9qYYOY6Svx8P5x
	MFtYIEdi8sYlLBDzMyXeXX/FDnICp4COxMN/0RMYBWYhOW4WwnGzkBy3gJF5FaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZwlD6T3sG4qsHiEKMAB6MSD++GyxIhQqyJZcWVuYcYJTiYlUR4
	Re4BhXhTEiurUovy44tKc1KLDzGaAv02kVlKNDkfmEDySuINjU3MjCyNzA0tjIzNlcR5D7Za
	BwoJpCeWpGanphakFsH0MXFwSjUwtrEt+bSzeqLwnsRZWscFZi4/M1X9zan33k2Wlo93C22Q
	aEh8WbluiUyIypGNV+bWSauVeF3zeb69s2qvx+ZKyVWr4+d6fi+y0l6kLHJFZeV13jb1SYJC
	Z8QFt9Xkfvm3j0msa9ebo6tvucW7qOy9aVwXHC/n0LuE+2gN47ela7L5dV/YKvlHKLEUZyQa
	ajEXFScCAJJE8nnoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 09월 17일 13:09, Guenter Roeck wrote:

> On 09/16/2014 07:41 PM, Jonghwa Lee wrote:
>> To get more comprehensive and integrated thermal management, it adds ntc
>> thermistor to thermal framework as a thermal sensor. It's governed thermal
>> susbsystem only if it is described in DT node. Otherwise, it just notifies
>> temperature to userspace via sysfs as it used to be.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
> 
> As has been pointed out, with
> 
> CONFIG_OF=y
> CONFIG_THERMAL=m
> CONFIG_SENSORS_NTC_THERMISTOR=y
> 
> this patch results in
> 
> drivers/built-in.o: In function `ntc_thermistor_probe':
> ntc_thermistor.c:(.text+0xfff52): undefined reference to
> `thermal_zone_of_sensor_register'
> drivers/built-in.o: In function `ntc_thermistor_remove':
> ntc_thermistor.c:(.text+0xfffc5): undefined reference to
> `thermal_zone_of_sensor_unregister'
> make: *** [vmlinux] Error 1
> 
> Resending the patch without changes does not fix the problem.
> Please submit a fixed version.
> 


Sorry, I think I lost the thread, I didn't notice you commented before.
Anyway I'll fix it resend it.

Thanks,
Jonghwa

> Thanks,
> Guenter
> 
> 
>> Updates in v2
>>   - Remove NULL pointer checking already done by
>> thermal_zone_of_sensor_unregister().
>>
>>   .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
>>   drivers/hwmon/ntc_thermistor.c                     |   25 ++++++++++++++++++++
>>   2 files changed, 28 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> index 2391e5c..fcca8e7 100644
>> --- a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> +++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> @@ -25,6 +25,9 @@ Requires node properties:
>>   - "io-channels"    Channel node of ADC to be used for
>>           conversion.
>>
>> +Optional node properties:
>> +- "#thermal-sensor-cells" Used to expose itself to thermal fw.
>> +
>>   Read more about iio bindings at
>>       Documentation/devicetree/bindings/iio/iio-bindings.txt
>>
>> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
>> index bd41072..4ff89b2 100644
>> --- a/drivers/hwmon/ntc_thermistor.c
>> +++ b/drivers/hwmon/ntc_thermistor.c
>> @@ -38,6 +38,7 @@
>>
>>   #include <linux/hwmon.h>
>>   #include <linux/hwmon-sysfs.h>
>> +#include <linux/thermal.h>
>>
>>   struct ntc_compensation {
>>       int        temp_c;
>> @@ -182,6 +183,7 @@ struct ntc_data {
>>       struct device *dev;
>>       int n_comp;
>>       char name[PLATFORM_NAME_SIZE];
>> +    struct thermal_zone_device *tz;
>>   };
>>
>>   #if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
>> @@ -428,6 +430,20 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>>       return -EINVAL;
>>   }
>>
>> +static int ntc_read_temp(void *dev, long *temp)
>> +{
>> +    struct ntc_data *data = dev_get_drvdata(dev);
>> +    int ohm;
>> +
>> +    ohm = ntc_thermistor_get_ohm(data);
>> +    if (ohm < 0)
>> +        return ohm;
>> +
>> +    *temp = get_temp_mc(data, ohm);
>> +
>> +    return 0;
>> +}
>> +
>>   static ssize_t ntc_show_name(struct device *dev,
>>           struct device_attribute *attr, char *buf)
>>   {
>> @@ -562,6 +578,13 @@ static int ntc_thermistor_probe(struct platform_device
>> *pdev)
>>       dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
>>                                   pdev_id->name);
>>
>> +    data->tz = thermal_zone_of_sensor_register(data->dev, 0, data->dev,
>> +                        ntc_read_temp, NULL);
>> +    if (IS_ERR(data->tz)) {
>> +        dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
>> +        data->tz = NULL;
>> +    }
>> +
>>       return 0;
>>   err_after_sysfs:
>>       sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>> @@ -578,6 +601,8 @@ static int ntc_thermistor_remove(struct platform_device
>> *pdev)
>>       sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>>       ntc_iio_channel_release(pdata);
>>
>> +    thermal_zone_of_sensor_unregister(data->dev, data->tz);
>> +
>>       return 0;
>>   }
>>
>>
> 
> 


