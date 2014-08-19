Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaHSSwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:52:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaHSSwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:52:24 -0400
Message-ID: <53F39CE3.8040303@suse.de>
Date: Tue, 19 Aug 2014 20:52:19 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: dts: Add Peach Pit and Pi dts entry for max77802
 PMIC
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk> <1408460913-13863-2-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1408460913-13863-2-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.08.2014 17:08, schrieb Javier Martinez Canillas:
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index 228a6b1..8619d58 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> @@ -144,6 +144,339 @@
>  	ddc = <&i2c_2>;
>  };
>  
> +&hsi2c_4 {
> +	status = "okay";
> +	clock-frequency = <400000>;
> +
> +	max77802-pmic@9 {
> +		compatible = "maxim,max77802";
> +		interrupt-parent = <&gpx3>;
> +		interrupts = <1 0>;

<1 IRQ_TYPE_NONE>?

[...]
> diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> index f3ee48b..f753eae 100644
> --- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
> +++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> @@ -142,6 +142,339 @@
>  	ddc = <&i2c_2>;
>  };
>  
> +&hsi2c_4 {
> +	status = "okay";
> +	clock-frequency = <400000>;
> +
> +	max77802-pmic@9 {
> +		compatible = "maxim,max77802";
> +		interrupt-parent = <&gpx3>;
> +		interrupts = <1 0>;

Dito?

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
