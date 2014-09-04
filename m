Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaIDEwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:52:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61763 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaIDEwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:52:13 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5407EFFA.50008@roeck-us.net>
Date: Wed, 03 Sep 2014 21:52:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.16 000/125] 3.16.2-stable review
References: <20140903220623.649748296@linuxfoundation.org> <20140903234457.GC27174@kroah.com>
In-Reply-To: <20140903234457.GC27174@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 04:44 PM, Greg Kroah-Hartman wrote:
> On Wed, Sep 03, 2014 at 03:05:57PM -0700, Greg Kroah-Hartman wrote:
>> --------------------------
>> Note, there are a _lot_ of patches submitted for stable kernels that
>> have yet to be applied, well over 200+ at the moment.  Given that this
>> series is already over 100 patches, I figured it was a good as a time as
>> any to push this out.  Don't worry, if you have emailed/marked patches
>> to be included, and they aren't here, wait a few more releases for me to
>> catch up, thanks.
>> --------------------------
>>
>> This is the start of the stable review cycle for the 3.16.2 release.
>> There are 125 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri Sep  5 22:06:09 UTC 2014.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.2-rc1.gz
>> and the diffstat can be found below.
>
> -rc2 is out to resolve some reported issues and remove some patches that
> should not have been there (yet):
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.2-rc2.gz
>

Build results:
	total: 136 pass: 136 fail: 0

Qemu tests all passed.

Detailed build and test results are available at
http://server.roeck-us.net:8010/builders.

Guenter

