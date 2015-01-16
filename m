Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbbAPLz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:55:29 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64877 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbAPLz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:55:27 -0500
MIME-Version: 1.0
In-Reply-To: <20150116104842.GE21809@leverpostej>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1421402411-3479-5-git-send-email-chunyan.zhang@spreadtrum.com>
	<20150116104842.GE21809@leverpostej>
Date: Fri, 16 Jan 2015 19:50:18 +0800
Message-ID: <CAAfSe-vuSgwH2PHQdYLyfJ+KZ0C8a7D6Ry=mHaBrjpbuksaKvQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] arm64: Add support for Spreadtrum's Sharkl64
 Platform in Kconfig and defconfig
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        "Joel.Schopp@amd.com" <Joel.Schopp@amd.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "jorge.ramirez-ortiz@linaro.org" <jorge.ramirez-ortiz@linaro.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark

On Fri, Jan 16, 2015 at 6:48 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jan 16, 2015 at 10:00:10AM +0000, Chunyan Zhang wrote:
>> From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
>>
>> Adds support for Spreadtrum's SoC Platform in the arm64 Kconfig and
>> defconfig files.
>>
>> Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
>> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
>> ---
>>  arch/arm64/Kconfig           |    5 +++++
>>  arch/arm64/configs/defconfig |    1 +
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index b1f9a20..885c1f4 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -153,6 +153,11 @@ config ARCH_SEATTLE
>>       help
>>         This enables support for AMD Seattle SOC Family
>>
>> +config ARCH_SPRD
>
> This should presumably be ARCH_SHARKL64, so you can add other SoC
> families later. The other entries in here are already formatted that
> way.
>
> I wonder if we should have these of the form ARCH_${VENDOR}_${FAMILY}
> (e.g. ARCH_SPRD_SHARKL64) rather than just ARCH_${FAMILY} to save
> ourselves from name conflicts in future (and to make it easier to grep
> for a particular vendor's config options).
>

actually we've discussed this question before[1], and I think Arnd's
suggestion is suitable for our case, so I changed this to use
ARCH_SPRD instead of ARCH_SHARKL64.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/306246.html

anyway, thank you very much!

Chunyan

>> +     bool "Spreadtrum SoC platform"
>
> bool "Spreadtrun Sharkl64 SoC Family"
>
>> +     help
>> +       Support for Spreadtrum ARM based SoCs
>
>
> Support for the Spreadtrum Sharkl64 SoC family.
>
> Thanks,
> Mark.
>
>> +
