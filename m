Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbaHGN7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:59:43 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:56117 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbaHGN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:59:41 -0400
X-AuditID: cbfec37d-b7f676d000000907-ed-53e3864b3306
Message-id: <53E38643.2010108@samsung.com>
Date: Thu, 07 Aug 2014 07:59:31 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "sam@ravnborg.org >> Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: devtest - new make target for build all and run
 tests
References: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
 <53E232E6.8060506@suse.cz> <53E235DE.70604@samsung.com>
 <53E23669.5050309@suse.cz> <20140806143149.GA13552@kroah.com>
In-reply-to: <20140806143149.GA13552@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.247]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9hX13vtsfBBr+nqlk0L17PZvFn1w4m
	i8u75rBZtOy7wGSx4udWRgdWj/1z17B7LJl2lc3jzIIj7B6fN8kFsERx2aSk5mSWpRbp2yVw
	ZUx8UVKwlaNi194e1gbGK2xdjJwcEgImEr2L50DZYhIX7q0Hsrk4hASWMUr8vriaGcLpZZI4
	tfIhK4SzjVFibeN8oAwHB6+AlsSTN2DdLAKqEhdWbmYCsdkE1CU+v97BDmILCchJNC0BGcTJ
	ISoQIXGg7xkriM0rICjxY/I9FhBbRMBd4tvUGWD1zALlEk9fPWAEsYUFQiROfTvJDrF3H6NE
	//clYAlOAX2J03/esUI0WEusnLSNEcKWl9i85i0zxGJliT+XTzFBvKYssXHPbbYJjCKzkOye
	haR9FpL2BYzMqxjFSouTC4qT0lMrTPSKE3OLS/PS9ZLzczcxQmKldgfj/a82hxgFOBiVeHgf
	1D8KFmJNLCuuzD3EKMHBrCTCm1XyOFiINyWxsiq1KD++qDQntfgQIxMHp1QDo/3Uz2ZG9V+O
	SU/Xb9XZtyvHXuKi4469yrr/rp5u/Te/u6sobfq/1Or0+YtdLxt4pgXHVkRW3PFctyrNQbLz
	uXsfw93aUxJbb7iJ1S85cJ/vk13+T9YjG+vPcgi92lrvabZoZdnUtEfREz47iy+qv7grpLhy
	ZsbxaLnAs3u3MM4pF2XZff6QkhJLcUaioRZzUXEiAHTuluhzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 08:31 AM, Greg KH wrote:
> On Wed, Aug 06, 2014 at 04:06:33PM +0200, Michal Marek wrote:
>> On 2014-08-06 16:04, Shuah Khan wrote:
>>> On 08/06/2014 07:51 AM, Michal Marek wrote:
>>>> On 2014-07-18 22:44, Shuah Khan wrote:
>>>>> Add a new devtest make target to enable developer testing. This
>>>>> new target does full build (make all) and then runs selftests.
>>>>
>>>> I agree with Sam that the name is rather ambiguous, but I can't suggest
>>>> a better alternative right now.
>>>
>>> Does kselftest or kern_selftest sound better?
>>
>> It does sound better to me than dev(ice)test, but I'm not a native
>> English speaker. Greg?
>
> Either is fine with me, but I don't think we have '_' as any make target
> today, so perhaps "kselftest" is best?
>
> thanks,
>
> greg k-h
>

Patch v2 is on its way. kselftest is the new target. It does sound lot
better than devtest :)

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
