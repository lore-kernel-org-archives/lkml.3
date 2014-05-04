Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaEDVdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 17:33:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52350 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaEDVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 17:33:30 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5366B224.4070809@roeck-us.net>
Date: Sun, 04 May 2014 14:33:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/158] 3.14.3-stable review
References: <20140504154029.975081050@linuxfoundation.org> <5366769D.2010104@roeck-us.net> <20140504202738.GA25318@kroah.com>
In-Reply-To: <20140504202738.GA25318@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 01:27 PM, Greg Kroah-Hartman wrote:
> On Sun, May 04, 2014 at 10:19:25AM -0700, Guenter Roeck wrote:
>> On 05/04/2014 08:38 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.14.3 release.
>>> There are 158 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Tue May  6 15:38:47 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 127 pass: 121 skipped: 4 fail: 2
>>
>> Qemu tests all passed.
>>
>> Additional failure is from new build target unicore32:defconfig, which fails
>> in all releases. The second failure is powerpc:allmodconfig which, together
>> with powerpc:allyesconfig, fails to build in 3.14 and later kernels.
>> Results are therefore as expected.
>>
>> Details are available at http://server.roeck-us.net:8010/builders.
>>
>
> If unicore32 doesn't build on any kernel version, should we just drop
> the whole arch?
>

Idea was to put the maintainer on notice. If nothing changes, that
may be a good idea.

> I'd suggest the same for powerpc, but odds are, there are still users :)
>
Yes, the company paying my salary, for example :-). But then if failure to build
allmodconfig/allyesconfig is a criteria, arm would be a prime target as well ...

Might be a discussion point for the kernel summit, though: What are criteria
for an architecture to be accepted, and for it to remain in the kernel ?
Availability of a pre-built tool set (score drops out)? defconfig build
failure (unicore32 be gone) ? Something else ?

Guenter

