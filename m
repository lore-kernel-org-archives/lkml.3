Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaIRB7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:59:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47626 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763AbaIRB7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:59:05 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-f79c46d000000b84-6a-541a3c66126e
Content-transfer-encoding: 8BIT
Message-id: <541A3C65.3080107@samsung.com>
Date: Thu, 18 Sep 2014 10:59:01 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, jdelvare@suse.de
Subject: Re: [PATCH v3] hwmon: ntc_thermistor: Add ntc thermistor to thermal
 subsystem as a sensor.
References: <1410933277-31704-1-git-send-email-jonghwa3.lee@samsung.com>
 <20140917154820.GC29184@roeck-us.net>
In-reply-to: <20140917154820.GC29184@roeck-us.net>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSrJtmIxViMGMHm8XSu5/YLC7vmsNm
	8WThGSaLO9P2sjmweDyYuJvNY+f3BnaPzaerPT5vkgtgieKySUnNySxLLdK3S+DKmHBgKmPB
	CsWK+/tmMTYw3pHqYuTkkBAwkfj6cwMbhC0mceHeeiCbi0NIYCmjxNobW5lhihYdfM0OkZjO
	KHHr/jFGkASvgKDEj8n3WLoYOTiYBeQljlzKBgkzC6hLTJq3iBmi/jWjxLqTN5gg6rUk/ix6
	DNbLIqAqcWfKBLDNbAJyEm+bvoHFRQXCJK5OOM4CYosIqEk0n2phgxjqK/Hw/nE2kF3CAqkS
	6xvVQMJCAgUSi7+tYgexOQWMJK7072SEuHkbu8SXPbkQqwQkvk0+BHamhICsxKYDUG9JShxc
	cYNlAqPYLCTPzEJ4ZhaSZxYwMq9iFE0tSC4oTkovMtQrTswtLs1L10vOz93ECIyj0/+e9e5g
	vH3A+hCjAAejEg/vAV6pECHWxLLiytxDjKZAR0xklhJNzgdGa15JvKGxmZGFqYmpsZG5pZmS
	OK+i1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzWj/ttLy9L517seexhm4EEo1BFvejX
	haX+vbOfvMu626kgPf2iULZeZ9F7AZuCvY/m3ly1/8ukDftvWdguyfj7tj+/J/PxNSstcd6N
	L6dOv/Qg6BPzyTUt6+qsvm9ivhbCaDmts7+cO8rOQvNHtMC/c9e4pCU4/016wdR8e3bzxGsi
	LW9+BlcqsRRnJBpqMRcVJwIA8M/rKp4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQd1UG6kQg7PPrC2W3v3EZnF51xw2
	iycLzzBZ3Jm2l82BxePBxN1sHju/N7B7bD5d7fF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGENY8aEA1MZC1YoVtzfN4uxgfGOVBcjJ4eEgInEooOv2SFsMYkL99az
	dTFycQgJTGeUuHX/GCNIgldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mlFi3ckb
	TBD1WhJ/Fj0G62URUJW4M2UCG4jNJiAn8bbpG1hcVCBM4uqE4ywgtoiAmkTzqRY2iKG+Eg/v
	H2cD2SUskCqxvlENJCwkUCCx+NsqsDs5BYwkrvTvZJzAKDALyXWzEK6bheS6BYzMqxhFUwuS
	C4qT0nON9IoTc4tL89L1kvNzNzGC4/SZ9A7GVQ0WhxgFOBiVeHgP8EqFCLEmlhVX5h5ilOBg
	VhLh9XwvGSLEm5JYWZValB9fVJqTWnyI0RTot4nMUqLJ+cAUklcSb2hsYmZkaWRuaGFkbK4k
	znuw1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgdHtMf8isQUlwb8c9oU+4LOWXzjhmWubhHYww8QJ
	XI9n37Sb+W7G3HT/mLkLb2/+HJNfK2qXLLMz4fKOM8y3Gj/k/f84Pe/59bqARuXfguwxLnMs
	z7AaxdWIKr759S2pcuaeE8ZGPYZ3DQyW1UwLiHvFeDdqSTo3y6FzO89y7eqXufrmWsPTEhYl
	luKMREMt5qLiRAA3QmC46QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 09월 18일 00:48, Guenter Roeck wrote:

