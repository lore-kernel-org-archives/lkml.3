Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3IWMa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:30:29 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17011 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IWMa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:30:28 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-c0-524034621e81
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Spi s3c64xx fix for s5pv210
Date: Mon, 23 Sep 2013 14:30:15 +0200
Message-id: <4120929.6ZpEed2iin@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379929379-27245-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379929379-27245-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7pJJg5BBu9nSVhMffiEzeJs0xt2
	i8u75rBZNH68yW5xes0pZou1R+6yO7B5bFrVyeZx8N0eJo++LasYPT5vkgtgieKySUnNySxL
	LdK3S+DKuDprNVvBFvaKL1PXMTYwTmTrYuTgkBAwkVg0P7yLkRPIFJO4cG89UJiLQ0hgKaPE
	jM+bWCGcLiaJvyfOMINUsQmoSXxueMQGYosImEq8u3sNrINZYAajxLGt81lBEsICBhI/d7wD
	s1kEVCWaf/5kBLF5BTQlpp4/BWbzC6hLvNv2lAnEFhVwlfi0cCM7iM0p4C/xs60PzBYS8JNY
	cngHM0SvoMSPyfdYQGxmAXmJffunskLYWhLrdx5nmsAoOAtJ2SwkZbOQlC1gZF7FKJpamlxQ
	nJSea6hXnJhbXJqXrpecn7uJERLqX3YwLj5mdYhRgINRiYc3ItE+SIg1say4MvcQowQHs5II
	7yJFhyAh3pTEyqrUovz4otKc1OJDjEwcnFINjPmSIhkqplP6w0ve7E62t6+JVu442b58u2+1
	LSdLa8DsffLbc/8nVNiEba1hz3GUq82pXum47EHBtdnH5AV+mKifUYlPvsZ1/1brtYhf+Sk9
	dcWqdbN/XD9iy/DxxsaNT4ImTQ3LfGCpI1PYlXyHPSav3771/T7Hqpx+ZuFTDDk+6lNK5E4r
	sRRnJBpqMRcVJwIANCoNqFMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Monday 23 of September 2013 11:42:59 Mateusz Krawczuk wrote:
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/spi/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 734eaa5..124d7fa 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -394,7 +394,7 @@ config SPI_S3C24XX_FIQ
> 
>  config SPI_S3C64XX
>  	tristate "Samsung S3C64XX series type SPI"
> -	depends on (ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5P64X0 ||
> ARCH_EXYNOS) +	depends on (ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210
> || ARCH_S5P64X0 || ARCH_EXYNOS) select S3C64XX_DMA if ARCH_S3C64XX

Please replace all these symbols above with a simple dependency on 
PLAT_SAMSUNG, since this driver covers all the Samsung ARCHs anyway.

Best regards,
Tomasz

