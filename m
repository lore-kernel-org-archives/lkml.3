Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3HFIJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:09:37 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59644 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3HFIJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:09:33 -0400
Message-ID: <5200AF41.7090405@linaro.org>
Date: Tue, 06 Aug 2013 10:09:37 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 0/3] ARM/ARM64 architected timer updates
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <51FB7CB8.6080103@arm.com> <51FB8081.6040501@linaro.org> <51FB81FB.3060709@arm.com> <51FBA21D.5010308@linaro.org> <51FFD1DF.9000907@arm.com>
In-Reply-To: <51FFD1DF.9000907@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 06:25 PM, Sudeep KarkadaNagesha wrote:
> Hi Daniel,
> 
> On 02/08/13 13:12, Daniel Lezcano wrote:
>> On 08/02/2013 11:55 AM, Sudeep KarkadaNagesha wrote:
>>> On 02/08/13 10:48, Daniel Lezcano wrote:
>>>> On 08/02/2013 11:32 AM, Sudeep KarkadaNagesha wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> On 22/07/13 12:21, Sudeep KarkadaNagesha wrote:
>>>>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>>>
>>>>>> This patch series adds support to configure the rate and enable the event
>>>>>> stream for architected timer. Since the timer control register is reset to
>>>>>> zero on warm boot, CPU PM notifier is added to re-initialse it.
>>>>>>
>>>>> This series is required to support TC2 cpuidle.
>>>>> It will be good if you can review and get this in for v3.12
>>>>
>>>> So do you want me to take the series through my tree ?
>>>>
>>> Yes I believe it has to go through your(ARM specific clocksource?) tree,
>>> but currently there's a conflict with another bug fix(that should come
>>> from rmk as -rc fix)
>>> (Commit ab8d46c0 "ARM: 7788/1: elf: fix lpae hwcap feature reporting in
>>> proc/cpuinfo" in rmk -fixes)
>>
>> IMO, you should rebase this patch on top of tips/core, I will apply the
>> series and when the rmk fix hits this branch (through tips/urgent), that
>> will be up to the maintainer to resolve this conflict.
>>
> 
> The fix with which this series was conflicting is already in v3.11-rc4
> So can I send pull request based on v3.11-rc4 or if you prefer any
> particular tree, can you provide details please ?

Ok, I will ping Thomas to update the tips/core branch to 3.11-rc4.



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

