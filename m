Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3HFHve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:51:34 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45860 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3HFHvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:51:32 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ARM: dts: Add USB host node for Exynos4
Date: Tue, 06 Aug 2013 09:51:26 +0200
Message-ID: <3592591.kYsJ5mO7Zi@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1375726159-20486-1-git-send-email-tobetter@gmail.com>
References: <1375726159-20486-1-git-send-email-tobetter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dongjin,

On Tuesday 06 of August 2013 03:09:19 Dongjin Kim wrote:
> This patch adds EHCI and OHCI host device nodes for Exynos4.
> 
> CC: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4.dtsi |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4.dtsi
> b/arch/arm/boot/dts/exynos4.dtsi index 3f94fe8..cbe5219 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -155,6 +155,24 @@
>  		status = "disabled";
>  	};
> 
> +	ehci@12580000 {
> +		compatible = "samsung,exynos4210-ehci";
> +		reg = <0x12580000 0x100>;
> +		interrupts = <0 70 0>;
> +		clocks = <&clock 304>;
> +		clock-names = "usbhost";
> +		status = "disabled";
> +	};
> +
> +	ohci@12590000 {
> +		compatible = "samsung,exynos4210-ohci";
> +		reg = <0x12590000 0x100>;
> +		interrupts = <0 70 0>;
> +		clocks = <&clock 304>;
> +		clock-names = "usbhost";
> +		status = "disabled";
> +	};
> +
>  	mfc: codec@13400000 {
>  		compatible = "samsung,mfc-v5";
>  		reg = <0x13400000 0x10000>;

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

