Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaICQ0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:26:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13888 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaICQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:26:40 -0400
X-AuditID: cbfee68d-f79c46d000000b84-f8-5407413d84aa
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Kevin Hilman'" <khilman@linaro.org>, afaerber@suse.de,
        "'Ajay Kumar'" <ajaykumar.rs@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1408749185-14133-1-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1408749185-14133-1-git-send-email-javier.martinez@collabora.co.uk>
Subject: RE: [PATCH 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
Date: Thu, 04 Sep 2014 01:26:37 +0900
Message-id: <041101cfc793$d5cdd4b0$81697e10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIwptjs3bAapGqitPRVJvwYUS0GhZst2aeg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zA107R/YQg0mOFs2bii0OvD/IYnF2
	2UE2i6O/Cyy+Hl7BaLHp8TVWi8u75rBZzDi/j8ni1PXPbA6cHrMbLrJ4/H1+ncXjzrU9bB6b
	l9R7XDnRxOrRt2UVo8fm09UenzfJBXBEcdmkpOZklqUW6dslcGVMWpZesE684uaaE+wNjJuE
	uxg5OSQETCTa5j5mh7DFJC7cW8/WxcjFISSwjFHiSsMlJpiiOY/vQyUWMUpM33iTBcL5yyhx
	umUjC0gVm4CGxOH3z8BGiQg4SJx/cRqsg1lgNpPE+t5trCAJIQF/iY4Jixi7GDk4OAUCJL5/
	1wIJCwtESbT/vAC2jUVAVWLx9Ftgc3gFLCWuL9vMBGELSvyYfA9sF7OAlsT6nceZIGx5ic1r
	3jJDXKogsePsa0aIG4wk7m46ClUjIrHvxTtGkHskBDo5JOY2vWSFWCYg8W3yIRaQeyQEZCU2
	HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7u
	JkZInPfuYLx9wPoQowAHoxIP74IAthAh1sSy4srcQ4ymQBdNZJYSTc4HJpO8knhDYzMjC1MT
	U2Mjc0szJXFeRamfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYey0jOooNdP6bLG2+r2G0
	JOH0kx83gnNb1b9ctLuz5VKloPaEliw9kZu61v2drro3mA/pFM4S1JzCfL+9VWGxfUlqnWfy
	rNfC39Un3XYyusG5bprm1OCJx+W2PzmbxNTbUvjOp/z/mSy9Cf+ef9Vl4Uy7Gpyue7bx/j41
	hfMvm5eFe22xm/pDiaU4I9FQi7moOBEAjXY8c+4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV1bR/YQg63rLSyaNxVbHHh/kMXi
	7LKDbBZHfxdYfD28gtFi0+NrrBaXd81hs5hxfh+Txanrn9kcOD1mN1xk8fj7/DqLx51re9g8
	Ni+p97hyoonVo2/LKkaPzaerPT5vkgvgiGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjHmDFpWXrBOvGKm2tOsDcwbhLuYuTkkBAwkZjz+D4bhC0mceHeeiCbi0NIYBGjxPSN
	N1kgnL+MEqdbNrKAVLEJaEgcfv+MHcQWEXCQOP/iNFgHs8BsJon1vdtYQRJCAv4SHRMWMXYx
	cnBwCgRIfP+uBRIWFoiSaP95gQnEZhFQlVg8/RbYHF4BS4nryzYzQdiCEj8m3wPbxSygJbF+
	53EmCFteYvOat8wQlypI7Dj7mhHiBiOJu5uOQtWISOx78Y5xAqPQLCSjZiEZNQvJqFlIWhYw
	sqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4jz6R3MK5qsDjEKMDBqMTDuyCALUSINbGs
	uDL3EKMEB7OSCO8aafYQId6UxMqq1KL8+KLSnNTiQ4ymQJ9OZJYSTc4Hpri8knhDYxMzI0sj
	MwsjE3NzJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MYk1rZikrZHDHCfgslr+rdaBYqq3q
	zK927v6UM7PzGTP2zQ4JkLuU4lHatJnjgOTMR5JTQ97/eS8Y/UqhqbKc9XneU5uttg6O19xT
	U6qXnjA67/91w1u+C19fKyxj8Wxhk3qVN++D80+1uqXazo1ZGQdMxR72LWXpWLhxd6n0/7V7
	D97w+qCgxFKckWioxVxUnAgA0j35zzkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas wrote:
> 
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
Thanks a lot.


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
BTW, I can't find its re-spin...how was going on?

> But I wanted to post anyways to make easier for others to
> figure out what are the needed options to have the display
> working on their Exynos machines.
> 
> In order to test the display panel on the Peach machines,
> the following patches are also needed:
> 
> "ARM: dts: Add DT changes for display on peach_pit" [3]
> "ARM: dts: Add DT changes for display on peach_pi" [4]
> 
I'll have a look them soon.

- Kukjin

> Best regards,
> Javier
> 
> [0]: http://patchwork.ozlabs.org/patch/373792/
> [1]: http://patchwork.ozlabs.org/patch/373793/
> [2]: http://patchwork.ozlabs.org/patch/373794/
> [3]: http://www.spinics.net/lists/arm-kernel/msg350568.html
> [4]: http://www.spinics.net/lists/arm-kernel/msg350569.html
> 
>  arch/arm/configs/exynos_defconfig | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 676c744..f69d57e 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -101,11 +101,25 @@ CONFIG_REGULATOR_S2MPA01=y
>  CONFIG_REGULATOR_S2MPS11=y
>  CONFIG_REGULATOR_S5M8767=y
>  CONFIG_REGULATOR_TPS65090=y
> +CONFIG_DRM=y
> +CONFIG_DRM_BRIDGE=y
> +CONFIG_DRM_PS8622=y
> +CONFIG_DRM_EXYNOS=y
> +CONFIG_DRM_EXYNOS_FIMD=y
> +CONFIG_DRM_EXYNOS_DP=y
> +CONFIG_DRM_PANEL=y
> +CONFIG_DRM_PANEL_SIMPLE=y
>  CONFIG_FB=y
>  CONFIG_FB_MODE_HELPERS=y
>  CONFIG_FB_SIMPLE=y
>  CONFIG_EXYNOS_VIDEO=y
>  CONFIG_EXYNOS_MIPI_DSI=y
> +CONFIG_BACKLIGHT_LCD_SUPPORT=y
> +CONFIG_LCD_CLASS_DEVICE=y
> +CONFIG_LCD_PLATFORM=y
> +CONFIG_BACKLIGHT_CLASS_DEVICE=y
> +CONFIG_BACKLIGHT_GENERIC=y
> +CONFIG_BACKLIGHT_PWM=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_FONTS=y
>  CONFIG_FONT_7x14=y
> --
> 2.0.1

