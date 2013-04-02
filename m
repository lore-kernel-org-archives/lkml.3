Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab3DBX4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:56:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59102 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab3DBX4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:56:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <515B6FEE.9000508@jp.fujitsu.com>
Date: Wed, 3 Apr 2013 08:55:26 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Toshi Kani <toshi.kani@hp.com>, <linux-acpi@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <wency@cn.fujitsu.com>,
        <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] ACPI,acpi_memhotplug: Remove acpi_memory_info->failed
 bit
References: <514022BF.3080303@jp.fujitsu.com> <7171436.IWIKuTHVjL@vostro.rjw.lan> <515A227C.3060009@jp.fujitsu.com> <2321578.IdtOOylV2Q@vostro.rjw.lan>
In-Reply-To: <2321578.IdtOOylV2Q@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

2013/04/02 21:57, Rafael J. Wysocki wrote:
> On Tuesday, April 02, 2013 09:12:44 AM Yasuaki Ishimatsu wrote:
>> Hi Rafael,
>>
>> 2013/04/02 8:48, Rafael J. Wysocki wrote:
>>> On Thursday, March 28, 2013 08:58:03 AM Yasuaki Ishimatsu wrote:
>>>> Hi Rafael,
>>>>
>>>> 2013/03/26 22:41, Rafael J. Wysocki wrote:
>>>>> On Tuesday, March 26, 2013 08:57:05 AM Yasuaki Ishimatsu wrote:
>>>>>> 2013/03/23 5:24, Toshi Kani wrote:
>>>>>>> On Fri, 2013-03-22 at 10:53 +0900, Yasuaki Ishimatsu wrote:
>>>>>>>> acpi_memory_info has enabled bit and failed bit for controlling memory
>>>>>>>> hotplug. But we don't need to keep both bits.
>>>>>>>>
>>>>>>>> The patch removes acpi_memory_info->failed bit.
>>>>>>>>
>>>>>>>> Signed-off-by: yasuaki ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>>>>>
>>>>>>> Thanks for the update.  It looks good.  For the series:
>>>>>>>
>>>>>>> Acked-by: Toshi Kani <toshi.kani@hp.com>
>>>>>>
>>>>>> Thanks!
>>>>>
>>>>> Both patches applied to linux-pm.git/linux-next.
>>>>
>>>> Thank you for applying both patches.
>>>> If you don't mind, I hope these patches are merged into linux-3.9
>>>> since this is bug fix.
>>>
>>> I honestly don't think that [2/2] is 3.9 material, but I can push [1/2]
>>> for 3.9 provided that you also regard it as material for 3.8-stable.
>>
>> linux-3.8 does not support physical memory hot remove. It has been supported
>> since linux-3.9. So I don't need [1/2] patch to linux-3.8 but need it to
>> linux-3.9. So please push [1/2] patch to linux-3.9.
>
> Well, I don't think it would be a good idea to push that patch for 3.9 so late
> in the cycle.  Yes, it would make memory hotplug work in 3.9, but that might
> surprise some people and cause problems to happen as a result and we wouldn't
> have the time to address them before the 3.9 release.
>
> If that's not a big problem, I'd prefer to defer that patch until the 3.10
> merge window is open (which is just about 2 weeks from now) and if need be we
> can still push it for 3.9-stable afterward.

Sorry for bothering you by my mention.
I understood your thought. Please merge this patch to 3.10 and push if for
3.9-stable.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> Rafael
>
>


