Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3A2MKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:10:32 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:55004 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab3A2MKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:10:30 -0500
MIME-Version: 1.0
In-Reply-To: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
References: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
Date: Tue, 29 Jan 2013 17:40:28 +0530
Message-ID: <CAFp+6iGJLV2rnHESX_Qmp+uL63mM7i=2tmFxaj=dK+SqCeg29A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ARM: Exynos5250: Enabling samsung usb phy
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, balbi@ti.com,
        thomas.abraham@linaro.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 9:01 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Changes from v1:
>  - Putting separate device nodes for usb 2.0 phy and usb 3.0 phy
>    based on separate driver for samsung usb 3.0 phy and
>    samsung usb 2.0 phy:
>    [PATCH v3 0/2] Adding USB 3.0 DRD-phy support for exynos5250
>    [PATCH v8 0/4] Adding usb2.0 host-phy support for exynos5250
>  - Aligning as per the patch:
>    usb: phy: samsung: Add support to set pmu isolation
>  - Replaced phy-handle approach for PHY CONTROL registers
>    to child nodes.
>  - Removing AUX data entry from exynos5250 dt file.
>
> Vivek Gautam (2):
>   ARM: Exynos5250: Enabling samsung-usbphy driver
>   ARM: Exynos5250: Enabling samsung-usb3-phy driver
>

any comments on this patch-series please ?

>  arch/arm/boot/dts/exynos5250.dtsi |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
>
> --
> 1.7.6.5
>



-- 
Thanks & Regards
Vivek
