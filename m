Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaEZWIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:08:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49960 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaEZWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:08:31 -0400
Message-ID: <5383BB55.9070606@samsung.com>
Date: Tue, 27 May 2014 07:08:21 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Heiko Stuebner <heiko@sntech.de>,
        linux-doc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Romain Naour <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v11 0/3] Exynos 5410 support
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com> <53832157.2020502@gmail.com>
In-Reply-To: <53832157.2020502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/14 20:11, Tomasz Figa wrote:
> Hi,
>
Hi

> On 26.05.2014 05:23, Tarek Dakhran wrote:
>> The series of patches represent support of Exynos 5410 SoC
>>
>> The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture
>>
>> Patches add new platform description, support of clock controller and device
>> tree for Exynos 5410.
>>
>> Has been build on Samsung Linux Kernel
>>    (branch: for-next, commit: 97eae6c Merge branch 'v3.16-next/multiplatform' into for-next)
>>
>> Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
>> 		    2) Exynos 5410 reference board (multi_v7_defconfig)
>> 		    3) Odroid-XU board (exynos_defconfig)
>> 		    4) Odroid-XU board (multi_v7_defconfig)
>>
Thanks for your test with exynos_defconfig and multi_v7_defconfig.

>> I hope this is clean and would be applied.
>>
>> Tarek.
>>
>> Tarek Dakhran (3):
>>    ARM: EXYNOS: Add support for EXYNOS5410 SoC
>>    clk: exynos5410: register clocks using common clock framework
>>    ARM: dts: Add initial device tree support for EXYNOS5410
>>
>>   .../devicetree/bindings/clock/exynos5410-clock.txt |   45 +++++
>>   arch/arm/boot/dts/Makefile                         |    1 +
>>   arch/arm/boot/dts/exynos5410-smdk5410.dts          |   82 ++++++++
>>   arch/arm/boot/dts/exynos5410.dtsi                  |  206 +++++++++++++++++++
>>   arch/arm/mach-exynos/Kconfig                       |    5 +
>>   arch/arm/mach-exynos/common.h                      |   12 +-
>>   drivers/clk/samsung/Makefile                       |    1 +
>>   drivers/clk/samsung/clk-exynos5410.c               |  209 ++++++++++++++++++++
>>   include/dt-bindings/clock/exynos5410.h             |   33 ++++
>>   9 files changed, 592 insertions(+), 2 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>   create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>>   create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>>   create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>>   create mode 100644 include/dt-bindings/clock/exynos5410.h
>>
>
> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>
Applied this whole series.

Thanks,
Kukjin
