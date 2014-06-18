Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966612AbaFRNCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:02:40 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63508 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966587AbaFRNCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:02:38 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A18DE4.8030107@roeck-us.net>
Date: Wed, 18 Jun 2014 06:02:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, hs@denx.de
CC: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5] hwmon: Driver for TI TMP103 temperature sensor
References: <1403069837-15651-1-git-send-email-hs@denx.de> <53A127BB.7090802@gmail.com> <53A12ED2.4080004@denx.de> <53A138A0.4010704@gmail.com>
In-Reply-To: <53A138A0.4010704@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 11:58 PM, Varka Bhadram wrote:
> On 06/18/2014 11:46 AM, Heiko Schocher wrote:
...
>>>
>>> In the bindings you are giving the compatible property as : ti,tmp103, but here only tmp103.
>>>
>>> Instead of using the i2c_device_id struct , use of_device_id struct for giving the
>>> compatible property value.
>>> compatble = "<manufacturer>,<model>"
>>
>> There are a lot of drivers in drivers/hwmon which use "i2c_device_id struct",
>> and for them only "model" is necessary ...
>>
>> As this is not a platform driver, I do not know, if "of_device_id struct"
>> is possible to use. For that, it must be converted to a platform
>> device driver ...
>>
> I thought your are using the devicetree source to load the driver. In that case it need not to be platform driver.
> we can use "of_device_id struct" which matches the bindings in your trivial-devices.txt
>

This would be unnecessary. The bindings will work just fine as-is.

I am starting to repeat myself, as do you. May I kindly suggest that you
spend some time educating yourself ?

Thanks,
Guenter

