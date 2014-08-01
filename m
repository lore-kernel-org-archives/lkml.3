Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaHALnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 07:43:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbaHALnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 07:43:04 -0400
Message-ID: <53DB7D41.2070000@suse.de>
Date: Fri, 01 Aug 2014 13:42:57 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: Re: [PATCH v5 06/10] ARM: dts: Clean up exynos5250-smdk5250
References: <1406868897-26874-1-git-send-email-afaerber@suse.de> <1406868897-26874-7-git-send-email-afaerber@suse.de>
In-Reply-To: <1406868897-26874-7-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.08.2014 06:54, schrieb Andreas Färber:
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index ff1c09607631..30482fc523f9 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -215,7 +215,7 @@
>  		clock-names = "fimg2d";
>  	};
>  
> -	codec@11000000 {
> +	codec: codec@11000000 {
>  		compatible = "samsung,mfc-v6";
>  		reg = <0x11000000 0x10000>;
>  		interrupts = <0 96 0>;

I notice that Ajay's iommu patch uses mfc here, so let's use it here,
too. Affects patches 7 and 10.

Andreas

> @@ -258,7 +258,7 @@
>  		clock-names = "uart", "clk_uart_baud0";
>  	};
>  
> -	sata@122F0000 {
> +	sata: sata@122F0000 {
>  		compatible = "snps,dwc-ahci";
>  		samsung,sata-freq = <66>;
>  		reg = <0x122F0000 0x1ff>;

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
