Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaHWDzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 23:55:41 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55734 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaHWDzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 23:55:40 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, afaerber@suse.de,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: exynos_defconfig: Enable options for display panel support
References: <1408749185-14133-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Fri, 22 Aug 2014 20:55:37 -0700
In-Reply-To: <1408749185-14133-1-git-send-email-javier.martinez@collabora.co.uk>
	(Javier Martinez Canillas's message of "Sat, 23 Aug 2014 01:13:05
	+0200")
Message-ID: <7h4mx37tc6.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas <javier.martinez@collabora.co.uk> writes:

> Many Exynos devices have a display panel, most of them just have
> a simple panel while others have more complex configurations that
> requires an embedded DisplayPort (eDP) to LVDS display bridge.
>
> This patch enables the following features to support both setups:
>
> - Direct Rendering Manager (DRM)
> - DRM bridge registration and lookup framework
> - Parade ps8622/ps8625 eDP/LVDS bridge
> - NXP ptn3460 eDP/LVDS bridge
> - Exynos Fully Interactive Mobile Display controller (FIMD)
> - Panel registration and lookup framework
> - Simple panels
> - Backlight and LCD device support
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>
> Some of the options enabled here (e.g: the eDP/LVDS bridges)
> are still not merged in mainline so this patch depends on
> the following posted patches that were still not merged:
>
> "drm/bridge: Modify drm_bridge core to support driver model" [0]
> "drm/bridge: Add i2c based driver for ptn3460 bridge" [1]
> "drm/bridge: Add i2c based driver for ps8622/ps8625 bridge" [2]
>
> But I wanted to post anyways to make easier for others to
> figure out what are the needed options to have the display
> working on their Exynos machines.

Great, thanks for this!  I spent/wasted quite a bit of time trying to
figure out which options I needed to enable to get basic display support
working.
>
> In order to test the display panel on the Peach machines,
> the following patches are also needed:
>
> "ARM: dts: Add DT changes for display on peach_pit" [3]
> "ARM: dts: Add DT changes for display on peach_pi" [4]

Tested-by: Kevin Hilman <khilman@linaro.org>

On v3.17-rc1 along with these DT patches abvoe on exynos5800/chromebook2
(peach-pi).

Thanks,

Kevin
