Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaIZIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:16:56 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:45507 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaIZIQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:16:51 -0400
MIME-Version: 1.0
In-Reply-To: <1411662520-22795-14-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
	<1411662520-22795-14-git-send-email-geert+renesas@glider.be>
Date: Fri, 26 Sep 2014 10:16:48 +0200
X-Google-Sender-Auth: j8imj3k4S7Tiq9wiWRVP3kzCngE
Message-ID: <CAMuHMdWa_TDz6EyeXGDo-WGJyr15mhA4fH6r45hz8joNdkBbeQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] ARM: shmobile: r8a7740 dtsi: Add preliminary PM
 QoS device latencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:28 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
> index ed0adeb61a1ad8ec..713170442b7bd4b2 100644
> --- a/arch/arm/boot/dts/r8a7740.dtsi
> +++ b/arch/arm/boot/dts/r8a7740.dtsi

> @@ -409,6 +509,10 @@
>                         reg = <0xe6150000 0x10000>;
>                         clocks = <&extal1_clk>, <&extalr_clk>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <1>;
>                         clock-output-names = "system", "pllc0", "pllc1",
>                                              "pllc2", "r",
> @@ -424,6 +528,10 @@
>                         reg = <0xe6150080 4>;
>                         clocks = <&pllc1_div2_clk>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <0>;
>                         clock-output-names = "sub";
>                 };
> @@ -433,6 +541,10 @@
>                         compatible = "fixed-factor-clock";
>                         clocks = <&cpg_clocks R8A7740_CLK_PLLC1>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <0>;
>                         clock-div = <2>;
>                         clock-mult = <1>;
> @@ -442,6 +554,10 @@
>                         compatible = "fixed-factor-clock";
>                         clocks = <&extal1_clk>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <0>;
>                         clock-div = <2>;
>                         clock-mult = <1>;
> @@ -454,6 +570,10 @@
>                         reg = <0xe6150080 4>;
>                         clocks = <&sub_clk>, <&sub_clk>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_SUBCK R8A7740_CLK_SUBCK2
> @@ -470,6 +590,10 @@
>                                  <&sub_clk>, <&sub_clk>,
>                                  <&cpg_clocks R8A7740_CLK_B>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_CEU21 R8A7740_CLK_CEU20 R8A7740_CLK_TMU0
> @@ -492,6 +616,10 @@
>                                  <&sub_clk>, <&sub_clk>, <&sub_clk>,
>                                  <&sub_clk>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_SCIFA6 R8A7740_CLK_INTCA
> @@ -522,6 +650,10 @@
>                                  <&cpg_clocks R8A7740_CLK_HP>,
>                                  <&cpg_clocks R8A7740_CLK_HP>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_CMT1 R8A7740_CLK_FSI R8A7740_CLK_IIC1
> @@ -540,6 +672,10 @@
>                                  <&cpg_clocks R8A7740_CLK_HP>,
>                                  <&cpg_clocks R8A7740_CLK_HP>;
>                         power-domains = <&pd_c5>;
> +                       stop-latency = <250000>;
> +                       start-latency = <250000>;
> +                       save-state-latency = <250000>;
> +                       restore-state-latency = <250000>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_USBH R8A7740_CLK_SDHI2

Same here, as there should be no power-domains properties in the clocks
nodes, there should be no latencies specified neither.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
