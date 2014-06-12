Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbaFLMGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:06:38 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57958 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbaFLMGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:06:31 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539997BF.7040906@roeck-us.net>
Date: Thu, 12 Jun 2014 05:06:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: hs@denx.de
CC: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] hwmon: Driver for TI TMP103 temperature sensor
References: <1402468095-14678-1-git-send-email-hs@denx.de> <53988DC1.7000203@roeck-us.net> <53997544.5090106@denx.de>
In-Reply-To: <53997544.5090106@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 02:39 AM, Heiko Schocher wrote:
> Hello Guenter,
[ ... ]
>>
>> Overall you might consider dropping the update function and using regmap instead.
>> It would be an excellent fit for this driver; while it doesn't do timed caching
>> it supports per-register caching which is ultimately more useful anyway.
>> Some of the drivers in the hwmon directory use it, so you could use that
>> as example. Not mandatory, though; just a suggestion.
>
> Could you give me an example?
>
Hello Heiko,

check for the use of regmap in drivers/hwmon. Any of the drivers using it can serve
as example.

Guenter

