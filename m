Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaBTHeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:34:12 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:43713 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaBTHeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:34:10 -0500
Message-ID: <5305AF24.4030503@huawei.com>
Date: Thu, 20 Feb 2014 15:30:44 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <shuah.kh@samsung.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <n-horiguchi@ah.jp.nec.com>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>, "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/26] 3.10.31-stable review
References: <20140218224530.398913499@linuxfoundation.org> <53054C83.8000409@samsung.com>
In-Reply-To: <53054C83.8000409@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/20 8:29, Shuah Khan wrote:

> On 02/18/2014 03:46 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.10.31 release.
>> There are 26 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu Feb 20 22:45:20 UTC 2014.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.31-rc1.gz
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Compile and boot tests passed on AMD system. Boot failed on Intel systems. I think the following changes are the suspect, so far by process of elimination - these two aren't in 3.12 and 3.13
> 
> #    modified:   mm/hugetlb.c
> #    modified:   mm/memory-failure.c
> 
> However, my strong suspect is the following:
> 
> Xishi Qiu <qiuxishi@huawei.com>
>     mm: fix process accidentally killed by mce because of huge page migration
> 
> I don't see how this could cause problems, none the less, I will test without these changes and let you know.
> 
> 
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     mm/memory-failure.c: fix memory leak in successful soft offlining
> 
> I will test without these changes and let you know.
> 
> -- Shuah
> 

Hi Shuah

I tested on my system, it boot successfully.

hardware: Intel(R) Xeon(R) CPU E5-2420 0 @ 1.90GHz
OS: v3.10.30 + the two patches

Thanks,
Xishi Qiu

> Shuah Khan
> Senior Linux Kernel Developer - Open Source Group
> Samsung Research America(Silicon Valley)
> shuah.kh@samsung.com | (970) 672-0658
> 
> 



