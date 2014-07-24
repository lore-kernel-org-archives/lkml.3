Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaGXJcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:32:09 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43009 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaGXJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:32:07 -0400
MIME-Version: 1.0
In-Reply-To: <1405475714-10006-5-git-send-email-huayi.li@csr.com>
References: <1405475714-10006-1-git-send-email-huayi.li@csr.com> <1405475714-10006-5-git-send-email-huayi.li@csr.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 24 Jul 2014 17:31:46 +0800
Message-ID: <CAGsJ_4xoJ832rtSigL2WxRZGhmxy33Mn-MtrRzS57j7T0axC5A@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] ARM: prima2_defconfig: enable PWM and sirf PWM driver
To: Huayi Li <huayi.li@csr.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rongjun Ying <rongjun.ying@csr.com>, Barry Song <barry.song@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-16 9:55 GMT+08:00 Huayi Li <huayi.li@csr.com>:
> Signed-off-by: Huayi Li <huayi.li@csr.com>

Acked-by: Barry Song <Baohua.Song@csr.com>

> ---
>  arch/arm/configs/prima2_defconfig | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/configs/prima2_defconfig b/arch/arm/configs/prima2_defconfig
> index 23591db..303204a 100644
> --- a/arch/arm/configs/prima2_defconfig
> +++ b/arch/arm/configs/prima2_defconfig
> @@ -50,6 +50,8 @@ CONFIG_DMADEVICES_DEBUG=y
>  CONFIG_DMADEVICES_VDEBUG=y
>  CONFIG_SIRF_DMA=y
>  # CONFIG_IOMMU_SUPPORT is not set
> +CONFIG_PWM=y
> +CONFIG_PWM_SIRF=y
>  CONFIG_EXT2_FS=y
>  CONFIG_MSDOS_FS=y
>  CONFIG_VFAT_FS=y
> --
> 1.9.3
>
