Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbbARGg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 01:36:26 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63140 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbARGgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 01:36:22 -0500
Message-ID: <54BB545B.5060800@linaro.org>
Date: Sun, 18 Jan 2015 14:36:11 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Mark Brown <broonie@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com> <20150115182346.GE2329@e104818-lin.cambridge.arm.com> <20150115190220.GF3043@sirena.org.uk> <20150115200437.GF24989@titan.lakedaemon.net> <20150116101034.GC13634@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150116101034.GC13634@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月16日 18:10, Catalin Marinas wrote:
> On Thu, Jan 15, 2015 at 08:04:37PM +0000, Jason Cooper wrote:
>> On Thu, Jan 15, 2015 at 07:02:20PM +0000, Mark Brown wrote:
>>> On Thu, Jan 15, 2015 at 06:23:47PM +0000, Catalin Marinas wrote:
>>>> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
>>>
>>>>> I'll get right to the point: Can we please have this series queued up
>>>>> for v3.20?
>>>
>>>> Before you even ask for this, please look at the patches and realise
>>>> that there is a complete lack of Reviewed-by tags on the code (well,
>>>> apart from trivial Kconfig changes). In addition, the series touches on
>>>> other subsystems like clocksource, irqchip, acpi and I don't see any
>>>> acks from the corresponding maintainers. So even if I wanted to merge
>>>> the series, there is no way it can be done without additional
>>>> reviews/acks. On the document (last patch), I'd like to see a statement
>>>
>>> There's probably a bit of a process problem here - these patches are all
>>> being posted as part of big and apparently controversial threads with
>>> subject lines in the form "ARM / ACPI:" so people could be forgiven for
>>> just not even reading the e-mails enough to notice changes to their
>>> subsystems.  Is it worth posting those patches separately more directly
>>> to the relevant maintainers?
>>
>> I think it's beneficial to post the entire series as one thread, but to
>> change the subject line of each patch to adequately reflect the affected
>> subsystem.
>
> Indeed, keeping the series as one thread is better. Apart from a
> slightly less misleading subject, I suggest Hanjun that he passes each
> patch via get_maintainer.pl and adds the corresponding Cc: lines to the
> commit log. I think that's a clearer way keep track of who needs to
> ack/review the patches.

I already checked all the patches with get_maintainer.pl, and CC the 
maintainers in the CC list, I will add the corresponding Cc: lines in
next version.

Thanks
Hanjun
