Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3KKPz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:55:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51071 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3KKPzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:55:22 -0500
Message-ID: <5280FD22.8060107@ti.com>
Date: Mon, 11 Nov 2013 17:52:02 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 0/7] gpio: daVinci: cleanup and feature enhancement
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar Lad,

On 11/08/2013 12:11 PM, Prabhakar Lad wrote:
> From: KV Sujith <sujithkv@ti.com>
>
> This patch series does the following
> 1> Ports the driver to use irqdomain.
> 2> Adds dt binding support for gpio-davinci.
> 3> Adds DA850 dt support goio.
>
> Changes for v5:
> 1: Fixed review comments pointed by Grygorii.
> 2: Dropped the fixup patch
>
> This patch series is based on following fixup series
> http://us.generation-nt.com/answer/patch-0-2-davinci-gpio-fixes-help-212978272.html

Few comments to this series - the rest looks ok to me.
  Hope it will pass review of bindings :P

>
> KV Sujith (3):
>    gpio: davinci: add OF support
>    ARM: davinci: da850: add GPIO DT node
>    ARM: davinci: da850 evm: add GPIO pinumux entries DT node
>
> Lad, Prabhakar (4):
>    gpio: davinci: remove unnecessary printk
>    gpio: davinci: use readl/writel instead of __raw_*
>    gpio: davinci: use irqdomain
>    gpio: davinci: remove unused variable intc_irq_num
>
>   .../devicetree/bindings/gpio/gpio-davinci.txt      |   39 +++++
>   arch/arm/boot/dts/da850-evm.dts                    |   20 +++
>   arch/arm/boot/dts/da850.dtsi                       |   14 ++
>   arch/arm/mach-davinci/da830.c                      |    1 -
>   arch/arm/mach-davinci/da850.c                      |    1 -
>   arch/arm/mach-davinci/dm355.c                      |    1 -
>   arch/arm/mach-davinci/dm365.c                      |    1 -
>   arch/arm/mach-davinci/dm644x.c                     |    1 -
>   arch/arm/mach-davinci/dm646x.c                     |    1 -
>   drivers/gpio/gpio-davinci.c                        |  170 +++++++++++++-------
>   include/linux/platform_data/gpio-davinci.h         |    3 +-
>   11 files changed, 185 insertions(+), 67 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt
>
Regards,
- grygorii
