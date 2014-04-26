Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaDZKXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:23:22 -0400
Received: from [119.145.14.66] ([119.145.14.66]:42669 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaDZKXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:23:19 -0400
Message-ID: <535B88C9.6000908@huawei.com>
Date: Sat, 26 Apr 2014 18:22:01 +0800
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
References: <535B707F.7020802@huawei.com> <58ED971B-CC04-4BE1-916C-386D219874A8@arm.com>
In-Reply-To: <58ED971B-CC04-4BE1-916C-386D219874A8@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/26 17:23, Catalin Marinas wrote:
> On 26 Apr 2014, at 09:38, Ding Tianhong <dingtianhong@huawei.com> wrote:
>> Add OProfile support for arm64,  using the perf backend, and failing back
>> to generic timer based sampling if PMU interrupt is not supported.
>>
>> I have test this patch on Cortex-A53 and Cortex-A57 motherboard, the OProfile
>> could work well by PMU irq or arch timer irq.
> 
> This came up before a few times and we also had an implementation but
> decided not to merge it. We should rather get the user space oprofile to
> use the perf kernel API.
> 
> That’s an old thread, it may have even made it into mainline oprofile
> but I haven’t followed the development:
> 
> http://marc.info/?l=oprofile-list&m=133002515616302&w=2
> 
> Catalin
> 
Ok, I will check it and then decide the next step, thanks for your feedback.

Regards
Ding


