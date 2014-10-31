Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbaJaXmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:42:15 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48563 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaJaXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:42:13 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.112]
In-Reply-To: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Sat, 1 Nov 2014 00:42:11 +0100
Message-ID: <CABxcv=m-aNVcUU2C8LosCECxq1yZo2C3zfA2xe6z7jF8tFPsnw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On Mon, Aug 25, 2014 at 10:45 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Many Exynos devices have a display panel. Most of them just have
> a simple panel while others have more complex configurations that
> requires an embedded DisplayPort (eDP) to LVDS bridges.
>
> This patch enables the following features to be built in the kernel
> image to suport both setups:
>
> - Direct Rendering Manager (DRM)
> - DRM bridge registration and lookup framework
> - Parade ps8622/ps8625 eDP/LVDS bridge
> - NXP ptn3460 eDP/LVDS bridge
> - Exynos Fully Interactive Mobile Display controller (FIMD)
> - Panel registration and lookup framework
> - Simple panels
> - Backlight & LCD device support
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Kevin Hilman <khilman@linaro.org>
> ---

This patch is needed to have display working on many Exynos boards.

$subject enables the config option for the ps8622/ps8625 eDP/LVDS
bridge driver but this has not landed in mainline yet. Ajay will
re-spin a new revision of his series that adds this driver though,
after addressing some issues pointed out on a previous version.

The Kconfig symbol name (DRM_PS8622) won't change though so maybe is
not crazy to pick the patch as is since CONFIG_DRM_PS8622 will have to
be enabled later when the bridge driver lands. Or do you want me to
re-spin $subject removing that option?

Best regards,
Javier
