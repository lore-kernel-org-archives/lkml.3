Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbaLBLxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:53:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60314 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaLBLw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:52:59 -0500
X-AuditID: cbfee68f-f791c6d000004834-21-547da8188380
Message-id: <547DA818.2050908@samsung.com>
Date: Tue, 02 Dec 2014 20:52:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
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
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-15-git-send-email-cw00.choi@samsung.com>
 <20141202110909.GB23671@leverpostej>
In-reply-to: <20141202110909.GB23671@leverpostej>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkSFdiRW2IwaM3ZhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWmx5fY7W4vGsOm8WM
	8/uAWu/8Y7NYev0ik8Wp65/ZLBZt/cJucfhNO6vFjMkv2SxW7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZZy4sZS6YGVhx
	+HNuA+NO0y5GTg4JAROJi1c/sELYYhIX7q1n62Lk4hASWMooMX3lXyaYonPXOlggEtMZJd7f
	mgHlvGaUmDptLSNIFa+AlsSVSe/BOlgEVCUuHF7EDmKzAcX3v7jBBmKLCoRJrJx+hQWiXlDi
	x+R7YLaIgLpEz64vYEOZBZZxSLw8/BWsQVggQuLBzytMENuWM0rMuTOPGSTBKWAocbb5H9g2
	ZgEdif2t09ggbHmJzWveMkPcfYBDYvHtIoiLBCS+TT4EtIEDKC4rsekAVImkxMEVN1gmMIrN
	QnLTLCRTZyGZuoCReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYFI4/e9Z/w7GuwesDzEK
	cDAq8fCeOF8TIsSaWFZcmXuI0RToionMUqLJ+cDUk1cSb2hsZmRhamJqbGRuaaYkzrtQ6mew
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkaWrxxp0U5zt+ju4xKbIrvh9+qHT7/d0eO8YFMV
	0sydML347KPXq+4ktR3+22gYPNfMq8l6+dECsdf2EgfD4s+zfRWy7HrZMY/xTsJyVl1d80XV
	2xaUyU/6GSh8tu2m6lWNx5u+tjC47DpxKFI62+b82+dL54cIOxzmCtgt7KHXeOfm+0Pp3FuU
	WIozEg21mIuKEwFA3ZprBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQV2JFbUhBpf3alk8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYz
	zu8Dar3zj81i6fWLTBanrn9ms1i09Qu7xeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzDhzYSlzwczAisOfcxsYd5p2MXJySAiYSJy71sECYYtJXLi3nq2LkYtD
	SGA6o8T7WzNYIJzXjBJTp61lBKniFdCSuDLpPROIzSKgKnHh8CJ2EJsNKL7/xQ02EFtUIExi
	5fQrLBD1ghI/Jt8Ds0UE1CV6dn0BG8ossIxD4uXhr2ANwgIREg9+XmGC2LacUWLOnXnMIAlO
	AUOJs83/wLYxC+hI7G+dxgZhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHUguSC4qT0XEO9
	4sTc4tK8dL3k/NxNjOCk80xqB+PKBotDjAIcjEo8vCfO14QIsSaWFVfmHmKU4GBWEuH9ZVwb
	IsSbklhZlVqUH19UmpNafIjRFBgGE5mlRJPzgQkxryTe0NjEzMjSyNzQwsjYXEmc98bN3BAh
	gfTEktTs1NSC1CKYPiYOTqkGRo1AQfvVpWXbpm1dvnOLzmM2B4OwvbfbHgt7fLhWa78/95oV
	a9PEsMzPrTKqFXsmJ61Zuk2RcUvIIRm9A1kTj5UGbM/JK3bX7uzT/6pv+693lRnjNN4FLdn3
	n6r3/pad6PpOtfdi6vcJZ+Y2Viy1ef4/cLWE0Rn+hZk+bHHNb/jTvu0Uub1VX4mlOCPRUIu5
	qDgRAFlVMh5QAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark,

