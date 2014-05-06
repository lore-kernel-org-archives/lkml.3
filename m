Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaEFAJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:09:35 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52337 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbaEFAJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:09:33 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53682837.3050103@roeck-us.net>
Date: Mon, 05 May 2014 17:09:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/86] 3.10.39-stable review
References: <20140504154140.444932005@linuxfoundation.org> <536683D0.5000708@roeck-us.net> <20140505204343.GA18222@kroah.com>
In-Reply-To: <20140505204343.GA18222@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 01:43 PM, Greg Kroah-Hartman wrote:
> On Sun, May 04, 2014 at 11:15:44AM -0700, Guenter Roeck wrote:
>> On 05/04/2014 08:40 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.10.39 release.
>>> There are 86 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Tue May  6 15:41:13 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>
>> I am still seeing build failures, even with x86_64 (both allmodconfig and
>> allyesconfig fail).
>> 	total: 127 pass: 113 skipped: 4 fail: 10
>>
>> drivers/usb/musb/musb_core.c: In function 'musb_stage0_irq':
>> drivers/usb/musb/musb_core.c:673:26: error: 'struct musb' has no member named 'hcd'
>>
>> Problem is due to 'usb: musb: avoid NULL pointer dereference'.
>> A brief glance into the code suggests that the patch will require an explicit
>> back-port to 3.10.
>
> Thanks, I've now dropped that one.
>

Looks like you added it back in. The build with the dropped patch was fine.
I'll send another note after the rebuild with the patch added back in is complete.

Guenter

