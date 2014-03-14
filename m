Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaCNI0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:26:36 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:36532 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaCNI0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <1393845310-1898-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1393845310-1898-1-git-send-email-yuvaraj.cd@samsung.com>
Date: Fri, 14 Mar 2014 13:56:31 +0530
Message-ID: <CAKuRcO+vudiKC1SRGMWgb3Ec0-JrVNeCxM5g5eTNR3OnQmmMTQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: exynos5250: turn on the LDO10 on SMDK5250
From: Yuvaraj Kumar <yuvaraj.cd@gmail.com>
To: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, sunil joshi <joshi@samsung.com>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>, thomas.ab@samsung.com,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this?

On Mon, Mar 3, 2014 at 4:45 PM, Yuvaraj Kumar C D <yuvaraj.cd@gmail.com> wrote:
> Commit 275dcd2 "ARM: dts: add max77686 pmic node for smdk5250" added
> required LDO's for SMDK5250 boards.Currently LDO10 is turned off.As LDO10,
> enable/disable the LDO22 which is required for VDDQ_MMC2_AP.So this patch
> makes LDO10 turn's on always.
>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250-smdk5250.dts |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> index f76946e..27a33d7 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -103,6 +103,7 @@
>                                         regulator-name = "P1.8V_LDO_OUT10";
>                                         regulator-min-microvolt = <1800000>;
>                                         regulator-max-microvolt = <1800000>;
> +                                       regulator-always-on;
>                                 };
>
>                                 ldo11_reg: LDO11 {
> --
> 1.7.10.4
>
