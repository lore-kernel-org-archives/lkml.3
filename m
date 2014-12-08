Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaLHSs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:48:26 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22658 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaLHSsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:48:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,540,1413270000"; 
   d="scan'208";a="52541873"
Message-ID: <5485F26E.6050506@broadcom.com>
Date: Mon, 8 Dec 2014 10:48:14 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        "Arnd Bergmann" <arnd@arndb.de>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Add gpio support to Broadcom Cygnus SoC
References: <Ray Jui <rjui@broadcom.com> <1418064468-8512-1-git-send-email-rjui@broadcom.com> <1418064468-8512-2-git-send-email-rjui@broadcom.com>
In-Reply-To: <1418064468-8512-2-git-send-email-rjui@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. Please ignore this particular cover letter. It accidentally got 
sent along with other v3 patches.

On 12/8/2014 10:47 AM, Ray Jui wrote:
> This patchset contains the initial GPIO support for the Broadcom Cygnus SoC.
> Cygnus has 3 GPIO controllers: 1) the ASIU GPIO; 2) the chipCommonG GPIO;
> and 3) the ALWAYS-ON GPIO. All 3 types of GPIO controllers are supported by
> the same Cygnus GPIO driver
>
> Changes from v1:
>   - Get rid of inline qualifier
>   - Get rid of redundant check in the ISR
>   - Other minor fixes to imrove code readability
>
> Ray Jui (5):
>    gpio: Cygnus: define Broadcom Cygnus GPIO binding
>    gpio: Cygnus: add GPIO driver
>    ARM: mach-bcm: Enable GPIO support for Cygnus
>    ARM: dts: enable GPIO for Broadcom Cygnus
>    MAINTAINERS: Entry for Cygnus GPIO driver
>
>   .../devicetree/bindings/gpio/brcm,cygnus-gpio.txt  |   85 +++
>   MAINTAINERS                                        |    7 +
>   arch/arm/boot/dts/bcm-cygnus.dtsi                  |   30 +
>   arch/arm/mach-bcm/Kconfig                          |    1 +
>   drivers/gpio/Kconfig                               |   11 +
>   drivers/gpio/Makefile                              |    1 +
>   drivers/gpio/gpio-bcm-cygnus.c                     |  712 ++++++++++++++++++++
>   7 files changed, 847 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt
>   create mode 100644 drivers/gpio/gpio-bcm-cygnus.c
>
