Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3AXOBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:01:49 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:53120 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3AXOBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
References: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 24 Jan 2013 19:31:40 +0530
Message-ID: <CAFp+6iFcn9G2jvdOUduCn-hE1hC-dqg=t0akO94VECFvCM7ZfA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] usb: exynos: Fix compatible strings used for device
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, cpgs@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 7:15 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Using chip specific compatible string as it should be.
> So fixing this for ehci-s5p, ohci-exynos and dwc3-exynos
> which till now used a generic 'exynos' in their compatible strings.
>
> Changes from v1:
>         - Changing compatible string from "samsung,exynos5250-dwc3" to
>           "samsung,exynos5250-dwusb3" as per discussion happened in thread:
>           [PATCH 0/2] usb: exynos: Fix compatible strings used for device.
>

Based on 'usb-next' branch.

> Vivek Gautam (2):
>   usb: ehci-s5p/ohci-exynos: Fix compatible strings for the device
>   usb: dwc3-exynos: Fix compatible strings for the device
>
>  drivers/usb/dwc3/dwc3-exynos.c |    2 +-
>  drivers/usb/host/ehci-s5p.c    |    2 +-
>  drivers/usb/host/ohci-exynos.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> --
> 1.7.6.5
>


-- 
Thanks & Regards
Vivek
