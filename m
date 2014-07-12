Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaGLGDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 02:03:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63037 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaGLGD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 02:03:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C0CFAF.70907@roeck-us.net>
Date: Fri, 11 Jul 2014 23:03:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3.15 000/122] 3.15.5-stable review
References: <20140707235734.234226883@linuxfoundation.org> <53BBF17D.9040001@roeck-us.net>
In-Reply-To: <53BBF17D.9040001@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 06:26 AM, Guenter Roeck wrote:
> On 07/07/2014 04:56 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.15.5 release.
>> There are 122 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed Jul  9 23:57:10 UTC 2014.
>> Anything received after that time might be too late.
>>
>
>
> Build results:
>      total: 139 pass: 136 fail: 3
> Failed builds:
>      powerpc:allmodconfig (binutils 2.23)
>      powerpc:allmodconfig (binutils 2.24)
>      unicore32:defconfig
>
> Qemu tests all passed.
>
> Results are as expected.
>
> Details are available at http://server.roeck-us.net:8010/builders.
>
> For the unicore32 build to pass in this release, the following
> additional patches would be needed.
>
> 73fa540618 drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue
> c863810cef drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue
>
> A workaround patch to address the powerpc build failures is pending.
> I'll send you a note after it is available if Ben doesn't Cc: stable.
>

Greg,

The patch to fix the powerpc:allmodconfig build is now available upstream.

fb43e84 powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

Please add this patch to 3.14.y and 3.15.y.

Thanks,
Guenter


