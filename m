Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3FMMM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:12:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58711 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3FMMM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:12:56 -0400
X-AuditID: cbfee68e-b7f276d000002279-63-51b9b7470e72
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Girish K S'" <girishks2000@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <1366102733-3570-1-git-send-email-ks.giri@samsung.com>
In-reply-to: <1366102733-3570-1-git-send-email-ks.giri@samsung.com>
Subject: RE: [PATCH 1/2] ARM: dts: enable spi for EXYNOS5440 SOC
Date: Thu, 13 Jun 2013 21:12:55 +0900
Message-id: <150c01ce682f$55c44200$014cc600$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac46gKgNnOm1BOJXQOygB/S+OWTktwtrjUMw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zY1337TsDDY7eErc407We1WLT42us
	Fpd3zWGzmHF+H5MDi8fOWXfZPTYvqff4vEkugDmKyyYlNSezLLVI3y6BK2PK1Y0sBVPEKw4v
	usTcwHhcsIuRk0NCwETi97P1bBC2mMSFeyA2F4eQwDJGiStrdrHBFL169pAJIrGIUeLEv+/M
	EM5fRok7R76xglSxCWhIHH7/jB0kISIwiVFi7f+fjCAJIQEniS0nfzCD2JwCzkDdk8AahAUc
	JBYtnwxWwyKgKvH5/GeWLkYODl4BW4lnr6tBwrwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOW
	GaRcQkBd4tFfXZCwiICRxMrfX6BKRCT2vXjHCHKOhMAhdomd61czQawSkPg2+RALRK+sxKYD
	zBBPSkocXHGDZQKj+Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7
	iRESc307GG8esD7EmAy0fiKzlGhyPjBm80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8s
	Sc1OTS1ILYovKs1JLT7EyMTBKdXA6LOIpaFQU9OW6Ze9bCPb4l2ef93rvil0iDZv5XDW37/0
	ouziVwoPbi+13jLPZv46FwspCcd2e6dyh3U9LdbZz944lnBLZVw4m2EYN7Xnm6UDY8OdhwX7
	u25NYLA2Cld75hCrvUI6tmWh5cO/TdZBz85/mXPrgLtQ8eyqziMHm5o3bFQ/5LdRiaU4I9FQ
	i7moOBEAC0ZEl88CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAV337TsDDXbtELY407We1WLT42us
	Fpd3zWGzmHF+H5MDi8fOWXfZPTYvqff4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFjytWNLAVTxCsOL7rE3MB4XLCLkZNDQsBE4tWzh0wQtpjEhXvr2boYuTiE
	BBYxSpz4950ZwvnLKHHnyDdWkCo2AQ2Jw++fsYMkRAQmMUqs/f+TESQhJOAkseXkD2YQm1PA
	Gah7EliDsICDxKLlk8FqWARUJT6f/8zSxcjBwStgK/HsdTVImFdAUOLH5HssIDazgJbE+p3H
	mSBseYnNa94yg5RLCKhLPPqrCxIWETCSWPn7C1SJiMS+F+8YJzAKzkIyaRaSSbOQTJqFpGUB
	I8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCIfia9g3FVg8UhRgEORiUe3pcXdgQKsSaW
	FVfmHmKU4GBWEuG9OXVnoBBvSmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnA5NNXkm8obGJmZGl
	kZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwphrmlrNd1Xs6e26Yo5T4nLab
	D5fksml0Mp97+naKbupchwXTnEJ+nBTYHBEVx7HsC1u85OcLcX/4eqKdr12LN+Rnj3HpE/Jq
	S3Djyj/mvPGpU6FQUs3RgEuLTnqwCy/h/3dQImd/w0VfB9PqWiZ2PccvojwP//5cfbLM/Fd4
	4YrXLSleZxiVWIozEg21mIuKEwHOXelNLAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Girish K S wrote:
> 
> This patch enables the SPI in EXYNOS5440 SoC. The NOR
> Flash can be accessed by enabling the spi interface
> 
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5440-ssdk5440.dts |   39
> +++++++++++++++++++++++++++-
>  arch/arm/boot/dts/exynos5440.dtsi         |   16 +++++++----
>  2 files changed, 47 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> index d55042b..a85ac0e 100644
> --- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> +++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> @@ -20,8 +20,43 @@
>  		bootargs = "root=/dev/sda2 rw rootwait ignore_loglevel
> early_printk no_console_suspend mem=2048M@0x80000000
> console=ttySAC0,115200";
>  	};
> 
> -	spi {
> -		status = "disabled";
> +	spi_0: spi@D0000 {
> +
> +		flash: w25q128@0 {
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			compatible = "winbond,w25q128";
> +			spi-max-frequency = <15625000>;
> +			reg = <0>;
> +			controller-data {
> +				samsung,spi-feedback-delay = <0>;
> +			};
> +
> +			partition@00000 {
> +				label = "BootLoader";
> +				reg = <0x60000 0x80000>;
> +				read-only;
> +			};
> +
> +			partition@e0000 {
> +				label = "Recovery-Kernel";
> +				reg = <0xe0000 0x300000>;
> +				read-only;
> +			};
> +
> +			partition@3e0000 {
> +				label = "CRAM-FS";
> +				reg = <0x3e0000 0x700000>;
> +				read-only;
> +			};
> +
> +			partition@ae0000 {
> +				label = "User-Data";
> +				reg = <0xae0000 0x520000>;
> +			};
> +
> +		};
> +
>  	};
> 
>  	fixed-rate-clocks {
> diff --git a/arch/arm/boot/dts/exynos5440.dtsi
> b/arch/arm/boot/dts/exynos5440.dtsi
> index f6b1c89..7c5dc38 100644
> --- a/arch/arm/boot/dts/exynos5440.dtsi
> +++ b/arch/arm/boot/dts/exynos5440.dtsi
> @@ -16,6 +16,10 @@
> 
>  	interrupt-parent = <&gic>;
> 
> +	aliases {
> +		spi0 = &spi_0;
> +	};
> +
>  	clock: clock-controller@0x160000 {
>  		compatible = "samsung,exynos5440-clock";
>  		reg = <0x160000 0x1000>;
> @@ -101,15 +105,15 @@
>  		clock-names = "uart", "clk_uart_baud0";
>  	};
> 
> -	spi {
> -		compatible = "samsung,exynos4210-spi";
> -		reg = <0xD0000 0x1000>;
> +	spi_0: spi@D0000 {
> +		compatible = "samsung,exynos5440-spi";
> +		reg = <0xD0000 0x100>;
>  		interrupts = <0 4 0>;
> -		tx-dma-channel = <&pdma0 5>; /* preliminary */
> -		rx-dma-channel = <&pdma0 4>; /* preliminary */
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> -		clocks = <&clock 21>, <&clock 16>;
> +		samsung,spi-src-clk = <0>;
> +		num-cs = <1>;
> +		clocks = <&clock 8>, <&clock 3>;

Should be,
+		clocks = <&clock 21>, <&clock 16>;

>  		clock-names = "spi", "spi_busclk0";
>  	};
> 
> --

Others, look good to me, and please create separated patches for SoC and
board.

Anway, will apply with fix the clock.

Thanks,
- Kukjin

