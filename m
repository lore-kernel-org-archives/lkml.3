Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaCMXEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:04:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54305 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaCMXEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:04:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53223964.2080408@roeck-us.net>
Date: Thu, 13 Mar 2014 16:04:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] mfd: lpc_ich: Fix ACPI enable bitmask
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com> <20140313151601.GA4479@roeck-us.net> <20140313152534.GC10356@lee--X1> <20140313225040.GK28504@lee--X1>
In-Reply-To: <20140313225040.GK28504@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:50 PM, Lee Jones wrote:
>>>> The original bitmask of 0x10 was incorrect and would result in a write
>>>> to a reserved read-only bit instead of enabling the ACPI I/O
>>>> region.  Update it to the proper value of 0x80.
>>>>
>>>> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
>>>> Tested-by: Rajat Jain <rajatjain@juniper.net>
>>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>>> Cc: James Ralston <james.d.ralston@intel.com>
>>>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>>>> Cc: Lee Jones <lee.jones@linaro.org>
>>>
>>> Who is going to pick up this series ?
>>
>> I will, once I've completed the review.
>
> Okay review complete, phew!
>
> Guenter, How do you want to play this? Do you want me to create an
> immutable branch for you to pull from?
>

I'll be happy if I can pull it from -next. Is it going to be there
anytime soon ?

Thanks,
Guenter

