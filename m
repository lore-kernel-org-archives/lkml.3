Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaEZLL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:11:29 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62388 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaEZLL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:11:27 -0400
Message-ID: <53832157.2020502@gmail.com>
Date: Mon, 26 May 2014 13:11:19 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v11 0/3] Exynos 5410 support
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
In-Reply-To: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26.05.2014 05:23, Tarek Dakhran wrote:
> The series of patches represent support of Exynos 5410 SoC
> 
> The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture
> 
> Patches add new platform description, support of clock controller and device
> tree for Exynos 5410.
> 
> Has been build on Samsung Linux Kernel
>   (branch: for-next, commit: 97eae6c Merge branch 'v3.16-next/multiplatform' into for-next)
> 
> Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
> 		    2) Exynos 5410 reference board (multi_v7_defconfig)
> 		    3) Odroid-XU board (exynos_defconfig)
> 		    4) Odroid-XU board (multi_v7_defconfig)
> 
> I hope this is clean and would be applied.
> 
> Tarek.
> 
> Tarek Dakhran (3):
>   ARM: EXYNOS: Add support for EXYNOS5410 SoC
>   clk: exynos5410: register clocks using common clock framework
>   ARM: dts: Add initial device tree support for EXYNOS5410
> 
>  .../devicetree/bindings/clock/exynos5410-clock.txt |   45 +++++
>  arch/arm/boot/dts/Makefile                         |    1 +
>  arch/arm/boot/dts/exynos5410-smdk5410.dts          |   82 ++++++++
>  arch/arm/boot/dts/exynos5410.dtsi                  |  206 +++++++++++++++++++
>  arch/arm/mach-exynos/Kconfig                       |    5 +
>  arch/arm/mach-exynos/common.h                      |   12 +-
>  drivers/clk/samsung/Makefile                       |    1 +
>  drivers/clk/samsung/clk-exynos5410.c               |  209 ++++++++++++++++++++
>  include/dt-bindings/clock/exynos5410.h             |   33 ++++
>  9 files changed, 592 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>  create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>  create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>  create mode 100644 include/dt-bindings/clock/exynos5410.h
> 

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
