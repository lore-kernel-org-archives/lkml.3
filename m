Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbaELOIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:08:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42556 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756090AbaELOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:08:14 -0400
Date: Mon, 12 May 2014 10:08:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <gregkh@linuxfoundation.org>,
        <swarren@wwwdotorg.org>, <kgene.kim@samsung.com>,
        <thierry.reding@gmail.com>, <shc_work@mail.ru>
Subject: Re: [PATCH v2 0/6] usb: host: Cleanup for ioremap'ing hcd memory
In-Reply-To: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1405121007410.1202-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014, Vivek Gautam wrote:

> Based on 'usb-next' branch of Greg's usb tree.
> 
> devm_ioremap_resource() API is advantageous over devm_ioremap()
> and should therefore be preferred to request any ioremap'ed address
> for hcd.
> 
> Changes from v1:
>  - Changed the way returned pointer is checked for error value
>    as pointed out in the review comment in the mailing list.
> 
> Vivek Gautam (6):
>   usb: host: ehci-exynos: Use devm_ioremap_resource instead of
>     devm_ioremap
>   usb: host: ehci-msm: Use devm_ioremap_resource instead of
>     devm_ioremap
>   usb: host: ehci-mv: Use devm_ioremap_resource instead of devm_ioremap
>   usb: host: ehci-spear: Use devm_ioremap_resource instead of
>     devm_ioremap
>   usb: host: ehci-tegra: Use devm_ioremap_resource instead of
>     devm_ioremap
>   usb: host: ohci-exynos: Use devm_ioremap_resource instead of
>     devm_ioremap
> 
>  drivers/usb/host/ehci-exynos.c |    7 +++----
>  drivers/usb/host/ehci-msm.c    |    7 +++----
>  drivers/usb/host/ehci-mv.c     |   16 ++++++----------
>  drivers/usb/host/ehci-spear.c  |   13 +++----------
>  drivers/usb/host/ehci-tegra.c  |    7 +++----
>  drivers/usb/host/ohci-exynos.c |    7 +++----
>  6 files changed, 21 insertions(+), 36 deletions(-)

For all six patches,

Acked-by: Alan Stern <stern@rowland.harvard.edu>

