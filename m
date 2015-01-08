Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbbAHISY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:18:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57930 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbbAHISW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:18:22 -0500
Message-ID: <54AE3D49.9060801@arm.com>
Date: Thu, 08 Jan 2015 13:48:17 +0530
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH RFT] s390: move cacheinfo sysfs to generic cacheinfo infrastructure
References: <1420702912-9749-1-git-send-email-sudeep.holla@arm.com> <20150108081446.GC3997@osiris>
In-Reply-To: <20150108081446.GC3997@osiris>
X-OriginalArrivalTime: 08 Jan 2015 08:18:20.0545 (UTC) FILETIME=[A9BAD710:01D02B1B]
X-MC-Unique: 115010808182006501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 08 January 2015 01:44 PM, Heiko Carstens wrote:
> On Thu, Jan 08, 2015 at 07:41:52AM +0000, Sudeep Holla wrote:
>> This patch removes the redundant sysfs cacheinfo code by reusing
>> the newly introduced generic cacheinfo infrastructure through the
>> commit 246246cbde5e ("drivers: base: support cpu cache information
>> interface to userspace via sysfs")
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: linux390@de.ibm.com
>> Cc: linux-s390@vger.kernel.org
>> ---
>>   arch/s390/kernel/cache.c | 388 +++++++++++------------------------------------
>>   1 file changed, 92 insertions(+), 296 deletions(-)
>>
>> Hi Heiko,
>>
>> If you can give this a quick testing though nothing has changes since
>> you last tested it, that would be good.
>>
>> If nothing is broken, please feel free to take this through your tree.
>>
>> Regards,
>> Sudeep
>
> Still works. I forwarded your patch with my sign-off to Martin, so he can
> apply it for the next merge window.
>
> Thanks a lot for your work!

Thanks to you indeed for following up, testing and support during 
development.

Regards,
Sudeep