> On Wed, Sep 17, 2014 at 02:54:37PM +0900, Jonghwa Lee wrote:
>> To get more comprehensive and integrated thermal management, it adds ntc
>> thermistor to thermal framework as a thermal sensor. It's governed thermal
>> susbsystem only if it is described in DT node. Otherwise, it just notifies
>> temperature to userspace via sysfs as it used to be.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> Looks ok as far as I can see. I applied it to hwmon-next. I'll let you know
> if there are any problems.
> 
> Guenter


Okay, thanks ;)

Best regards,
Jonghwa

> 
>> ---
>> Changes:
>> v3:
>>  - Add dependencies of thermal subsystem for proper building.
>> v2:
>>  - Remove NULL pointer checking already done by thermal_zone_of_sensor_unregister().
>>
>>  .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
>>  drivers/hwmon/Kconfig                              |    1 +
>>  drivers/hwmon/ntc_thermistor.c                     |   25 ++++++++++++++++++++
>>  3 files changed, 29 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> index 2391e5c..fcca8e7 100644
>> --- a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> +++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
>> @@ -25,6 +25,9 @@ Requires node properties:
>>  - "io-channels"	Channel node of ADC to be used for
>>  		conversion.
>>  
>> +Optional node properties:
>> +- "#thermal-sensor-cells" Used to expose itself to thermal fw.
>> +
>>  Read more about iio bindings at
>>  	Documentation/devicetree/bindings/iio/iio-bindings.txt
>>  
>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>> index 4289a4f..f790b41 100644
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -1077,6 +1077,7 @@ config SENSORS_PC87427
>>  config SENSORS_NTC_THERMISTOR
>>  	tristate "NTC thermistor support from Murata"
>>  	depends on !OF || IIO=n || IIO
>> +	depends on THERMAL || !THERMAL_OF
>>  	help
>>  	  This driver supports NTC thermistors sensor reading and its
>>  	  interpretation. The driver can also monitor the temperature and
>> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
>> index bd41072..4ff89b2 100644
>> --- a/drivers/hwmon/ntc_thermistor.c
>> +++ b/drivers/hwmon/ntc_thermistor.c
>> @@ -38,6 +38,7 @@
>>  
>>  #include <linux/hwmon.h>
>>  #include <linux/hwmon-sysfs.h>
>> +#include <linux/thermal.h>
>>  
>>  struct ntc_compensation {
>>  	int		temp_c;
>> @@ -182,6 +183,7 @@ struct ntc_data {
>>  	struct device *dev;
>>  	int n_comp;
>>  	char name[PLATFORM_NAME_SIZE];
>> +	struct thermal_zone_device *tz;
>>  };
>>  
>>  #if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
>> @@ -428,6 +430,20 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>>  	return -EINVAL;
>>  }
>>  
>> +static int ntc_read_temp(void *dev, long *temp)
>> +{
>> +	struct ntc_data *data = dev_get_drvdata(dev);
>> +	int ohm;
>> +
>> +	ohm = ntc_thermistor_get_ohm(data);
>> +	if (ohm < 0)
>> +		return ohm;
>> +
>> +	*temp = get_temp_mc(data, ohm);
>> +
>> +	return 0;
>> +}
>> +
>>  static ssize_t ntc_show_name(struct device *dev,
>>  		struct device_attribute *attr, char *buf)
>>  {
>> @@ -562,6 +578,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>>  	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
>>  								pdev_id->name);
>>  
>> +	data->tz = thermal_zone_of_sensor_register(data->dev, 0, data->dev,
>> +						ntc_read_temp, NULL);
>> +	if (IS_ERR(data->tz)) {
>> +		dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
>> +		data->tz = NULL;
>> +	}
>> +
>>  	return 0;
>>  err_after_sysfs:
>>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>> @@ -578,6 +601,8 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
>>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>>  	ntc_iio_channel_release(pdata);
>>  
>> +	thermal_zone_of_sensor_unregister(data->dev, data->tz);
>> +
>>  	return 0;
>>  }
>>  
>> -- 
>> 1.7.9.5
>>
> 


