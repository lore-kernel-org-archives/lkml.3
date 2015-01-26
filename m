Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbbAZO1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:27:34 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52244 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbbAZO1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <1421054073-43468-1-git-send-email-eddie.huang@mediatek.com>
References: <1421054073-43468-1-git-send-email-eddie.huang@mediatek.com>
Date: Mon, 26 Jan 2015 15:27:29 +0100
Message-ID: <CABuKBeKjGL6puqhqCb6b4=5Qb9+hcm-sGQ7vLxyb2jAFaLYGUQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Add basic support for Mediatek MT8173 SoC
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Yu-hau Chen <yh.chen@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-12 10:14 GMT+01:00 Eddie Huang <eddie.huang@mediatek.com>:
> MT8173 is a SoC based on 64bit ARMv8 architecture. It contains 2 CA53 + 2 CA57 cores.
> MT8173 share many HW IP with MT8135 and other MT65xx series. This patchset was tested
> on MT8173 engineer sample, and boot to shell ok.
>
> This series contains document bindings, device tree, defconfig, and one sysirq
> modification for MT8173.
>
> Changes in v4:
> 1. Add sysirq, uart binding documents.
> 2. Disable UART in mt8173.dtsi, enable needed UART in mt8173-evb.dtsi
>
> This patch base on 3.19-rc1, Joe's sysirq patch [1] and test boot to shell with
> Catalin Marinas's arch_timer virtual counter patch [2]
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310335.html
> [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/309856.html

Applied to v3.20-next/arm64.
Thanks.

>
> Eddie Huang (3):
>   Document: DT: Add bindings for mediatek MT8173 SoC Platform
>   arm64: dts: Add mediatek MT8173 SoC and evaluation board dts and
>     Makefile
>   arm64: mediatek: Add MT8173 SoC Kconfig and defconfig
>
> Yingjoe Chen (1):
>   irqchip: mtk-sysirq: Get irq number from register resource size
>
>  Documentation/devicetree/bindings/arm/mediatek.txt |   4 +
>  .../bindings/arm/mediatek/mediatek,sysirq.txt      |   1 +
>  .../devicetree/bindings/serial/mtk-uart.txt        |   4 +-
>  arch/arm64/Kconfig                                 |   6 +
>  arch/arm64/boot/dts/Makefile                       |   1 +
>  arch/arm64/boot/dts/mediatek/Makefile              |   5 +
>  arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |  38 +++++
>  arch/arm64/boot/dts/mediatek/mt8173.dtsi           | 168 +++++++++++++++++++++
>  arch/arm64/configs/defconfig                       |   2 +
>  drivers/irqchip/irq-mtk-sysirq.c                   |  18 ++-
>  10 files changed, 239 insertions(+), 8 deletions(-)
>  create mode 100644 arch/arm64/boot/dts/mediatek/Makefile
>  create mode 100644 arch/arm64/boot/dts/mediatek/mt8173-evb.dts
>  create mode 100644 arch/arm64/boot/dts/mediatek/mt8173.dtsi
>
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
