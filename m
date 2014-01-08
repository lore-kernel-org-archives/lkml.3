Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaAHAc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:32:57 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:52327 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaAHAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:32:41 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Naveen Krishna Ch <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 5/5] ARM: exynos5420: add dt node for sss module
Date: Wed, 08 Jan 2014 01:32:35 +0100
Message-ID: <1420297.0gEDu9oNDc@flatron>
User-Agent: KMail/4.12 (Linux/3.12.6-gentoo; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com> <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 of January 2014 17:21:49 Naveen Krishna Ch wrote:
> From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> 
> this patch adds the device tree nodes for SSS module found on Exynos5420

nit: Sentences in English start with a capital letter. Also this patch
adds one node, not few of them as the description suggests.

Also patch subject should start with ARM: dts: prefix.

> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 11dd202..97045f9 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -652,4 +652,14 @@
>  		clocks = <&clock 319>, <&clock 318>;
>  		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>  	};
> +
> +	sss: sss {

Node name should be sss@10830000 as per ePAPR node naming recommendation.

Best regards,
Tomasz

