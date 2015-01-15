Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbbAOTAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:00:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbbAOTAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:00:21 -0500
Message-ID: <54B80DE4.5060902@redhat.com>
Date: Thu, 15 Jan 2015 13:58:44 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, wangyijing@huawei.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 10:04 AM, Hanjun Guo wrote:
> Hi,
> 
> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
> 
> updates from v6:
>   - Rebased on top of 3.19-rc4, add Mack Salter's patch to use
>     the early_ioremap after paging_init() for ACPI table mappings;
> 
>   - Two patches about converting apic_id to phys_id to make it arch
>     agnostic were already merged into RC4 by Rafael.
> 
>   - Split patch "Parse FADT table to get PSCI flags for PSCI init"
>     into two as Lorenzo's suggestion, also fix typo and lack of __init
>     for psci_0_2_set_functions() which is spotted by Lorenzo.
> 
>   - Add Tested-by from Yijing Wang.
> 
> previous version is here:
> v6: https://lkml.org/lkml/2015/1/4/40
> 
> 1. Why we need ACPI on ARM64?
> 
>   - Grant already posted a blog about this, and stated clearly
>     why we need ACPI on ARM64:
> 
>     http://www.secretlab.ca/archives/151
> 
> 
> 2. What we need to do before the arm64 ACPI core patches
>    could be merged into the kernel?
> 
>   - Al Stone posted a TODO list and updates v2 for the
>     progress we made:
>     http://www.spinics.net/lists/arm-kernel/msg390069.html
> 
>   - so from the progress we can see that we already finished
>     most of the items, and _OSI we got a plan to fix it, RFC
>     patch is on the way.
> 
> 
> This patch set was tested on FVP by Fuwei, and booted ok as expected.
> (No functional change since last version)

For the entire series:

Tested-by: Jon Masters <jcm@redhat.com>


