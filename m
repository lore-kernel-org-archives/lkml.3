Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBMQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:29:25 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62329 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaBMQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:29:23 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52FCF2E2.30001@roeck-us.net>
Date: Thu, 13 Feb 2014 08:29:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>, Lee Jones <lee.jones@linaro.org>
CC: Laszlo Papp <lpapp@kde.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a platform
 driver
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>	<20140213095817.GD32508@lee--X1>	<20140213111530.2a2b4982@endymion.delvare>	<20140213111607.GK32508@lee--X1> <20140213125812.7ce5d0c9@endymion.delvare>
In-Reply-To: <20140213125812.7ce5d0c9@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 03:58 AM, Jean Delvare wrote:
> Hi Lee,
>
> On Thu, 13 Feb 2014 11:16:07 +0000, Lee Jones wrote:
>> On Thu, 13 Feb 2014, Jean Delvare wrote:
>>> Guenter just did:
>>>
>>> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041224.html
>>
>> Nice, FWIW:
>>    Acked-by: Lee Jones <lee.jones@linaro.org>
>>
>>> Any change to the max6650 driver should go on top of his patch series
>>> to avoid conflicts:
>>>
>>> http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html
>>
>> Do you have a tree Laszlo can rebase on top of?
>
> Now that the patches have my Reviewed-by and your Acked-by, I believe
> Guenter will add them shortly to:
>
> http://git.kernel.org/cgit/linux/kernel/git/groeck/linux-staging.git/log/?h=hwmon-staging
>
It is there now (in the hwmon-staging branch as Jean suggested).

Jean, Lee, thanks a lot for the reviews and simulation testing.
I'll try to get samples and test on real hardware before moving
the patches into hwmon-next.

Thanks,
Guenter

