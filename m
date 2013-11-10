Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3KJSM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:12:29 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:42103 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3KJSMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:12:20 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk
Subject: Re: [PATCHv3 1/3] ARM: dts: exynos4212: Add PMU dt data for pmu-irq
Date: Sun, 10 Nov 2013 19:12:18 +0100
Message-ID: <9228109.fILkd0ZUhT@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383530161-24080-2-git-send-email-cw00.choi@samsung.com>
References: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com> <1383530161-24080-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

Please add a patch description. Even if trivial, it is good to have one.

On Monday 04 of November 2013 10:55:59 Chanwoo Choi wrote:
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4212.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
> index 6f34d7f..3081bae 100644
> --- a/arch/arm/boot/dts/exynos4212.dtsi
> +++ b/arch/arm/boot/dts/exynos4212.dtsi
> @@ -56,4 +56,10 @@
>  					<0x5 0 &gic 1 12 0>;
>  		};
>  	};
> +
> +	pmu {
> +		compatible = "arm,cortex-a9-pmu";
> +		interrupt-parent = <&combiner>;
> +		interrupts = <2 2>, <3 2>;
> +	};

I believe it would be better to put this in exynos4x12.dtsi, specifying
all four interrupts for possible four cores in Exynos4412. It would be
fine, since the interrupt layout is the same on all Exynos4x12 SoCs, just
some interrupts are not used.

Best regards,
Tomasz

