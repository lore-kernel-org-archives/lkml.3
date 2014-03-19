Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbaCSLUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:20:00 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47339 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCSLT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <1386657640-21481-1-git-send-email-ch.naveen@samsung.com>
References: <1384238132-24515-1-git-send-email-ch.naveen@samsung.com> <1386657640-21481-1-git-send-email-ch.naveen@samsung.com>
From: Leela Krishna Amudala <leelakrishna.a@gmail.com>
Date: Wed, 19 Mar 2014 16:49:36 +0530
Message-ID: <CAL1wa8fj+pYN7EOkh0nggkwss2U9pJhGEoaA7TG+7oy0LK3zFQ@mail.gmail.com>
Subject: Re: [PATCH v11 0/4] thermal: samsung: Clean up and add support for Exynos5420
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, Naveen Krishna <naveenkrishna.ch@gmail.com>,
        rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        amit.daniel@samsung.com, Kukjin Kim <kgene.kim@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "cpgs ." <cpgs@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I didn't see this series in mainline, Any comments for this ?

Thanks,
Leela Krishna Amudala.


On Tue, Dec 10, 2013 at 12:10 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patchset does a little clean up of the existing code (linux-soc-thermal)
> 1.  [v11] thermal: samsung: replace inten_ bit fields with intclr_
> 2.  [v11] thermal: samsung: change base_common to more meaningful base_second
>
> adds support for Exynos5420 in the driver and (linux-soc-thermal)
> 3.  [v11] thermal: samsung: Add TMU support for Exynos5420 SoCs
> also adds the device tree nodes for the same to exynos5420.dtsi (linux-samsung.git)
> 4.  [v11] ARM: dts: Exynos5420: Add device nodes for TMU blocks
>
> (linux-soc-thermal)
> Naveen Krishna Chatradhi (3):
>   thermal: samsung: replace inten_ bit fields with intclr_
>   thermal: samsung: change base_common to more meaningful base_second
>   thermal: samsung: Add TMU support for Exynos5420 SoCs
>
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   42 ++++++-
>  drivers/thermal/samsung/exynos_tmu.c               |   72 +++++++++---
>  drivers/thermal/samsung/exynos_tmu.h               |   21 ++--
>  drivers/thermal/samsung/exynos_tmu_data.c          |  119 ++++++++++++++++++--
>  drivers/thermal/samsung/exynos_tmu_data.h          |   12 +-
>  5 files changed, 228 insertions(+), 38 deletions(-)
>
> (linux-samsung.git)
> Naveen Krishna Chatradhi (1):
>   ARM: dts: Exynos5420: Add device nodes for TMU blocks
>
>  arch/arm/boot/dts/exynos5420.dtsi |   40 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
