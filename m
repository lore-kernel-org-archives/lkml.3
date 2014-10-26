Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaJZMnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 08:43:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaJZMnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 08:43:13 -0400
Message-ID: <544CEC5B.4020104@suse.de>
Date: Sun, 26 Oct 2014 13:43:07 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: suravee.suthikulpanit@amd.com, mark.rutland@arm.com,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, marc.zyngier@arm.com,
        catalin.marinas@arm.com, liviu.dudau@arm.com,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        will.deacon@arm.com, Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com> <544C2D67.8000405@suse.de>
In-Reply-To: <544C2D67.8000405@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.10.2014 um 01:08 schrieb Alexander Graf:
> On 24.10.14 14:20, suravee.suthikulpanit@amd.com wrote:
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 48b7437..e4c052f 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -137,6 +137,11 @@ source "kernel/Kconfig.freezer"
>>  
>>  menu "Platform selection"
>>  
>> +config ARCH_SEATTLE
>> +	bool "AMD Seattle SoC Family"
>> +	help
>> +	  This enables support for AMD Seattle SOC Family
>> +
>>  config ARCH_THUNDER
>>  	bool "Cavium Inc. Thunder SoC Family"
>>  	help
>> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
>> index f8001a6..6c27047 100644
>> --- a/arch/arm64/boot/dts/Makefile
>> +++ b/arch/arm64/boot/dts/Makefile
>> @@ -1,6 +1,7 @@
>>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
> 
> This option doesn't exist in upstream kernels, does it? Why not just
> make it dtb-y?

CONFIG_ARCH_SEATTLE is being added one hunk above. :)

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
