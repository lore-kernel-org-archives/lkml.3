Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaIHSlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:41:46 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42524 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaIHSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:41:44 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Zimmerman <paulz@synopsys.com>, dianders@chromium.org, olof@lixom.net,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        xjq@rock-chips.com, wulf@rock-chips.com, lyz@rock-chips.com,
        hj@rock-chips.com, huangtao@rock-chips.com, devicetree@vger.kernel.org,
        Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-usb@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/4] Patches to add support for Rockchip dwc2 controller
Date: Mon, 08 Sep 2014 20:43:40 +0200
Message-ID: <4508852.pY5QcWPyfZ@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
References: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Freitag, 8. August 2014, 11:55:55 schrieb Kever Yang:
> These patches to add support for dwc2 controller found in
> Rockchip processors rk3066, rk3188 and rk3288,
> and enable dts for rk3288 evb.

will you take patches 1 and 2?


Thanks
Heiko


> 
> Changes in v5:
> - max_transfer_size change to 65535 to met the requirement of
>   header file
> - change the sort order of dwc2 in rk3288.dtsi
> - don't enable otg port for evb
> 
> Changes in v4:
> - max_transfer_size change to 65536, this should be enough
>   for most transfer, the hardware auto-detect will set this
>   to 0x7ffff which may make dma_alloc_coherent fail when
>   non-dword aligned buf from driver like usbnet happen.
> - remove EHCI and HSIC dts patch for Doug had post it seprately.
> 
> Changes in v3:
> - EHCI and HSIC move new for version 3.
> - Rebase
> 
> Changes in v2:
> - Split out dr_mode and rk3288 bindings.
> - add compatible "snps,dwc2" bingding info
> - set most parameters as driver auto-detect
> - evb patch added in version 2
> 
> Kever Yang (4):
>   Documentation: dt-bindings: add dt binding info for Rockchip dwc2
>   usb: dwc2: add compatible data for rockchip soc
>   ARM: dts: add rk3288 dwc2 controller support
>   ARM: dts: Enable USB host1(dwc) on rk3288-evb
> 
>  Documentation/devicetree/bindings/usb/dwc2.txt |  3 +++
>  arch/arm/boot/dts/rk3288-evb.dtsi              |  4 ++++
>  arch/arm/boot/dts/rk3288.dtsi                  | 20 ++++++++++++++++++
>  drivers/usb/dwc2/platform.c                    | 29
> ++++++++++++++++++++++++++ 4 files changed, 56 insertions(+)

