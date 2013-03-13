Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3CMKLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:11:18 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49167 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3CMKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <1361976229-16024-1-git-send-email-gautam.vivek@samsung.com>
References: <1361976229-16024-1-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 13 Mar 2013 15:41:15 +0530
Message-ID: <CAFp+6iGon4sD4=qKpAVG-OGm9brwnz1O6sdCKmh8o9Wy1e_6ow@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] Adding USB 3.0 DRD-phy support for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, kgene.kim@samsung.com, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Wed, Feb 27, 2013 at 8:13 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Based on 'usb-next'
>
> Changes from v5:
>  - Squashed the following change from Felipe in this patch-set:
>    [PATCH] usb: phy: samsung: let it be built as a module
>  - Using EXPORT_SYMBOL_GPL() to export symbols in "samsung-usbphy.c"
>    to allow module builds of these samsung PHY drivers.
>
> Vivek Gautam (2):
>   usb: phy: samsung: Common out the generic stuff
>   usb: phy: samsung: Add PHY support for USB 3.0 controller
>

I am rebasing this pach-set on top of your PHY driver changes in
'testing' branch of your tree.
I took first 194 patches ;) from top of testing branch (i could find
these on top of 3.9 rc2 merge),
and applied the same on 'usb-next' branch in my development tree in
order to test further.

I shall be posting these rebased patch-set, so that it will be easier
for you to merge the changes in.
Is there something you want to point out to me while i do this ?

>  drivers/usb/phy/Kconfig           |   25 +-
>  drivers/usb/phy/Makefile          |    2 +
>  drivers/usb/phy/samsung-usb2phy.c |  511 ++++++++++++++++++++++++++
>  drivers/usb/phy/samsung-usb3phy.c |  349 ++++++++++++++++++
>  drivers/usb/phy/samsung-usbphy.c  |  722 +------------------------------------
>  drivers/usb/phy/samsung-usbphy.h  |  328 +++++++++++++++++
>  6 files changed, 1224 insertions(+), 713 deletions(-)
>  create mode 100644 drivers/usb/phy/samsung-usb2phy.c
>  create mode 100644 drivers/usb/phy/samsung-usb3phy.c
>  create mode 100644 drivers/usb/phy/samsung-usbphy.h
>
> --
> 1.7.6.5
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss



-- 
Thanks & Regards
Vivek
