Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaEGI0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbaEGI0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:26:39 -0400
Message-ID: <5369EE01.1090909@redhat.com>
Date: Wed, 07 May 2014 10:25:37 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com
CC: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 0/7] Add Allwinner A31 USB support
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/07/2014 05:50 AM, Maxime Ripard wrote:
> Hi everyone,
> 
> This patchset adds support for the USB controllers found in the
> Allwinner A31.
> 
> While the design is similar to the earlier Allwinner SoCs that are
> already supported, a few details here and there change, like the fact
> that the PHYs now have one clock per phy, while it used to be only one
> for all the PHYs.
> 
> Thanks,
> Maxime

Thanks for working on this.

Looks good, the entire series is:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> 
> Boris BREZILLON (2):
>   usb: ehci-platform: add optional reset controller retrieval
>   ARM: sunxi: dt: add APP4-EVB1 board support
> 
> Maxime Ripard (5):
>   clk: sunxi: Implement A31 USB clock
>   ARM: sun6i: Add the USB clocks to the DTSI.
>   phy: usb: sunxi: Introduce Allwinner A31 USB PHY support
>   usb: ohci-platform: Enable optional use of reset controller
>   ARM: sun6i: dt: Add support for the USB controllers
> 
>  Documentation/devicetree/bindings/usb/usb-ehci.txt |  1 +
>  Documentation/devicetree/bindings/usb/usb-ohci.txt |  1 +
>  arch/arm/boot/dts/Makefile                         |  1 +
>  arch/arm/boot/dts/sun6i-a31-app4-evb1.dts          | 63 ++++++++++++++++
>  arch/arm/boot/dts/sun6i-a31.dtsi                   | 88 ++++++++++++++++++++++
>  drivers/clk/sunxi/clk-sunxi.c                      |  6 ++
>  drivers/phy/phy-sun4i-usb.c                        | 35 ++++++---
>  drivers/usb/host/ehci-platform.c                   | 25 +++++-
>  drivers/usb/host/ohci-platform.c                   | 25 +++++-
>  9 files changed, 234 insertions(+), 11 deletions(-)
>  create mode 100644 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts
> 
