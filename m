Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbaEQPZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:25:49 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62988 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbaEQPZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:25:48 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53777F72.3000907@roeck-us.net>
Date: Sat, 17 May 2014 08:25:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Dell Latitude E6440 & i8k
References: <201405162037.41782@pali> <20140516211117.0c766287@endymion.delvare>
In-Reply-To: <20140516211117.0c766287@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 12:11 PM, Jean Delvare wrote:
> Hi Pali,
>
> On Fri, 16 May 2014 20:37:41 +0200, Pali Rohár wrote:
>> Hello,
>>
>> on Dell Latitude E6440 driver i8k reporting total nonsense values
>
> That's kind of excessive wording, the output isn't that bad.
>
>> $ sensors
>> i8k-virtual-0
>> Adapter: Virtual device
>> Right Fan:   93450 RPM
>> CPU:          +57.0°C
>> temp2:        +57.0°C
>> temp3:        +40.0°C
>> temp4:       +127.0°C
>>
>> Right Fan and temp4 are for sure incorrect.
>
> Driver is reverse-engineered so this is best effort and some tweaking
> may be needed.
>
>> Value temp4 is always 127 and is never changing, but value for
>> Right Fan is increasing when fan is more noisy. So it looks like
>> value for Right Fan is not correctly normalized or multiplier is
>> incorrect.
>>
>> And name "Right" is incorrect too. Fan is on left side of this
>> notebook, not right as reported by driver.
>>
>> It is possible to fix these problems?
>
> Load the i8k driver with fan_mult=1.
>

Would it make sense to change the default multiplier to 1 ?
Lots of people have problems with it, and trying to figure out
affected machines one by one would be an all but impossible task.

Guenter


