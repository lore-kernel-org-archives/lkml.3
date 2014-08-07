Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaHGOTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:19:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52633 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaHGOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:19:41 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E38AFC.6040502@roeck-us.net>
Date: Thu, 07 Aug 2014 07:19:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: kreijack@inwind.it, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>	 <1407359103-6012-6-git-send-email-kreijack@inwind.it>	 <20140806231803.GA5643@roeck-us.net>	<53E31694.8050107@gmail.com>	 <53E31AB0.6070604@roeck-us.net> <20140807085235.2c0e63dd@endymion.delvare>	 <53E32C77.5000804@roeck-us.net> <1407400545.4314.2.camel@chaos.site>
In-Reply-To: <1407400545.4314.2.camel@chaos.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 01:35 AM, Jean Delvare wrote:
> Le Thursday 07 August 2014 à 00:36 -0700, Guenter Roeck a écrit :
>> On 08/06/2014 11:52 PM, Jean Delvare wrote:
>>> Hi Guenter,
>>>
>>> On Wed, 06 Aug 2014 23:20:32 -0700, Guenter Roeck wrote:
>>>> Patch 4/5 is "Return the fan speed via sysfs: /sys/devices/temperature/fan_level".
>>>>
>>>> So you are saying that returning the fan speed with a non-hwmon attribute works,
>>>> but returning it with a hwmon attribute doesn't ? Not really sure if I understand
>>>> your logic. Either fan_level doesn't return the fan speed (or an abstraction of it),
>>>> or something in your line of argument is inconsistent.
>>>
>>> fan_level is a fan speed _control_ value, like pwm1. It is not a fan
>>> speed monitoring value.
>>>
>> Ah, ok. The patch description doesn't seem to match, though.
>> And why not export it as pwm1, if that is what it is ?
>
> Well, /sys/devices/temperature is a non-standard interface anyway, so it
> does not really matter. I already discussed with Goffredo the

That is true.

> possibility to also expose it as pwm1 on the hwmon side, this might
> happen later.
>
Ok.

Thanks,
Guenter

