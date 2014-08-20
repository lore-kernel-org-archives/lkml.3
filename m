Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaHTD0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:26:15 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53814 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaHTD0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:26:14 -0400
Message-ID: <53F414F8.2030405@linaro.org>
Date: Wed, 20 Aug 2014 11:24:40 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zi Shen Lim <zlim.lnx@gmail.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v2 06/18] ARM64 / ACPI: Parse MADT to map
 logical cpu to MPIDR and get cpu_possible/present_map
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>	<1407166105-17675-7-git-send-email-hanjun.guo@linaro.org>	<53F24705.7080809@arm.com>	<53F32E3C.1070102@linaro.org> <CAMDttNf5d6XZ66mbiZivLmZQvcFv1mN1KKkN6TUQe_Z5VCu-1g@mail.gmail.com>
In-Reply-To: <CAMDttNf5d6XZ66mbiZivLmZQvcFv1mN1KKkN6TUQe_Z5VCu-1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-20 0:46, Zi Shen Lim wrote:
> Hanjun,

Hi Lim,

> 
> On Tue, Aug 19, 2014 at 6:00 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> Will INTERRUPT_CONTROLLER confuse people? There is only one GIC redistributor
>> (some people regard it as interrupt controller) in ARM system, if we use
>> INTERRUPT_CONTROLLER people will regard it as multi-redistributors in the
>> system, I think GIC_CPU_INTERFACE would be better, what do you think?
> 
> I think you meant to say "one GIC _distributor_" (GICD) instead of
> redistributor (GICR).
> ACPI5.1 only describes one GICD per system, but we can most certainly
> describe multiple GICRs.
> For multi-cpu systems, you'll definitely see multiple GIC redistributors.

Yes, you are right, thanks for pointing it out, I think I need more coffee :)

Thanks
Hanjun

