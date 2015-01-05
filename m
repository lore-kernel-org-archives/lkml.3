Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbbAEM5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:57:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52859 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbbAEM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:57:44 -0500
X-AuditID: cbfee68f-f791c6d000004834-55-54aa8a46687b
From: Kukjin Kim <kgene@kernel.org>
To: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1420215089-2093-1-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1420215089-2093-1-git-send-email-javier.martinez@collabora.co.uk>
Subject: RE: [PATCH RESEND] ARM: exynos_defconfig: Enable options for display
 panel support
Date: Mon, 05 Jan 2015 21:57:41 +0900
Message-id: <047c01d028e7$311858e0$93490aa0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFHhln3IK3rYXqhs3URpQUo5E5dS53CvgXw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWyRsSkRdeta1WIwe913BZnlx1ks2i7cpDd
	4ujvAovXLwwtvh5ewWix6fE1VovLu+awWcw4v4/J4tT1z2wOnB6zGy6yePx9fp3F4861PWwe
	m5fUe1w50cTq0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBmfXh9kLZjPU/GoexdrA+MLzi5G
	Tg4JAROJNzcvs0HYYhIX7q0Hsrk4hASWMkrc2biAHaZo3YUNjBCJ6YwSnx90s4AkhAT+Mkr8
	PxzTxcjBwSagLNHYpA8SFhbQkli4pQmsRETAQeL8i9NgQ5kF9jFJLNv0gwmi109i89nFYEWc
	Av4Sl258YAGZIywQKzHvjBhImEVAVWL+9i1gJbwCFhK/lpyDsgUlfky+B2YzA+1av/M4E4Qt
	L7F5zVtmiJsVJHacfc0IcYORxOoHj1ghakQk9r14B/aLhEAvh8T7379ZIJYJSHybfAjsBgkB
	WYlNB6DmSEocXHGDZQKj5Cwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSsV5yYW1yal66X
	nJ+7iREY96f/PevfwXj3gPUhRgEORiUeXo8TK0OEWBPLiitzDzGaAl00kVlKNDkfmFzySuIN
	jc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGNNxl/2d9bEd
	6vsMp98NPVT5kenyj9ezNr6yEhbLSvs7kekon9a/EMaypKg0Pt99HkUligeaTbcHzE3NVtE9
	sXV5i6E1/wJxl0nKp2/J/Jfi+7owdILknDaLudvErA1vC0/f9uZI01zDPPEU6yT3+z8bfvEJ
	/C++GOEf5athxbr64PqFx668UGIpzkg01GIuKk4EAOq2k/L2AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jQV23rlUhBh93sFmcXXaQzaLtykF2
	i6O/CyxevzC0+Hp4BaPFpsfXWC0u75rDZjHj/D4mi1PXP7M5cHrMbrjI4vH3+XUWjzvX9rB5
	bF5S73HlRBOrR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGPM+PT6IGvBfJ6KR927WBsYX3B2MXJySAiYSKy7sIERwhaTuHBvPVsXIxeHkMB0RonPD7pZ
	QBJCAn8ZJf4fjuli5OBgE1CWaGzSBwkLC2hJLNzSBFYiIuAgcf7FabBeZoF9TBLLNv1gguj1
	k9h8djFYEaeAv8SlGx9YQOYIC8RKzDsjBhJmEVCVmL99C1gJr4CFxK8l56BsQYkfk++B2cxA
	u9bvPM4EYctLbF7zlhniZgWJHWdfM0LcYCSx+sEjVogaEYl9L94xTmAUnoVk1Cwko2YhGTUL
	ScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFJ5Zn0DsZVDRaHGAU4GJV4eD1OrAwR
	Yk0sK67MPcQowcGsJML7Kn1ViBBvSmJlVWpRfnxRaU5q8SFGU6BPJzJLiSbnAxNeXkm8obGJ
	mZGlkZmFkYm5uZI4r5J9W4iQQHpiSWp2ampBahFMHxMHp1QDo+usDcszbxxp1OewjGefldt5
	f5HxCn6JbS82zvcXm2bK2dH4RaQzcK+ozQmpGyp+MYukcyzyZXpuCZrxTp8849zFSWp7X53z
	O1YXpPz8Vc8RDlfjycL3zm5q+6cQ3Nt8OWOa/+kNjD0Hs6fKzPE6W7iSja9a2TRjVUXs5uTT
	r4XW3gt5HntomRJLcUaioRZzUXEiAB/JyqlAAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas wrote:
> 
> Many Exynos devices have a display panel. Most of them just have
> a simple panel while others have more complex configurations that
> requires an embedded DisplayPort (eDP) to LVDS bridges.
> 
> This patch enables the following features to be built in the kernel
> image to support both setups:
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
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
> 
> Hello Kukjin,
> 
Hi Javier,

Happy new year :)

> You dropped this patch since exynos drm was causing boot hangs on some
> platforms but the fix for that issue is already in linux-next (commit:
> f1e9203 clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable
> failure due to domain being gated) so I think it makes sense to enable
> the display options again.
> 
> NOTE: Display panel is still not working since patch "arm: dts: Exynos5:
> Use pmu_system_controller phandle for dp phy" is needed [0] but I think
> we should enable display options to catch the regressions easier.
> 
Agreed with your suggestion and I'll pick this up into Samsung tree soon.

Thanks,
Kukjin

