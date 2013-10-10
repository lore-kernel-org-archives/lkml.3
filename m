Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3JJD32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 23:29:28 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34459 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3JJD30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 23:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <1381365007-1782-4-git-send-email-cw00.choi@samsung.com>
References: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
	<1381365007-1782-4-git-send-email-cw00.choi@samsung.com>
Date: Thu, 10 Oct 2013 08:59:24 +0530
Message-ID: <CAK9yfHxr27nsmaqkE+seDgZAkpUmOsPqdXdeogY89tAXYEEG2w@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dts: exynos4x12: Add maudio/gps_alive power
 domain for exynos4x12
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 October 2013 06:00, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch maudio/gps_alive power domain to exynos4x12.dtsi.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
> index ad531fe..c04418e 100644
> --- a/arch/arm/boot/dts/exynos4x12.dtsi
> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
> @@ -35,6 +35,16 @@
>                 reg = <0x10023CA0 0x20>;
>         };
>
> +       pd_maudio: maudio-power-domain@10023CC0 {
> +               compatible = "samsung,exynos4210-pd";
> +               reg = <0x10023CC0 0x20>;
> +       };
> +
> +       pd_gps_alive: gps-alive-power-domain@10023D04 {
> +               compatible = "samsung,exynos4210-pd";
> +               reg = <0x10023D00 0x20>;

There is mismatch between node name and register value.


-- 
With warm regards,
Sachin
