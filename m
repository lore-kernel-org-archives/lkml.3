Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbbA2CaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:30:10 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35671 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbbA2CaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:30:04 -0500
MIME-Version: 1.0
In-Reply-To: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
References: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
Date: Wed, 28 Jan 2015 16:21:49 +0530
Message-ID: <CAM4voan-aoVQtRCFaB2rLLOgm+CEXg+Mc2gwfokUTu5eeQDo+g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] dts: Documentation: Add documentation for Exynos7
 SoC thermal bindings
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Amit Kachhap <amit.daniel@samsung.com>,
        Me2 <kesavan.abhilash@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Tue, Jan 27, 2015 at 11:18 AM, Abhilash Kesavan
<a.kesavan@samsung.com> wrote:
> Add documentation for exynos7 thermal bindings including compatible
> name and special clock properties.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 0f44932..695150a 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -12,6 +12,7 @@
>                "samsung,exynos5420-tmu-ext-triminfo" for TMU channels 2, 3 and 4
>                         Exynos5420 (Must pass triminfo base and triminfo clock)
>                "samsung,exynos5440-tmu"
> +              "samsung,exynos7-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
>  - reg : Address range of the thermal registers. For soc's which has multiple
>         instances of TMU and some registers are shared across all TMU's like
> @@ -32,10 +33,13 @@
>  - clocks : The main clocks for TMU device
>         -- 1. operational clock for TMU channel
>         -- 2. optional clock to access the shared registers of TMU channel
> +       -- 3. optional special clock for functional operation
>  - clock-names : Thermal system clock name
>         -- "tmu_apbif" operational clock for current TMU channel
>         -- "tmu_triminfo_apbif" clock to access the shared triminfo register
>                 for current TMU channel
> +       -- "tmu_sclk" clock for functional operation of the current TMU
> +               channel
>  - vtmu-supply: This entry is optional and provides the regulator node supplying
>                 voltage to TMU. If needed this entry can be placed inside
>                 board/platform specific dts file.

Can you kindly consider applying these two patches to your next tree
if they look OK ?

Regards,
Abhilash
> --
> 1.7.9.5
>
