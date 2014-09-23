Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaIWN2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:28:10 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55555 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIWN2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:28:08 -0400
Message-ID: <54217560.20803@gmail.com>
Date: Tue, 23 Sep 2014 15:28:00 +0200
From: Matthias Brugger <matthias.bgg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dandan.he@mediatek.com
Subject: Re: [PATCH v2 0/4] Add Mediatek SoC Pinctrl/GPIO driver for MT8135.
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
In-Reply-To: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/09/14 05:39, Hongzhou.Yang wrote:
> This is v2 of add Mediatek SoC Pinctrl/GPIO drvier for MT8135.
> It is based on Joe.C' basic device tree support.
> See http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/288582.html
> 
> This driver include common and MT8135 part, other Mediatek SoCs will share the common part,
> and MT8135 part only support MT8135. MT8135 has GPIO controller, it includes 203 pins.
> 
> Changes in v2:
> - According to Heiko Stubner' suggestion, use generic pinconfig.

Please always add people that made comments on your former versions in
CC. This way it is easier for them to follow the debate about your patches.

Thanks,
Matthias

> - Remove pinmux_ops.disable implement.
> - Due to limit of message body, move mt8135-pinfunc.h to '[PATCH 3/4] add pinctrl node for MT8135'.
> 
> 
> Hongzhou Yang (3):
> ARM: mediatek: Add Pinctrl/GPIO driver for mt8135.
> dt-bindings: Add pinctrl bindings for mt65xx/mt81xx.
> ARM: dts: mt8135: Add pinctrl node for mt8135.
> 
> Joe.C (1):
> arm: mediatek: Add config option for mediatek SoCs.
> 
> .../devicetree/bindings/pinctrl/pinctrl-mt65xx.txt |   98 +
> arch/arm/boot/dts/mt8135-pinfunc.h                 | 1304 +++++++++++
> arch/arm/boot/dts/mt8135.dtsi                      |   11 +
> arch/arm/mach-mediatek/Kconfig                     |   23 +-
> drivers/pinctrl/Kconfig                            |    1 +
> drivers/pinctrl/Makefile                           |    1 +
> drivers/pinctrl/mediatek/Kconfig                   |   12 +
> drivers/pinctrl/mediatek/Makefile                  |    5 +
> drivers/pinctrl/mediatek/pinctrl-mt8135.c          |   82 +
> drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |  792 +++++++
> drivers/pinctrl/mediatek/pinctrl-mtk-common.h      |   95 +
> drivers/pinctrl/mediatek/pinctrl-mtk-mt8135.h      | 2460 ++++++++++++++++++++
> include/dt-bindings/pinctrl/mt65xx.h               |   23 +
> 13 files changed, 4904 insertions(+), 3 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-mt65xx.txt
> create mode 100644 arch/arm/boot/dts/mt8135-pinfunc.h
> create mode 100644 drivers/pinctrl/mediatek/Kconfig
> create mode 100644 drivers/pinctrl/mediatek/Makefile
> create mode 100644 drivers/pinctrl/mediatek/pinctrl-mt8135.c
> create mode 100644 drivers/pinctrl/mediatek/pinctrl-mtk-common.c
> create mode 100644 drivers/pinctrl/mediatek/pinctrl-mtk-common.h
> create mode 100644 drivers/pinctrl/mediatek/pinctrl-mtk-mt8135.h
> create mode 100644 include/dt-bindings/pinctrl/mt65xx.h
> 
> --
> 1.8.1.1.dirty
> 
> 
> 
> 
