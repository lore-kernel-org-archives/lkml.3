Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3INTQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:16:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52054 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3INTQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:16:03 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5234B5F0.6010706@roeck-us.net>
Date: Sat, 14 Sep 2013 12:16:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Introduce hwmon_device_register_with_groups and
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net> <5224E62F.1050400@roeck-us.net> <20130914203156.55e4b885@endymion.delvare>
In-Reply-To: <20130914203156.55e4b885@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2013 11:31 AM, Jean Delvare wrote:
> Hi Guenter,
>
> On Mon, 02 Sep 2013 12:25:35 -0700, Guenter Roeck wrote:
>> On 08/31/2013 07:48 PM, Guenter Roeck wrote:
>>> This patch series introduces new hwmon API functions
>>> hwmon_device_register_with_groups() and devm_hwmon_device_register_with_groups().
>>>
>>> hwmon_device_register_with_groups() lets callers register hwmon devices
>>> as well as associated sysfs attributes with a single call. This simplifies
>>> hwmon device registration and avoids potential race conditions seen
>>> if sysfs attributes are created after the initial hwmon device was
>>> registered.
>>>
>>> devm_hwmon_device_register_with_groups() is the managed version of the same
>>> function.
>>>
>> Jean, any comments on this patch series ?
>>
>> If you are ok with it, I would like to push the new API (patches 1 and 7 of the series)
>> into 3.12, and keep the rest for 3.13.
>
> I'm afraid I won't have the time to review all these patches. The
> concept looks good to me and I trust that you implemented things right
> so feel free to push the patches upstream even without my review.
>

No problem. I'll add the entire series to -next after the commit window closes.

Thanks,
Guenter