On 12/02/2014 08:09 PM, Mark Rutland wrote:
> Hi,
> 
> On Tue, Dec 02, 2014 at 08:49:51AM +0000, Chanwoo Choi wrote:
>> This patch adds new Exynos5433 dtsi to support 64-bit Exynos5433 SoC based on
>> Octal core CPUs (quad Cortex-A57 and quad Cortex-A53). And Exynos5433 supports
>> PSCI (Power State Coordination Interface) v0.1.
>>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>  arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi | 698 +++++++++++++++++++++
>>  arch/arm64/boot/dts/exynos/exynos5433.dtsi         | 515 +++++++++++++++
>>  2 files changed, 1213 insertions(+)
>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433-pinctrl.dtsi
>>  create mode 100644 arch/arm64/boot/dts/exynos/exynos5433.dtsi
> 
> [...]
> 
>> +       cpus {
>> +               #address-cells = <1>;
>> +               #size-cells = <0>;
>> +
>> +               cpu0: cpu@100 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a53", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x100>;
>> +               };
>> +
>> +               cpu1: cpu@101 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a53", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x101>;
>> +               };
>> +
>> +               cpu2: cpu@102 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a53", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x0 0x102>;
>> +               };
>> +
>> +               cpu3: cpu@103 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a53", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x103>;
>> +               };
>> +
>> +               cpu4: cpu@0 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a57", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x0>;
>> +               };
>> +
>> +               cpu5: cpu@1 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a57", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x1>;
>> +               };
>> +
>> +               cpu6: cpu@2 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a57", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x2>;
>> +               };
>> +
>> +               cpu7: cpu@3 {
>> +                       device_type = "cpu";
>> +                       compatible = "arm,cortex-a57", "arm,armv8";
>> +                       enable-method = "psci";
>> +                       reg = <0x3>;
>> +               };
>> +       };
>> +
>> +       psci {
>> +               compatible = "arm,psci";
>> +               method = "smc";
>> +               cpu_off = <0x84000002>;
>> +               cpu_on = <0xC4000003>;
>> +       };
> 
> Given your comments on the latest posting, has CPU_OFF been tested, and
> does it work for _all_ CPUs (including CPU0)?

At current version,
CPU_OFF of Exynos5433 is not working. I'm now working to find the cause of CPU_OFF fail.
(I got CPU_ON of Exynos5433 all cores.)

