Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaLBLJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:09:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36463 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbaLBLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:09:12 -0500
Date: Tue, 2 Dec 2014 11:09:09 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "olof@lixom.net" <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 14/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
Message-ID: <20141202110909.GB23671@leverpostej>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-15-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417510196-6714-15-git-send-email-cw00.choi@samsung.com>
Thread-Topic: [PATCH 14/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 02, 2014 at 08:49:51AM +0000, Chanwoo Choi wrote:
> This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC based on
> Octal core CPUs (quad Cortex-A57 and quad Cortex-A53). And Exynos5433 supports
> PSCI (Power State Coordination Interface) v0.1.
>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
>  arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 515 +++++++++++++++
>  2 files changed, 1213 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi

[...]

> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               cpu0: cpu@100 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a53", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x100>;
> +               };
> +
> +               cpu1: cpu@101 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a53", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x101>;
> +               };
> +
> +               cpu2: cpu@102 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a53", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x0 0x102>;
> +               };
> +
> +               cpu3: cpu@103 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a53", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x103>;
> +               };
> +
> +               cpu4: cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x0>;
> +               };
> +
> +               cpu5: cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x1>;
> +               };
> +
> +               cpu6: cpu@2 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x2>;
> +               };
> +
> +               cpu7: cpu@3 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57", "arm,armv8";
> +                       enable-method = "psci";
> +                       reg = <0x3>;
> +               };
> +       };
> +
> +       psci {
> +               compatible = "arm,psci";
> +               method = "smc";
> +               cpu_off = <0x84000002>;
> +               cpu_on = <0xC4000003>;
> +       };

Given your comments on the latest posting, has CPU_OFF been tested, and
does it work for _all_ CPUs (including CPU0)?

> +
> +       soc: soc {
> +               compatible = "simple-bus";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;

Is that valid when changing the number of cells? The address spaces
aren't strictly identical in that case, and I'd expect a translation
something like:

        ranges = <0x0 0x0 0x0 0xff000000>;

Where the final cell is a sufficiently large value to cover all
addresses in the soc node.

[...]

> +               gic:interrupt-controller@11001000 {
> +                       compatible = "arm,gic-400";
> +                       #interrupt-cells = <3>;
> +                       interrupt-controller;
> +                       reg =   <0x11001000 0x1000>,
> +                               <0x11002000 0x1000>,
> +                               <0x11004000 0x2000>,
> +                               <0x11006000 0x2000>;
> +                       interrupts = <1 9 0xf04>;
> +               };

The GICC needs to be 0x2000 long to map the GICC_DIR, which is at
0x1000-0x1003.

[...]

> +               pinctrl_alive: pinctrl@10580000 {
> +                       compatible = "samsung,exynos5433-pinctrl";
> +                       reg = <0x10580000 0x1000>;
> +
> +                       wakeup-interrupt-controller {
> +                               compatible = "samsung,exynos7-wakeup-eint";
> +                               interrupts = <0 16 0>;
> +                       };
> +               };

How exactly does the wakeup interrupt controller interact with the GIC?
Surely the relationship between the two should be described?

Is it a subcomponent of the pincontrol block?

Thanks,
Mark.
