Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028AbaDPNBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:01:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53937 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269AbaDPNBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:01:19 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-97-534e7f1c1488
Message-id: <534E7F1A.8080502@samsung.com>
Date: Wed, 16 Apr 2014 15:01:14 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?B?J+uwleqyvQ==?= =?UTF-8?B?66+8Jw==?= 
	<kyungmin.park@samsung.com>
Subject: Re: [PATCH] arm: dts: exynos4: add missing pinctrls for I2C controllers
References: <534E7A3F.7050406@samsung.com>
In-reply-to: <534E7A3F.7050406@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e/4VV2Zer9gg7d9JhYbZ6xntZi07gCT
	xfwj51gt+t8sZLU492olo0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi6fWLTBYT
	pq9lsWjde4TdYl77S1YHfo8189YwerQ097B5XO7rZfL4u+oFs8fK5V/YPDat6mTz2Lyk3qNv
	yypGj8+b5AI4o7hsUlJzMstSi/TtErgyDk3ZxlzwiK+i69UJlgbGL1xdjJwcEgImEn+nv2aE
	sMUkLtxbz9bFyMUhJLCUUWLm4c9MEM5nRon/K6aygVTxCmhJnGrdCdbBIqAqcXbFLiYQm01A
	TeJzwyOwGn6gmjVN11lAbFGBCIl7jYdZIXoFJX5MvgcWFxFIk5h7+CaYzSywmUWib6UYiC0s
	ECBx+/NbZhBbCGjO5mmLgOZzcHAKaEs07raDKDeTeNSyjhnClpfYvOYt8wRGwVlINsxCUjYL
	SdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCER93UH49JjVocYBTgYlXh4Z+T4Bgux
	JpYVV+YeYpTgYFYS4e3N8gsW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwHio+c4+h1z5DNPpfZuz
	VnW+fsSnGWyrKNM4O9rc4m+PIbtr9qZ7HyqqzevDvG4mmOX7FSS817np9Gedpb/2ljnn7r6s
	DXu+oW1SK7d5T/IE799SXxU+roidbWUj/OcZ75YVyjXf+N4/+dsrfOtPnUBTJV+Uu+/SzrPJ
	Mo59bWd0w4s2tT8JUGIpzkg01GIuKk4EAIH+nPaWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 16.04.2014 14:40, Tomasz Stanislawski wrote:
> This patch adds missing pinctrls for I2C controllers 2-7.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   arch/arm/boot/dts/exynos4.dtsi |   12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> index 0401f4d..288aa81 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -357,6 +357,8 @@
>   		interrupts = <0 60 0>;
>   		clocks = <&clock CLK_I2C2>;
>   		clock-names = "i2c";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2c2_bus>;
>   		status = "disabled";
>   	};
>
> @@ -368,6 +370,8 @@
>   		interrupts = <0 61 0>;
>   		clocks = <&clock CLK_I2C3>;
>   		clock-names = "i2c";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2c3_bus>;
>   		status = "disabled";
>   	};
>
> @@ -379,6 +383,8 @@
>   		interrupts = <0 62 0>;
>   		clocks = <&clock CLK_I2C4>;
>   		clock-names = "i2c";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2c4_bus>;
>   		status = "disabled";
>   	};
>
> @@ -390,6 +396,8 @@
>   		interrupts = <0 63 0>;
>   		clocks = <&clock CLK_I2C5>;
>   		clock-names = "i2c";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2c5_bus>;
>   		status = "disabled";
>   	};
>
> @@ -401,6 +409,8 @@
>   		interrupts = <0 64 0>;
>   		clocks = <&clock CLK_I2C6>;
>   		clock-names = "i2c";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2c6_bus>;
>   		status = "disabled";
>   	};
>
> @@ -412,6 +422,8 @@
>   		interrupts = <0 65 0>;
>   		clocks = <&clock CLK_I2C7>;
>   		clock-names = "i2c";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2c7_bus>;
>   		status = "disabled";
>   	};
>
>

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
