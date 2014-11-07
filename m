Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaKGTku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:40:50 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40145 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaKGTks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:40:48 -0500
Message-ID: <545D2043.1080703@arm.com>
Date: Fri, 07 Nov 2014 19:40:51 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [PATCH v5 00/11] drivers: cacheinfo support
References: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com> <5445587B.8090203@arm.com> <20141020184932.GA25398@kroah.com> <544626AD.403@arm.com> <20141107192310.GB30923@kroah.com>
In-Reply-To: <20141107192310.GB30923@kroah.com>
X-OriginalArrivalTime: 07 Nov 2014 19:40:44.0160 (UTC) FILETIME=[B86A3000:01CFFAC2]
X-MC-Unique: 114110719404603101
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/11/14 19:23, Greg Kroah-Hartman wrote:
> On Tue, Oct 21, 2014 at 10:26:05AM +0100, Sudeep Holla wrote:
>> Hi Greg,
>>
>> On 20/10/14 19:49, Greg Kroah-Hartman wrote:
>>> On Mon, Oct 20, 2014 at 07:46:19PM +0100, Sudeep Holla wrote:
>>>> Hi Greg,
>>>>
>>>> On 30/09/14 14:48, Sudeep Holla wrote:
>>>>> This series adds a generic cacheinfo support similar to topology. The
>>>>> implementation is based on x86 cacheinfo support. Currently x86, powerpc,
>>>>> ia64 and s390 have their own implementations. While adding similar support
>>>>> to ARM and ARM64, here is the attempt to make it generic quite similar to
>>>>> topology info support. It also adds the missing ABI documentation for
>>>>> the cacheinfo sysfs which is already being used.
>>>>>
>>>>> It moves all the existing different implementations on x86, ia64, powerpc
>>>>> and s390 to use the generic cacheinfo infrastructure introduced here.
>>>>> These changes on non-ARM platforms are only compile tested and tested on x86.
>>>>>
>>>>> This series also adds support for ARM and ARM64 architectures based on
>>>>> the generic support.
>>>>>
>>>>> The code can be fetched from:
>>>>>   git://linux-arm.org/linux-skn cacheinfo
>>>>>
>>>>
>>>> I am hoping to target this for v3.19 if possible, it would be good if
>>>> you can review and provide feedback.
>>>
>>> 3.18-rc1 just came out a few _hours_ ago, and now we can start worrying
>>> about what goes into 3.19.  I have 1257 emails in my "to-review" queue
>>> for 3.19, please give me a chance to catch up in a few weeks to get to
>>> this code.
>>>
>>
>> I completely understand and I am sorry if that was a noise.
>> I just wanted to ensure it's not lost, thanks for letting me know it's
>> in your list.
>
> Do you want me to take this through my tree?  If so, I will, otherwise,
> feel free to add:

I have not got it tested on AMD, IA64 and PPC. Probably they were
waiting for the core driver to settle down. I have only tested on
ARM{32,64} and x86. Heiko Carstens tested on s390 long back some
previous version.

If it fine with you, I would like to break the first 4 patches and
target it for v3.19, and take up the arch-specific patches (i.e.5-11)
after that, so that I can get them tested on all architectures.

>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> to the series.

Thanks, I will rebase on v3.18-rc4 and repost first 4 patches  on Monday 
which you can take it through your tree *iff you agree with me* on above 
flow.

Regards,
Sudeep

