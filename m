Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaJHC76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 22:59:58 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:53844 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJHC74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 22:59:56 -0400
MIME-Version: 1.0
In-Reply-To: <1410786785-9838-4-git-send-email-gautam.vivek@samsung.com>
References: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
	<1410786785-9838-4-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 8 Oct 2014 08:29:55 +0530
X-Google-Sender-Auth: 7DTVZOW0q1WRD4FFOrGABlqYEJg
Message-ID: <CAFp+6iEhL8bJgGJ=J7N_ar8AMO1GP1nGPdQZeGSxOkQ4EcrRQg@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm: dts: Exynos5: Use pmu_system_controller phandle
 for dp phy
From: Vivek Gautam <gautam.vivek@samsung.com>
To: dri-devel@lists.freedesktop.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: inki.dae@samsung.com, Sean Paul <seanpaul@google.com>,
        kishon <kishon@ti.com>, ajaykumar.rs@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CC'ing Kukjin,
my bad, missed him while sending the patch. :-(

On Mon, Sep 15, 2014 at 6:43 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> DP PHY now require pmu-system-controller to handle PMU register
> to control PHY's power isolation. Adding the same to dp-phy
> node.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> ---

Is someone taking care of this patch ? We already have got the corresponsding
dp-phy patch merged, so we should also get this patch in.

>  arch/arm/boot/dts/exynos5250.dtsi |    2 +-
>  arch/arm/boot/dts/exynos5420.dtsi |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index f21b9aa..9b85a2b 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -732,7 +732,7 @@
>
>         dp_phy: video-phy@10040720 {
>                 compatible = "samsung,exynos5250-dp-video-phy";
> -               reg = <0x10040720 4>;
> +               samsung,pmu-syscon = <&pmu_system_controller>;
>                 #phy-cells = <0>;
>         };
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index bfe056d..a677812 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -503,8 +503,8 @@
>         };
>
>         dp_phy: video-phy@10040728 {
> -               compatible = "samsung,exynos5250-dp-video-phy";
> -               reg = <0x10040728 4>;
> +               compatible = "samsung,exynos5420-dp-video-phy";
> +               samsung,pmu-syscon = <&pmu_system_controller>;
>                 #phy-cells = <0>;
>         };
>
> --
> 1.7.10.4
>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
