Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab3GXOEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:04:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56071 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3GXOEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:04:02 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-08-51efdecfae88
From: Tomasz Figa <t.figa@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>, arnd@arndb.de,
        linus.walleij@stericsson.com, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 07/22] ARM: Exynos4210: Remove '0x's from Exynos4110
 DTSI file
Date: Wed, 24 Jul 2013 16:03:55 +0200
Message-id: <6156493.tCYrm4xD5A@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <20130724123931.GL26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
 <20130724123931.GL26801@laptop>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7rn770PNHh1VNzi76Rj7Ba9C66y
	Wdz/epTRYk3LWxaLTY+vsVpc3jWHzWLG+X1MFqt2/WF04PD4/WsSo8fOWXfZPe5c28PmsXlJ
	vUffllWMHt+XrmH3+LxJLoA9issmJTUnsyy1SN8ugStj+w2rgqXsFUf3OzYwHmDtYuTkkBAw
	kZj0dzo7hC0mceHeerYuRi4OIYGljBLP17xlhnC6mCRWbuhlAqliE1CT+NzwCKiKg0NEQEXi
	3BtzkBpmgaeMEl1vJoHVCAuES1zom88CYrMIqErMfPGADcTmFdCUmDbrO1gNv4C6xLttT5lA
	5ogKuElM+JgPEuYU0JF4132aFWLvQkaJiRPvMUL0Ckr8mHwPbCazgLzEvv1TWSFsLYn1O48z
	TWAUnIWkbBaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImLLzsYFx+zOsQo
	wMGoxMNbOOtdoBBrYllxZe4hRgkOZiURXqv57wOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MK77
	MGmGOVfZubkvzn49v37SgvbeyNfuEjObdugq2QtM+SRlYRfPqH6R/YNxXW3f9gV5BY9fqtwT
	VVwVwGV+r/72pDN8JxcmCLDeupiwPao/6o7ZgXr28lkNvYc36XzrYo9XaZBn37V+9nZ9Za3K
	yBn/g1X+fnx8xmT33k9Ntv9vv+Xpuqq/rkyJpTgj0VCLuag4EQAg1u44aQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 of July 2013 13:39:31 Lee Jones wrote:
> ... for the sake of consistency and assumed convention.
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> diff --git a/arch/arm/boot/dts/exynos4210.dtsi
> b/arch/arm/boot/dts/exynos4210.dtsi index b7f358a..53e2527 100644
> --- a/arch/arm/boot/dts/exynos4210.dtsi
> +++ b/arch/arm/boot/dts/exynos4210.dtsi
> @@ -72,7 +72,7 @@
>                 };
>         };
> 
> -       clock: clock-controller@0x10030000 {
> +       clock: clock-controller@10030000 {
>                 compatible = "samsung,exynos4210-clock";
>                 reg = <0x10030000 0x20000>;
>                 #clock-cells = <1>;

Looks good to me, except the subject which is still wrong - 
s/Exynos4110/Exynos4210/.

I guess it might be fixed when applying, though.

Best regards,
Tomasz

