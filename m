Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaIVMDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:03:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58401 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaIVMDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:03:33 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-28-542010131382
From: Kukjin Kim <kgene@kernel.org>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <1411387317-4837-1-git-send-email-tomasz.figa@gmail.com>
In-reply-to: <1411387317-4837-1-git-send-email-tomasz.figa@gmail.com>
Subject: RE: [PATCH] ARM: dts: s3c64xx: Enable PWM node by default
Date: Mon, 22 Sep 2014 21:03:28 +0900
Message-id: <019301cfd65d$39bc5460$ad34fd20$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFuTwGcLqmvDoLQgCsc9oF7otn3Q5zQHEnw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ11hAYUQg48nmC3+TjrGbrHp8TVW
	i8u75rBZzDi/j8li7ZG77Banrn9ms1i16w+jA7vH71+TGD12zrrL7rF5Sb3HlRNNrB59W1Yx
	enzeJBfAFsVlk5Kak1mWWqRvl8CV0bu1kangH1fFybVLmBoYn3F0MXJwSAiYSGz7pNHFyAlk
	iklcuLeeDcQWEljGKHH4kDBE3ERi/8EzTF2MXEDxRYwS3/t2skI4fxkl7l9sYwMZxCagLNHY
	pA/SICygJbFwSxMLiC0i4COxe94UNpB6ZoG9jBJrzr2H2uAi8a29jxnE5hRwlfj86icrRLOT
	xML5fSwgM1kEVCUO3DEACfMKWEj8nH2SBcIWlPgx+R6YzQy0a/3O40wQtrzE5jVvmSGOVpDY
	cfY1I8QNRhJvO3rZIWpEJPa9eMcIco+EwF92ic6Z38EGsQgISHybfIgFEiiyEpsOQM2RlDi4
	4gbLBEbJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyS2J+xg
	vHfA+hCjAAejEg/vjxb5ECHWxLLiytxDjKZAF01klhJNzgcmkLySeENjMyMLUxNTYyNzSzMl
	cd7XUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTA6zUhucfO2/cRprMITUft7m+PDBsGm
	xFV5dRwb0h+e+/jds0naetrUIvZZpz7GWv5Z13no9OapzOdNLp5Ic9vMW7S69OyJFJ1TSf8m
	L5hmN81L7cX+67WHK93+ZCzdsaq0463w4sOHwrmztXk2O7SyTgpRfJhsurJ51qrntt87v/x0
	2NnSu+CdEktxRqKhFnNRcSIAYFswB+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAV0hAYUQg+mHbCz+TjrGbrHp8TVW
	i8u75rBZzDi/j8li7ZG77Banrn9ms1i16w+jA7vH71+TGD12zrrL7rF5Sb3HlRNNrB59W1Yx
	enzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaN3ayNTwT+uipNr
	lzA1MD7j6GLk5JAQMJHYf/AME4QtJnHh3nq2LkYuDiGBRYwS3/t2skI4fxkl7l9sA8pwcLAJ
	KEs0NumDNAgLaEks3NLEAmKLCPhI7J43BayZWWAvo8Sac+/ZQBJCAi4S39r7mEFsTgFXic+v
	frJCNDtJLJzfxwIyk0VAVeLAHQOQMK+AhcTP2SdZIGxBiR+T74HZzEC71u88zgRhy0tsXvOW
	GeJoBYkdZ18zQtxgJPG2o5cdokZEYt+Ld4wTGIVnIRk1C8moWUhGzULSsoCRZRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcPJ4Jr2DcVWDxSFGAQ5GJR7eHy3yIUKsiWXFlbmHGCU4mJVE
	eH15FEKEeFMSK6tSi/Lji0pzUosPMZoCPTqRWUo0OR+Y2PJK4g2NTcyMLI3MLIxMzM2VxHkP
	tloHCgmkJ5akZqemFqQWwfQxcXBKNTAyXjOdIqn+Mv6T1gfxzJiu5/Hl2drf+mOZdlUmluZa
	cB9Yt7BO4ld/UrTadzu5Ozm//xqkzbm6+OzPM3t3qd678ST2317lcgU3xrn/2dY0/LhUXGUV
	ksLi7Sw0c6Ehi7+hFXPU9V0N3/Qsi5Vfc/xzjlS6eaudecvVtFv8W54KOZge3SeuyKLEUpyR
	aKjFXFScCACvwECrNAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> The PWM block is required for system clock source so it must be always
> enabled. This patch fixes boot issues on SMDK6410 which did not have the
> node enabled explicitly for other purposes.
> 
> Fixes: eeb93d02c5d8 ("clocksource: of: Respect device tree node status")
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  arch/arm/boot/dts/s3c6410-mini6410.dts | 4 ----
>  arch/arm/boot/dts/s3c64xx.dtsi         | 1 -
>  2 files changed, 5 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/s3c6410-mini6410.dts b/arch/arm/boot/dts/s3c6410-mini6410.dts
> index a171cdd26b7f..42c2bcdf2626 100644
> --- a/arch/arm/boot/dts/s3c6410-mini6410.dts
> +++ b/arch/arm/boot/dts/s3c6410-mini6410.dts
> @@ -252,10 +252,6 @@
>  	status = "okay";
>  };
> 
> -&pwm {
> -	status = "okay";
> -};
> -
>  &pinctrl0 {
>  	gpio_leds: gpio-leds {
>  		samsung,pins = "gpk-4", "gpk-5", "gpk-6", "gpk-7";
> diff --git a/arch/arm/boot/dts/s3c64xx.dtsi b/arch/arm/boot/dts/s3c64xx.dtsi
> index 05c717ad1edd..196fe6ea205d 100644
> --- a/arch/arm/boot/dts/s3c64xx.dtsi
> +++ b/arch/arm/boot/dts/s3c64xx.dtsi
> @@ -239,7 +239,6 @@
>  			clocks = <&clocks PCLK_PWM>;
>  			samsung,pwm-outputs = <0>, <1>;
>  			#pwm-cells = <3>;
> -			status = "disabled";
>  		};
> 
>  		pinctrl0: pinctrl@7f008000 {
> --
> 2.1.0

Looks good, will apply.

Thanks,
Kukjin

