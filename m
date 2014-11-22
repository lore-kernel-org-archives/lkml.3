Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaKVOUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:20:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:57842 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaKVOUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:20:44 -0500
Message-ID: <54709BB8.1060309@kernel.org>
Date: Sat, 22 Nov 2014 23:20:40 +0900
From: Kukjin Kim <kgene@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jaewon Kim <jaewon02.kim@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 1/2] ARM: dts: add pwm node for exynos4412-trats2
References: <1416493576-10129-1-git-send-email-jaewon02.kim@samsung.com>
In-Reply-To: <1416493576-10129-1-git-send-email-jaewon02.kim@samsung.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/14 23:26, Jaewon Kim wrote:
> This patch add PWM(Pulse Width Modulation) node and
> handle to use pwm property.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index 8ee20bd..72462e8 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -636,6 +636,13 @@
>  		};
>  	};
>  
> +	pwm: pwm@139D0000 {
> +		pinctrl-0 = <&pwm0_out>;
> +		pinctrl-names = "default";
> +		samsung,pwm-outputs = <0>;
> +		status = "okay";
> +	};
> +
>  	dsi_0: dsi@11C80000 {
>  		vddcore-supply = <&ldo8_reg>;
>  		vddio-supply = <&ldo10_reg>;

Applied this and 2nd.

Thanks,
Kukjin
