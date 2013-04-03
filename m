Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964Ab3DCLjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:39:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21738 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3DCLjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:39:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,401,1363158000"; 
   d="scan'208";a="35518550"
Message-ID: <515C14FD.4040703@codeaurora.org>
Date: Wed, 03 Apr 2013 07:39:41 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Suggestion] ARM64:kernel: compiling issue for early_console.
References: <5152DB83.8080703@asianux.com> <20130327115509.GA1603@MacBook-Pro.local> <5152DFF1.2090000@asianux.com> <515BE49C.8040601@asianux.com>
In-Reply-To: <515BE49C.8040601@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On 04/03/2013 04:13 AM, Chen Gang wrote:
> Hello Maintainers:
> 
>   it seems, this issue still exists in next-20130402.
> 
>   have you already fixed it in another tree ?

Maybe somebody else does have a fix, but Catalin mentioned he was going on
vacation for two weeks on March 28th in "[GIT PULL] Preparatory GIC patches
for arm64 support".

>   if really no one fix it within this week, I should try (since I find it).

I'm sure a fix would be appreciated.

> On 2013年03月27日 20:02, Chen Gang wrote:
>> On 2013年03月27日 19:55, Catalin Marinas wrote:
>>> On Wed, Mar 27, 2013 at 11:44:03AM +0000, Chen Gang wrote:
>>>>>   the error message:
>>>>>     arch/arm64/kernel/early_printk.c: At top level:
>>>>>     arch/arm64/kernel/early_printk.c:98:23: error: conflicting types for ‘early_console’
>>>>>     In file included from arch/arm64/kernel/early_printk.c:20:0:
>>>>>     include/linux/console.h:145:24: note: previous declaration of ‘early_console’ was here
>>>>>     make[1]: *** [arch/arm64/kernel/early_printk.o] Error 1
>>>>>     make: *** [arch/arm64/kernel] Error 2
>>> Is this in linux-next? Mainline seems fine.
>>
>>   yes, it is in next-20130326 at least :-)
>>
>>>
>>> I saw some patches from tglx on unifying the various early printk
>>> implementations, though not sure whether it's those patches causing it
>>> (in which case arm64 needs to be updated as well).

I looked briefly and wasn't able to find this patchset.

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
