Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbaEQPep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:34:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49213 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbaEQPeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:34:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5377818A.3020104@roeck-us.net>
Date: Sat, 17 May 2014 08:34:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Jean Delvare <jdelvare@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Dell Latitude E6440 & i8k
References: <201405162037.41782@pali> <20140516211117.0c766287@endymion.delvare> <201405162123.02112@pali>
In-Reply-To: <201405162123.02112@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 12:23 PM, Pali Rohár wrote:
> On Friday 16 May 2014 21:11:17 Jean Delvare wrote:
>> Hi Pali,
>>
>> On Fri, 16 May 2014 20:37:41 +0200, Pali Rohár wrote:
>>> Hello,
>>>
>>> on Dell Latitude E6440 driver i8k reporting total nonsense
>>> values
>>
>> That's kind of excessive wording, the output isn't that bad.
>>
>
> I mean fan RPM & temp4. Those are for sure incorrect.
>
>>> $ sensors
>>> i8k-virtual-0
>>> Adapter: Virtual device
>>> Right Fan:   93450 RPM
>>> CPU:          +57.0°C
>>> temp2:        +57.0°C
>>> temp3:        +40.0°C
>>> temp4:       +127.0°C
>>>
>>> Right Fan and temp4 are for sure incorrect.
>>
>> Driver is reverse-engineered so this is best effort and some
>> tweaking may be needed.
>>
>
> Ok, if driver is developed without any documentation, then it
> make sense that not working correctly on new machines...
>
> So is not there any documentation? I think that Dell released
> some SMM/BIOS code... But I'm not sure about it.
>

If you find it, please let us know.

Guenter


