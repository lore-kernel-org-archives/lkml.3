Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3LJHTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:19:02 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37354 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3LJHS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:18:58 -0500
MIME-Version: 1.0
In-Reply-To: <1386271244-3927-2-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
	<1386271244-3927-2-git-send-email-tim.kryger@linaro.org>
Date: Mon, 9 Dec 2013 23:18:56 -0800
Message-ID: <CAEPRUYrw_owwBYEmmXO3=OG9pXrKPrJTwF+jPVm4+-Vvf0Xorw@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] ARM: dts: Declare clocks as fixed on bcm11351
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to armsoc/for-3.14/dt

 thanks,
   csd


On Thu, Dec 5, 2013 at 11:20 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> Declare clocks that are enabled and configured by bootloaders as fixed
> rate clocks in the DTS such that device drivers may use standard clock
> function calls.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
>  arch/arm/boot/dts/bcm11351.dtsi | 97 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
>
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index b0c0610..eca6fbc 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -142,4 +142,101 @@
>                 status = "disabled";
>         };
>
> +       clocks {
> +               bsc1_clk: bsc1 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               bsc2_clk: bsc2 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               bsc3_clk: bsc3 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               pmu_bsc_clk: pmu_bsc {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               hub_timer_clk: hub_timer {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <32768>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               pwm_clk: pwm {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <26000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               sdio1_clk: sdio1 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <48000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               sdio2_clk: sdio2 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <48000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               sdio3_clk: sdio3 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <48000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               sdio4_clk: sdio4 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <48000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               tmon_1m_clk: tmon_1m {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <1000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               uartb_clk: uartb {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               uartb2_clk: uartb2 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               uartb3_clk: uartb3 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               uartb4_clk: uartb4 {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <13000000>;
> +                       #clock-cells = <0>;
> +               };
> +
> +               usb_otg_ahb_clk: usb_otg_ahb {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <52000000>;
> +                       #clock-cells = <0>;
> +               };
> +       };
>  };
> --
> 1.8.0.1
>
