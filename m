Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaJZOIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:08:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaJZOIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:08:50 -0400
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle platform
From: Alexander Graf <agraf@suse.de>
X-Mailer: iPhone Mail (12A405)
In-Reply-To: <544CEC5B.4020104@suse.de>
Date: Sun, 26 Oct 2014 15:08:45 +0100
Cc: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A1BC53C1-A78E-4B0C-879B-F6A462E58C72@suse.de>
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com> <544C2D67.8000405@suse.de> <544CEC5B.4020104@suse.de>
To: =?utf-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Am 26.10.2014 um 13:43 schrieb Andreas Färber <afaerber@suse.de>:
> 
>> Am 26.10.2014 um 01:08 schrieb Alexander Graf:
>>> On 24.10.14 14:20, suravee.suthikulpanit@amd.com wrote:
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index 48b7437..e4c052f 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -137,6 +137,11 @@ source "kernel/Kconfig.freezer"
>>> 
>>> menu "Platform selection"
>>> 
>>> +config ARCH_SEATTLE
>>> +    bool "AMD Seattle SoC Family"
>>> +    help
>>> +      This enables support for AMD Seattle SOC Family
>>> +
>>> config ARCH_THUNDER
>>>    bool "Cavium Inc. Thunder SoC Family"
>>>    help
>>> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
>>> index f8001a6..6c27047 100644
>>> --- a/arch/arm64/boot/dts/Makefile
>>> +++ b/arch/arm64/boot/dts/Makefile
>>> @@ -1,6 +1,7 @@
>>> dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>>> dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>>> dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>>> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
>> 
>> This option doesn't exist in upstream kernels, does it? Why not just
>> make it dtb-y?
> 
> CONFIG_ARCH_SEATTLE is being added one hunk above. :)

Oops :).

I'm not convinced we need a config option just for the sake of compiling a device tree though.


Alex

