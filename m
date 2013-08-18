Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3HRUIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:08:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51382 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3HRUIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:08:10 -0400
Message-ID: <521129A0.9050404@samsung.com>
Date: Mon, 19 Aug 2013 05:08:00 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Dongjin Kim <tobetter@gmail.com>
CC: unlisted-recipients:"; Jingoo Han" <jg1.han@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;Jingoo Han <jg1.han@samsung.com>
					     ^-missing end of address
Subject: Re: [PATCH RESEND] ARM: dts: Add USB host node for Exynos4
References: <1375726159-20486-1-git-send-email-tobetter@gmail.com>
In-Reply-To: <1375726159-20486-1-git-send-email-tobetter@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/13 03:09, Dongjin Kim wrote:
> This patch adds EHCI and OHCI host device nodes for Exynos4.
>
> CC: Jingoo Han<jg1.han@samsung.com>
> Signed-off-by: Dongjin Kim<tobetter@gmail.com>
> ---
>   arch/arm/boot/dts/exynos4.dtsi |   18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> index 3f94fe8..cbe5219 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -155,6 +155,24 @@
>   		status = "disabled";
>   	};
>
> +	ehci@12580000 {
> +		compatible = "samsung,exynos4210-ehci";
> +		reg =<0x12580000 0x100>;
> +		interrupts =<0 70 0>;
> +		clocks =<&clock 304>;
> +		clock-names = "usbhost";
> +		status = "disabled";
> +	};
> +
> +	ohci@12590000 {
> +		compatible = "samsung,exynos4210-ohci";
> +		reg =<0x12590000 0x100>;
> +		interrupts =<0 70 0>;
> +		clocks =<&clock 304>;
> +		clock-names = "usbhost";
> +		status = "disabled";
> +	};
> +
>   	mfc: codec@13400000 {
>   		compatible = "samsung,mfc-v5";
>   		reg =<0x13400000 0x10000>;

Applied, thanks.

- Kukjin
