Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaHGHg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:36:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54027 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaHGHgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:36:25 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E32C77.5000804@roeck-us.net>
Date: Thu, 07 Aug 2014 00:36:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: kreijack@inwind.it, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>	<1407359103-6012-6-git-send-email-kreijack@inwind.it>	<20140806231803.GA5643@roeck-us.net>	<53E31694.8050107@gmail.com>	<53E31AB0.6070604@roeck-us.net> <20140807085235.2c0e63dd@endymion.delvare>
In-Reply-To: <20140807085235.2c0e63dd@endymion.delvare>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 11:52 PM, Jean Delvare wrote:
> Hi Guenter,
>
> On Wed, 06 Aug 2014 23:20:32 -0700, Guenter Roeck wrote:
>> Patch 4/5 is "Return the fan speed via sysfs: /sys/devices/temperature/fan_level".
>>
>> So you are saying that returning the fan speed with a non-hwmon attribute works,
>> but returning it with a hwmon attribute doesn't ? Not really sure if I understand
>> your logic. Either fan_level doesn't return the fan speed (or an abstraction of it),
>> or something in your line of argument is inconsistent.
>
> fan_level is a fan speed _control_ value, like pwm1. It is not a fan
> speed monitoring value.
>
Ah, ok. The patch description doesn't seem to match, though.
And why not export it as pwm1, if that is what it is ?

Guenter

