Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3KZEiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:38:14 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62300 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3KZEiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:38:10 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <529425B1.7000708@roeck-us.net>
Date: Mon, 25 Nov 2013 20:38:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ads7846: Convert to devm_hwmon_device_register_with_groups
References: <1385242620-21719-1-git-send-email-linux@roeck-us.net> <20131126030308.GF31517@core.coreip.homeip.net>
In-Reply-To: <20131126030308.GF31517@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 07:03 PM, Dmitry Torokhov wrote:
> Hi Guenter,
>
> On Sat, Nov 23, 2013 at 01:37:00PM -0800, Guenter Roeck wrote:
>> Simplify the code and create mandatory 'name' attribute by using
>> new hwmon API.
>>
>> Also use is_visible to determine visible attributes instead of creating
>> several different attribute groups.
>
> This change does not quite work without converting the rest of the
> driver to devm_ resources as it makes hwmon outlive regulator and other
> essential resources when unbinding driver from the device.
>
Ok, I'll use hwmon_device_register_with_groups instead.

Thanks,
Guenter


