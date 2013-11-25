Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3KYPOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:14:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30931 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3KYPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:14:46 -0500
X-AuditID: cbfee61a-b7f316d000007e34-23-52936964641d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] thermal: offer Samsung thermal support only when
 ARCH_EXYNOS is defined
Date: Mon, 25 Nov 2013 16:14:32 +0100
Message-id: <6304764.ZpvNMfgtqL@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2958660.aJeCDrTTOe@amdc1032>
References: <2958660.aJeCDrTTOe@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd2UzMlBBo8O6Fs0XA2xWLP/J5PF
	2aY37BaXd81hs/jce4TRYsb5fUwWTx72sTmweyze85LJo2/LKkaP4ze2M3l83iQXwBLFZZOS
	mpNZllqkb5fAldHRt4+9YBVHxerGY6wNjF/Zuhg5OCQETCTePzPoYuQEMsUkLtxbDxTm4hAS
	WMQocfvLOUaQhJBAC5PEyQfxIDabgJXExPZVYHERAT2JGy+eMIHYzAL3GCUufskCsYUF4iR2
	zF7HCmKzCKhK9HSsYQaxeQU0Jfb0nQCzRQU8JXZsXwl2A6eAlsTld5wQqzQlmi61sUCUC0r8
	mHyPBWK8vMS+/VNZIWwtifU7jzNNYBSYhaRsFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIDupnUjsYVzZYHGIU4GBU4uG1qJwUJMSaWFZcmXuIUYKDWUmEd5rB5CAh3pTE
	yqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjBe3dWUIx6q+Odb9
	RvLYEucgzrW7u4WnV9fM4wr8XT2tZpG73eXDe172TDv7+f7Wag3F3qSgjvVqGyb93mJ1Le3l
	oc1TpHaZ3XO7wOn0u+Lw/JM+Ufor730/l1ETssWIY6rUlgVlfEo+PL085975/5deLB9nI3vL
	S+uTgan47Pcn57FwL7gW/0+JpTgj0VCLuag4EQALNHNfZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Could you please apply this patch?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Friday, October 04, 2013 02:36:42 PM Bartlomiej Zolnierkiewicz wrote:
> Menu for Samsung thermal support is visible on all Samsung
> platforms while thermal drivers are currently available only
> for EXYNOS SoCs. Fix it by replacing PLAT_SAMSUNG dependency
> with ARCH_EXYNOS one.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index a709c63..05cf95c 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -198,7 +198,7 @@ source "drivers/thermal/ti-soc-thermal/Kconfig"
>  endmenu
>  
>  menu "Samsung thermal drivers"
> -depends on PLAT_SAMSUNG
> +depends on ARCH_EXYNOS
>  source "drivers/thermal/samsung/Kconfig"
>  endmenu