> 
>> +
>> +       soc: soc {
>> +               compatible = "simple-bus";
>> +               #address-cells = <1>;
>> +               #size-cells = <1>;
>> +               ranges;
> 
> Is that valid when changing the number of cells? The address spaces
> aren't strictly identical in that case, and I'd expect a translation
> something like:
> 
>         ranges = <0x0 0x0 0x0 0xff000000>;

I'll fix it after checking correct spec.

> 
> Where the final cell is a sufficiently large value to cover all
> addresses in the soc node.
> 
> [...]
> 
>> +               gic:interrupt-controller@11001000 {
>> +                       compatible = "arm,gic-400";
>> +                       #interrupt-cells = <3>;
>> +                       interrupt-controller;
>> +                       reg =   <0x11001000 0x1000>,
>> +                               <0x11002000 0x1000>,
>> +                               <0x11004000 0x2000>,
>> +                               <0x11006000 0x2000>;
>> +                       interrupts = <1 9 0xf04>;
>> +               };
> 
> The GICC needs to be 0x2000 long to map the GICC_DIR, which is at
> 0x1000-0x1003.

Do you mean that following dt node is right for gic-400?

		reg =   <0x11001000 0x1000>,
			<0x11002000 0x2000>,	<- I changed the the range of GICC.
			<0x11004000 0x2000>,
			<0x11006000 0x2000>;

> 
> [...]
> 
>> +               pinctrl_alive: pinctrl@10580000 {
>> +                       compatible = "samsung,exynos5433-pinctrl";
>> +                       reg = <0x10580000 0x1000>;
>> +
>> +                       wakeup-interrupt-controller {
>> +                               compatible = "samsung,exynos7-wakeup-eint";
>> +                               interrupts = <0 16 0>;
>> +                       };
>> +               };
> 
> How exactly does the wakeup interrupt controller interact with the GIC?
> Surely the relationship between the two should be described?

The pinctrl_alive contains the alive part of GPIO PAD (gpa0~gpa3).

The each GPA0/GPA1 of pinctrl_alive pad did map to unique SPI number of GIC
amd GPA2/GPA3 use only one interrupt (SPI[16])  as following:

	+&pinctrl_alive {
	+	gpa0: gpa0 {
	+		gpio-controller;
	+		#gpio-cells = <2>;
	+
	+		interrupt-controller;
	+		interrupt-parent = <&gic>;
	+		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
	+			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>;
	+		#interrupt-cells = <2>;
	+	};
	+
	+	gpa1: gpa1 {
	+		gpio-controller;
	+		#gpio-cells = <2>;
	+
	+		interrupt-controller;
	+		interrupt-parent = <&gic>;
	+		interrupts = <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
	+			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>;
	+		#interrupt-cells = <2>;
	+	};

	gpa0-0 - SPI[0]
	gpa0-1 - SPI[1]
	gpa0-2 - SPI[2]
	gpa0-3 - SPI[3]
	gpa0-4 - SPI[4]
	gpa0-5 - SPI[5]
	gpa0-6 - SPI[6]
	gpa0-7 - SPI[7]

	gpa1-0 - SPI[8]
	gpa1-1 - SPI[9]
	gpa1-2 - SPI[10]
	gpa1-3 - SPI[11]
	gpa1-4 - SPI[12]
	gpa1-5 - SPI[13]
	gpa1-6 - SPI[14]
	gpa1-7 - SPI[15]

	GPA2/GPA3 use only one interrupt (SPI[16]).

The pinctrl-exynos.c driver initialized external wakeup interrupt
(e.g., GPA0/GPA1/GPA2/GPA3 of Exynos5433) in exynos_eint_wkup_init() function.

Following patch[1] adds the control for Exynos5433 wakeup irq.The exynos5433_pin_ctrl structure
includes '.eint_wkup_init = exynos_eint_wkup_init;' fields to handle wakeup interrupt of Exynos SoC.

[PATCHv2] pinctrl: exynos: Add support for Exynos543
- https://lkml.org/lkml/2014/12/2/207

	+struct samsung_pin_ctrl exynos5433_pin_ctrl[] = {
	+	{
	+		/* pin-controller instance 0 data */
	+		.pin_banks	= exynos5433_pin_banks0,
	+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks0),
	+		.eint_wkup_init = exynos_eint_wkup_init,
	+		.suspend	= exynos_pinctrl_suspend,
	+		.resume		= exynos_pinctrl_resume,
	+		.label		= "exynos5433-gpio-ctrl0",
	+	}, {

And,
'struct exynos_irq_chip exynos7_wkup_irq_chip' handles the external interrupt of Exynos5433 SoC
because Exynos5433 is the same with Exynos7 EINT (External Interrupt) register offset.

We can check it following patch[1] to control wakeup interrupt for Exynos7/Exynos5433.
- [1] [patch] pinctrl: exynos: Add irq_chip instance for Exynos7 wakeup interrupts
  https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-pinctrl.git/commit/?h=for-next&id=14c255d35b25126149fb2fd199b030404229af65


	+static struct exynos_irq_chip exynos7_wkup_irq_chip __initdata = {
	+ .chip = {
	+ .name = "exynos7_wkup_irq_chip",
	+ .irq_unmask = exynos_irq_unmask,
	+ .irq_mask = exynos_irq_mask,
	+ .irq_ack = exynos_irq_ack,
	+ .irq_set_type = exynos_irq_set_type,
	+ .irq_set_wake = exynos_wkup_irq_set_wake,
	+ .irq_request_resources = exynos_irq_request_resources,
	+ .irq_release_resources = exynos_irq_release_resources,
	+ },
	+ .eint_con = EXYNOS7_WKUP_ECON_OFFSET,
	+ .eint_mask = EXYNOS7_WKUP_EMASK_OFFSET,
	+ .eint_pend = EXYNOS7_WKUP_EPEND_OFFSET,
	+};

If happen external interrupt by pressing power button, the ops of 'struct exynos_irq_chip exynos7_wkup_irq_chip'
would handle the interrupt.

For exampl, If I use following GPAx as interrupt, I can check it on the result of /proc/interrupts.
	gpa2-7 - power key
	gpa2-0 - volume-up key
	gpa2-1 - volume-up key
	gpa0-7 - s2mps13 pmic irq

'exynos7_wkup_irq_chip' would handle the external interrupt(gpa).

#cat /proc/interrupts
  1:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   0  volume-up key
  2:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   1  volume-down key
  7:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   7  s2mps13
  8:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   7  power key


IMHO,
Happen SPI -> GIC -> Cortex-A57/Cortex-A53 -> pinctrl-exynos.c -> exynos7_wkup_irq_chip -> irq handling

Best Regards,
Chanwoo Choi

> 
> Is it a subcomponent of the pincontrol block?
> 
> Thanks,
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

