Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaIIGW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:22:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaIIGW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:22:27 -0400
Message-ID: <540E9C60.4090103@redhat.com>
Date: Tue, 09 Sep 2014 02:21:20 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>
CC: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-14-git-send-email-hanjun.guo@linaro.org> <5404AE56.80801@arm.com> <5405AE95.1020201@linaro.org> <5405BFE7.5060005@arm.com> <5405E626.4090306@linaro.org> <5406EDDC.3020208@arm.com>
In-Reply-To: <5406EDDC.3020208@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 06:30 AM, Marc Zyngier wrote:
> On 02/09/14 16:45, Hanjun Guo wrote:

>> This value is for max processors entries in MADT, and we will use it to scan MADT
>> for SMP/GIC Init, I just make it big enough for GICv3/4. since ACPI core will stop
>> scan MADT if the real numbers of processors entries are reached no matter
>> how big ACPI_MAX_GICV3_CPU_INTERFACE_ENTRIES is, I think we can just
>> define a number big enough then it will work (x86 and ia64 did the same thing).
> 
> Also, with GICv3++, there is no such thing as a memory-mapped CPU
> interface anymore. What you get is a bunch of redistributors (one per
> CPU). I assume what you have here actually describe the redistributors,
> and its name should reflect that.

(though you could have a GICv3/v4 system providing a legacy GICv2(m)
compatibility mode having the CPU memory interfaces still defined)

Jon.

