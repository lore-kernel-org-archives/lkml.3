Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaCQWhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:37:04 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35016 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaCQWhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:37:01 -0400
Message-ID: <532778FD.5080509@samsung.com>
Date: Tue, 18 Mar 2014 07:36:45 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 6/9 v7] ARM: dts: exynos5250/5420: add dt node for sss
 module
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com> <1392630275-8667-7-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1392630275-8667-7-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/14 18:44, Naveen Krishna Chatradhi wrote:
> This patch adds the device tree node for SSS module
> found on Exynos5420 and Exynos5250
>
> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> TO:<linux-samsung-soc@vger.kernel.org>
> CC: David S. Miller<davem@davemloft.net>
> CC: Kukjin Kim<kgene.kim@samsung.com>
> CC:<linux-crypto@vger.kernel.org>
> ---
> Changes since v6:
> None
>
>   arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
>   arch/arm/boot/dts/exynos5420.dtsi |    9 +++++++++
>   2 files changed, 17 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index a76a189..13b748f 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -715,4 +715,12 @@
>   		io-channel-ranges;
>   		status = "disabled";
>   	};
> +
> +	sss@10830000 {
> +		compatible = "samsung,exynos4210-secss";
> +		reg =<0x10830000 0x10000>;
> +		interrupts =<0 112 0>;
> +		clocks =<&clock 348>;
> +		clock-names = "secss";
> +	};
>   };
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 9c834cc..b4ce625 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -666,4 +666,13 @@
>   		clock-names = "watchdog";
>   		samsung,syscon-phandle =<&pmu_system_controller>;
>           };
> +
> +	sss@10830000 {
> +		compatible = "samsung,exynos4210-secss";
> +		reg =<0x10830000 0x10000>;
> +		interrupts =<0 112 0>;
> +		clocks =<&clock 471>;
> +		clock-names = "secss";
> +		samsung,power-domain =<&g2d_pd>;
> +	};
>   };

Applied, thanks.

- Kukjin
