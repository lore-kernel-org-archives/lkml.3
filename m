Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaD1CdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:33:05 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:36642 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaD1CdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:33:03 -0400
Message-ID: <535DBDA4.6070607@huawei.com>
Date: Mon, 28 Apr 2014 10:32:04 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Robert Richter <rric@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>
Subject: Re: [PATCH] arm64: add OProfile support
References: <535B707F.7020802@huawei.com> <58ED971B-CC04-4BE1-916C-386D219874A8@arm.com> <535B88C9.6000908@huawei.com>
In-Reply-To: <535B88C9.6000908@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/26 18:22, Ding Tianhong wrote:
> On 2014/4/26 17:23, Catalin Marinas wrote:
>> On 26 Apr 2014, at 09:38, Ding Tianhong <dingtianhong@huawei.com> wrote:
>>> Add OProfile support for arm64,  using the perf backend, and failing back
>>> to generic timer based sampling if PMU interrupt is not supported.
>>>
>>> I have test this patch on Cortex-A53 and Cortex-A57 motherboard, the OProfile
>>> could work well by PMU irq or arch timer irq.
>>
>> This came up before a few times and we also had an implementation but
>> decided not to merge it. We should rather get the user space oprofile to
>> use the perf kernel API.
>>
>> That’s an old thread, it may have even made it into mainline oprofile
>> but I haven’t followed the development:
>>
>> http://marc.info/?l=oprofile-list&m=133002515616302&w=2
>>
>> Catalin
>>

Hi Cadtalin:

Sorry I could not find the implementation that not to merge the orpfile support for aarch64 till now, and
I still have questions that the existing code only support oprofile by arch timer event, but not
PMU event, this patch only add HW PMU support for oprofile, it is more accurate and stable, can you
give me more advise and appreciate for your help.

Regards
Ding

> Ok, I will check it and then decide the next step, thanks for your feedback.
> 
> Regards
> Ding
> 


