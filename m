Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaD1JcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:32:15 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:54302 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaD1JcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <1398677132-30600-1-git-send-email-gautam.vivek@samsung.com>
References: <1398677132-30600-1-git-send-email-gautam.vivek@samsung.com>
Date: Mon, 28 Apr 2014 15:02:09 +0530
X-Google-Sender-Auth: 9hXnYxLkYsNMuv2w-IS1IU9qtQ0
Message-ID: <CAFp+6iE67ikwj7QU4vwJ8RZKhQo5WFTFb297WiD_Ej3SZ2u+gQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] usb: ehci/ohci-exynos: Move to generic phy framework
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 2:55 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Based and tested on 'usb-next' branch of Greg's usb tree, with relevant
> device tree patches[1]

[1] [PATCH v7 0/2] dts: Add usb2phy to Exynos 5250
     http://www.spinics.net/lists/linux-usb/msg106427.html


>
> Changes from v2:
>  - Added two patches in the series for some cleanup.
>    usb: ohci-exynos: Use struct device instead of platform_device
>    usb: ehci-exynos: Use struct device instead of platform_device
>  - Addressed review comments.
>    -- Moved exynos_ohci_phyg_on()/off routines inside
>       exynos_ohci_phy_enable()/disable.
>    -- Added functions exynos_ehci_phy_enable() and exynos_ehci_phy_disable()
>       and moved exynos_ehci_phyg_on()/off routines respectively in them.
>    -- Added necessary checks.
>
> Kamil Debski (1):
>   usb: ehci-exynos: Change to use phy provided by the generic phy
>     framework
>
> Vivek Gautam (3):
>   usb: ohci-exynos: Use struct device instead of platform_device
>   usb: ehci-exynos: Use struct device instead of platform_device
>   usb: ohci-exynos: Add facility to use phy provided by the generic phy
>     framework
>
>  .../devicetree/bindings/usb/exynos-usb.txt         |   37 +++++
>  drivers/usb/host/ehci-exynos.c                     |  148 +++++++++++++++++---
>  drivers/usb/host/ohci-exynos.c                     |  141 ++++++++++++++++---
>  3 files changed, 280 insertions(+), 46 deletions(-)
>
> --
> 1.7.10.4
>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
