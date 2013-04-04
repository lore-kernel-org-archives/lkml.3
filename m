Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab3DDGq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:46:29 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:35441 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763781Ab3DDGq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
References: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 4 Apr 2013 12:16:26 +0530
Message-ID: <CAFp+6iHZxeLxwz-RA52AaoS7jD3EfrySwmNH4GhHhQiVtrd51Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] ARM: Exynos5250: Enabling samsung usb phy
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, rob.herring@calxeda.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com,
        p.paneri@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Fri, Mar 15, 2013 at 1:26 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Based on 'for-next' of linux-samsung tree with following patches
> from Doug on top:
> usb: Document clocks in samsung, exynos4210-ehci/ohci bindings
> ARM: dts: add usb 2.0 clock references to exynos5250 device tree
>
> Also depending upon following patch-series for Samsung-usb-phy driver:
> [PATCH v7 0/2] Adding USB 3.0 DRD-phy support for exynos5250
>
> Changes from v3:
> Added 'clocks' and 'clock-names' entry also in device nodes, aligning
> with common clock framework for Samsung's SoCs.
>
> Vivek Gautam (2):
>   ARM: Exynos5250: Enabling samsung-usb2phy driver
>   ARM: Exynos5250: Enabling samsung-usb3phy driver
>
>  arch/arm/boot/dts/exynos5250.dtsi |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)

Waiting for your review on this patch-set. :-)


-- 
Thanks & Regards
Vivek
