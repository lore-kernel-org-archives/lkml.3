Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3CKHJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:09:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11086 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3CKHJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:09:26 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-8d-513d8325e03b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1362856081.3137.19.camel@x61.thuisdomein>
In-reply-to: <1362856081.3137.19.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: S3C24XX: drop "select MACH_NEO1973"
Date: Mon, 11 Mar 2013 16:09:24 +0900
Message-id: <052301ce1e27$5cc9cd10$165d6730$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4c+WzplIGhOdenT1Wy3YBszNDfTwBLbcbg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zY13VZttAg51LWSwmrTvAZLHp8TVW
	i8u75rBZzDi/j8ni9mVei0W3zjA7sHm0NPewefxd9YLZY/OSeo+N258weXzeJBfAGsVlk5Ka
	k1mWWqRvl8CVsb59HXPBAq6KWx2djA2MMzi6GDk5JARMJE6dameGsMUkLtxbz9bFyMUhJLCM
	UWLJ8WWsMEV9y/4xQySmM0rMf94CVfWXUeLLxMfsIFVsAhoSh98/A7NFBIolNu+5xtTFyMHB
	LJAtseUVE0hYSMBMYuPcDjYQm1PAXGJN2xKwzcICthKHnjaygNgsAqoSbxsfgtXzAsWX/PzK
	CGELSvyYfI8FYqS6xJQpuSBhZgF5ic1r3jKDhCWAwo/+6kIcYCTx9sJ5NogSEYl9L94xglws
	IXCPXeLEhMnMEKsEJL5NPsQC0SsrsekANBwkJQ6uuMEygVFiFpLFsxAWz0KyeBaSDQsYWVYx
	iqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTqxB2M9w9YH2JMBto+kVlKNDkfGOt5JfGGxmZG
	FqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDk1w5c+9MvaaP1
	5/zduhb+r6bb6Ui9VLuQs3+ZsuL1/BczjVaFs0yfP3Wu35f+3OR0fZ33rRueFrQes507/wbT
	nF03Mm9JTCuW/Swlu0/2r/vDeMc5Dh67uaw+GYkzq57qa868+/9nxfMA5wO+S32Cf3GfdXvi
	8fvVrvXPazLuR39IcyjJT12oxFKckWioxVxUnAgAHdRIhOsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV2VZttAgyMfbCwmrTvAZLHp8TVW
	i8u75rBZzDi/j8ni9mVei0W3zjA7sHm0NPewefxd9YLZY/OSeo+N258weXzeJBfAGtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWN9+zrmggVcFbc6OhkbGGdwdDFyckgI
	mEj0LfvHDGGLSVy4t56ti5GLQ0hgOqPE/OctUM5fRokvEx+zg1SxCWhIHH7/DMwWESiW2Lzn
	GlMXIwcHs0C2xJZXTCBhIQEziY1zO9hAbE4Bc4k1bUvAFggL2EocetrIAmKzCKhKvG18CFbP
	CxRf8vMrI4QtKPFj8j0WiJHqElOm5IKEmQXkJTavecsMEpYACj/6qwtxgJHE2wvn2SBKRCT2
	vXjHOIFRaBaSQbMQBs1CMmgWko4FjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYITwTOp
	HYwrGywOMQpwMCrx8E7QsQ0UYk0sK67MPcQowcGsJMK7cpNNoBBvSmJlVWpRfnxRaU5q8SHG
	ZKA3JzJLiSbnA5NUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwTqko+ZC8xa/yy7ab5oduODjcrJHv6zHrr+vaFTibv3XF9IX70qZkTIyedXf7PJePP7+d
	d8+7KMCr9uwYy4mCmF+ThIOKpLO+3erj85zZNPHycxvpKcGqszbVl07eU555WbJ3X8TSu8k5
	nvuFvRklTQ9LejxYe+yRvZjYP46irYcCYxKS3yTXKrEUZyQaajEXFScCAMwrpO9IAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> The Kconfig entry for the Openmoko GTA02 / Freerunner phone selects
> MACH_NEO1973. But there is no Kconfig symbol MACH_NEO1973. The select
> statement for that symbol is a nop. It can safely be dropped.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with "git grep".
> 
> 1) There appear to be repositories that carry a "config MACH_NEO1973" in
> their tree. I guess it is used to collect functionality common to the
> GTA01 and the GTA02. But except for this select statement, MACH_NEO1973
> was never used in mainline. So if the GTA01 code ever gets merged into
> mainline, this select statement might be added once more (if it is
> actually needed then).
> 
>  arch/arm/mach-s3c24xx/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index 7361b9d..bec43fe 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -641,7 +641,6 @@ comment "S3C2442 Boards"
>  config MACH_NEO1973_GTA02
>  	bool "Openmoko GTA02 / Freerunner phone"
>  	select I2C
> -	select MACH_NEO1973
>  	select MFD_PCF50633
>  	select PCF50633_GPIO
>  	select POWER_SUPPLY
> --
> 1.7.11.7

Yeah, we don't need it.

Applied, thanks.

- Kukjin

