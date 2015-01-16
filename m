Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbbAPHSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:18:07 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64400 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAPHSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:18:05 -0500
Message-ID: <54B8BB24.2020408@linaro.org>
Date: Fri, 16 Jan 2015 15:17:56 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Will Deacon <Will.Deacon@arm.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
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
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com> <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月16日 02:23, Catalin Marinas wrote:
> Hi Grant,
>
> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
>> On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
>>
>> I'll get right to the point: Can we please have this series queued up
>> for v3.20?
>
> Before you even ask for this, please look at the patches and realise
> that there is a complete lack of Reviewed-by tags on the code (well,
> apart from trivial Kconfig changes). In addition, the series touches on
> other subsystems like clocksource, irqchip, acpi and I don't see any
> acks from the corresponding maintainers. So even if I wanted to merge

For the ACPI part, Rafael already said that "Having looked at the
patches recently, I don't see any major problems in them from the ACPI
core perspective, so to me they are good to go." [1]
Is that kind of ack for this ?

Thanks
Hanjun

[1]:
http://lkml.iu.edu/hypermail/linux/kernel/1409.1/03363.html
