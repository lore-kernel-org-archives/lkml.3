Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3LBOfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:35:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:15930 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3LBOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:35:22 -0500
Message-ID: <529C9A9F.6080407@atmel.com>
Date: Mon, 2 Dec 2013 15:35:11 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] ARM: at91: use new at91 clks for samad3 SoCs
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/2013 15:49, Boris BREZILLON :
> Hello,
>
> This patch series moves sama5d3 SoCs and boards to the new at91 clk framework
> (based on common clk framework).
>
> Best Regards,

Whole series:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and added on top of CCF one for at91-3.14-cleanup

Bye,

> Boris
>
> Changes since v3:
>   - fix prog clks declaration
>
> Changes since v2:
>   - rework dt bindings:
>     * replace "atmel,clk-id" property by the standard "reg" property
>     * reference system, peripheral and programmable clks using the direct
>       clk node instead of the parent node plus a clk id
>   - add usb_clk to usb ehci controller node
>
> Changes since v1:
>   - remove references to peripheral id macros
>   - remove old clk definitions after moving to new clk framework
>
> Boris BREZILLON (6):
>    ARM: at91: prepare sama5 dt boards transition to common clk
>    ARM: at91: prepare common clk transition for sama5d3 SoC
>    ARM: at91/dt: define sama5d3 clocks
>    ARM: at91/dt: define sama5d3xek's main clk frequency
>    ARM: at91: move sama5d3 SoC to common clk
>    ARM: at91/dt: remove old clk material
>
>   arch/arm/boot/dts/sama5d3.dtsi      |  379 ++++++++++++++++++++++++++++++++++-
>   arch/arm/boot/dts/sama5d3_can.dtsi  |   20 ++
>   arch/arm/boot/dts/sama5d3_emac.dtsi |   11 +
>   arch/arm/boot/dts/sama5d3_gmac.dtsi |   11 +
>   arch/arm/boot/dts/sama5d3_lcd.dtsi  |   17 ++
>   arch/arm/boot/dts/sama5d3_mci2.dtsi |   12 ++
>   arch/arm/boot/dts/sama5d3_tcb1.dtsi |   12 ++
>   arch/arm/boot/dts/sama5d3_uart.dtsi |   21 ++
>   arch/arm/boot/dts/sama5d3xcm.dtsi   |   17 +-
>   arch/arm/mach-at91/Kconfig          |    1 -
>   arch/arm/mach-at91/board-dt-sama5.c |   10 +-
>   arch/arm/mach-at91/sama5d3.c        |  342 -------------------------------
>   12 files changed, 497 insertions(+), 356 deletions(-)
>


-- 
Nicolas Ferre
