Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3KJSPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:15:32 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35153 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3KJSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:15:23 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv3 2/3] ARM: dts: exynos4212: Add missing clock for multi core timer
Date: Sun, 10 Nov 2013 19:15:21 +0100
Message-ID: <11439632.EJeOOmBkrd@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383530161-24080-3-git-send-email-cw00.choi@samsung.com>
References: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com> <1383530161-24080-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo, Marek,

On Monday 04 of November 2013 10:56:00 Chanwoo Choi wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 

No patch description?

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4212.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
> index 3081bae..d7a3fbc 100644
> --- a/arch/arm/boot/dts/exynos4212.dtsi
> +++ b/arch/arm/boot/dts/exynos4212.dtsi
> @@ -43,6 +43,8 @@
>  		interrupt-parent = <&mct_map>;
>  		interrupts = <0 0>, <1 0>, <2 0>, <3 0>,
>  			     <4 0>, <5 0>;
> +		clocks = <&clock 3>, <&clock 344>;
> +		clock-names = "fin_pll", "mct";
>  
>  		mct_map: mct-map {
>  			#interrupt-cells = <2>;
> 

Otherwise the patch is technically correct, but I have already sent
a series[1] that moves MCT node one level up to exynos4x12.dtsi, which
also solves this problem.

[1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/22207/focus=22208

Best regards,
Tomasz

