Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbaHZKMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:12:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42958 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbaHZKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:12:14 -0400
X-AuditID: cbfee690-f79ce6d00000115a-b7-53fc5d7cc0d2
Message-id: <53FC5D7B.4040506@samsung.com>
Date: Tue, 26 Aug 2014 19:12:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, jdelvare@suse.de,
        linux@roeck-us.net
Subject: Re: [PATCH] hwmon: ntc_thermistor: Add ntc thermistor to thermal
 subsystem as a sensor.
References: <1409031220-25922-1-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1409031220-25922-1-git-send-email-jonghwa3.lee@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkULcm9k+wwb3NghZL735is+g8+4TZ
	4vKuOWwWTxaeYbK4M20vmwOrx4OJu9k8dn5vYPfo27KK0WPz6WqPz5vkAlijuGxSUnMyy1KL
	9O0SuDKWnlMpuC9ZsfniKeYGxh8iXYycHBICJhK3P75ngrDFJC7cW8/WxcjFISSwlFHix/bJ
	rDBFf87PZIdILGKU+LjqMJTzmlFi6qRd7CBVvAJaEkeObmQGsVkEVCWe7zoN1s0GFN//4gYb
	iC0qECaxcvoVFoh6QYkfk++B2SJANdcev2MEsZkFkiXud+8BO0lYIElidetVsDlCAh4S09+A
	zOTg4BTwlDhxKweiXEdif+s0NghbXmLzmrfMEEfvYpfY1qMJcY6AxLfJh1hAWiUEZCU2HYAq
	kZQ4uOIGywRGsVlIDpqFZOosJFMXMDKvYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiMrtP/
	nk3YwXjvgPUhRgEORiUe3hvxv4OFWBPLiitzDzGaAl0xkVlKNDkfGMN5JfGGxmZGFqYmpsZG
	5pZmSuK8r6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgDBRySnRfYv1m3QOVGT0TDB7N
	lnSadGnVx7mxvy72JDYXixW/773e3sfplro9KXnf3k2VfI2bMi/W/dM5/D3p7BdGI+Oc/9oH
	YirkUuK+dXt+3W63w8Be3znT45Kh6Wx/fefSm8tuF/uvFlas/1c841oUK9PeBbcu7fpfkMb7
	QC1ntsNDGV5LJZbijERDLeai4kQANhh8hKkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd3q2D/BBiu+W1osvfuJzaLz7BNm
	i8u75rBZPFl4hsnizrS9bA6sHg8m7mbz2Pm9gd2jb8sqRo/Np6s9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWHpOpeC+ZMXmi6eYGxh/iHQxcnJICJhI/Dk/
	kx3CFpO4cG89WxcjF4eQwCJGiY+rDrNDOK8ZJaZO2gVWxSugJXHk6EZmEJtFQFXi+a7TrCA2
	G1B8/4sbbCC2qECYxMrpV1gg6gUlfky+B2aLANVce/yOEcRmFkiWuN+9hwnEFhZIkljdehVs
	jpCAh8T0NyAzOTg4BTwlTtzKgSjXkdjfOo0NwpaX2LzmLfMERoFZSDbMQlI2C0nZAkbmVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjB0ftMagfjygaLQ4wCHIxKPLw34n8HC7EmlhVX5h5i
	lOBgVhLhfRj9J1iINyWxsiq1KD++qDQntfgQoykwACYyS4km5wMTS15JvKGxiZmRpZG5oYWR
	sbmSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsbFSd6pQrZGZ847nLvnt0RGysH5QdrSJfVN
	doc4L/t8dvug0Kj7am1G1Ko7q06knOEwlkxrYvjBwam3Y2q26N//dq/0rpYvuc3Md6nuT4vm
	XPEzs3RtHjlN7q+XCf9xvJrdqnqDiOdnKakfIWwvf0zhbz/leHPpI8GE/4e37nTpFnF5djdD
	1VyJpTgj0VCLuag4EQAc1Rze9AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwa,

On 08/26/2014 02:33 PM, Jonghwa Lee wrote:
> To get more comprehensive and integrated thermal management, it adds ntc
> thermistor to thermal framework as a thermal sensor. It's governed thermal
> susbsystem only if it is described in DT node. Otherwise, it just notifies
> temperature to userspace via sysfs as it used to be.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  .../devicetree/bindings/hwmon/ntc_thermistor.txt   |    3 +++
>  drivers/hwmon/ntc_thermistor.c                     |   26 ++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> index 2391e5c..fcca8e7 100644
> --- a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> +++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> @@ -25,6 +25,9 @@ Requires node properties:
>  - "io-channels"	Channel node of ADC to be used for
>  		conversion.
>  
> +Optional node properties:
> +- "#thermal-sensor-cells" Used to expose itself to thermal fw.
> +
>  Read more about iio bindings at
>  	Documentation/devicetree/bindings/iio/iio-bindings.txt
>  
> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
> index bd41072..369dc8c 100644
> --- a/drivers/hwmon/ntc_thermistor.c
> +++ b/drivers/hwmon/ntc_thermistor.c
> @@ -38,6 +38,7 @@
>  
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
> +#include <linux/thermal.h>
>  
>  struct ntc_compensation {
>  	int		temp_c;
> @@ -182,6 +183,7 @@ struct ntc_data {
>  	struct device *dev;
>  	int n_comp;
>  	char name[PLATFORM_NAME_SIZE];
> +	struct thermal_zone_device *tz;
>  };
>  
>  #if defined(CONFIG_OF) && IS_ENABLED(CONFIG_IIO)
> @@ -428,6 +430,20 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>  	return -EINVAL;
>  }
>  
> +static int ntc_read_temp(void *dev, long *temp)
> +{
> +	struct ntc_data *data = dev_get_drvdata(dev);
> +	int ohm;
> +
> +	ohm = ntc_thermistor_get_ohm(data);
> +	if (ohm < 0)
> +		return ohm;
> +
> +	*temp = get_temp_mc(data, ohm);
> +
> +	return 0;
> +}
> +
>  static ssize_t ntc_show_name(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> @@ -562,6 +578,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>  	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
>  								pdev_id->name);
>  
> +	data->tz = thermal_zone_of_sensor_register(data->dev, 0, data->dev,
> +						ntc_read_temp, NULL);
> +	if (IS_ERR(data->tz)) {
> +		dev_dbg(&pdev->dev, "Failed to register to thermal fw.\n");
> +		data->tz = NULL;
> +	}
> +
>  	return 0;
>  err_after_sysfs:
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> @@ -578,6 +601,9 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
>  	ntc_iio_channel_release(pdata);
>  
> +	if (data->tz)
> +		thermal_zone_of_sensor_unregister(data->dev, data->tz);

thermal_zone_of_sensor_unregister just return without operation if data->tz is NULL.
So, don't need to check the value of data->tz with if statement.

Thanks,
Chanwoo Choi
