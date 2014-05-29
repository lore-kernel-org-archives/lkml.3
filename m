Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbaE2NSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:18:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46020 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079AbaE2NR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:17:58 -0400
Message-ID: <53873353.9010609@ti.com>
Date: Thu, 29 May 2014 18:47:07 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <tony@atomide.com>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Kumar Gala'" <galak@codeaurora.org>
Subject: Re: [PATCH v2 16/18] ARM: OMAP: Enable PCI for DRA7
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-17-git-send-email-kishon@ti.com> <000601cf7b0a$0fbce200$2f36a600$%han@samsung.com>
In-Reply-To: <000601cf7b0a$0fbce200$2f36a600$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 29 May 2014 12:18 PM, Jingoo Han wrote:
> On Thursday, May 29, 2014 3:38 PM, Kishon Vijay Abraham I wrote:
>>
>> Now that we have added PCIe driver for DRA7 SOCs, enable PCI on
>> DRA7 SOCs.
>>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  arch/arm/mach-omap2/Kconfig |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
>> index cb31d43..b179e80 100644
>> --- a/arch/arm/mach-omap2/Kconfig
>> +++ b/arch/arm/mach-omap2/Kconfig
>> @@ -75,6 +75,8 @@ config SOC_DRA7XX
>>  	select ARM_GIC
>>  	select HAVE_ARM_ARCH_TIMER
>>  	select IRQ_CROSSBAR
>> +	select MIGHT_HAVE_PCI
>> +	select ARCH_SUPPORTS_MSI
> 
> Hi Kishon,
> 
> Please, don't select ARCH_SUPPORTS_MSI, because this kconfig
> option was already removed in v3.12 by the commit ebd97be635
> ('PCI: remove ARCH_SUPPORTS_MSI kconfig option'). So, there is
> NO need to select 'ARCH_SUPPORTS_MSI'.

Thanks for spotting it. Will remove it.

Thanks
Kishon
