Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKJPjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:39:15 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44420 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292AbaKJPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:39:14 -0500
Date: Mon, 10 Nov 2014 16:39:12 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: at91: sama5d4: Add SFR
Message-ID: <20141110153912.GU4068@piout.net>
References: <1415632471-14672-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1415632471-14672-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415632471-14672-3-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 at 16:14:31 +0100, Alexandre Belloni wrote :
> The sama4d4 has Special Function Registers that allow to manage DDR, OHCI, EBI
> and AIC interrupt redirection.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/sama5d4.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
> index e0157b0f075c..580486b056fc 100644
> --- a/arch/arm/boot/dts/sama5d4.dtsi
> +++ b/arch/arm/boot/dts/sama5d4.dtsi
> @@ -826,6 +826,11 @@
>  				status = "disabled";
>  			};
>  
> +			sfr: sfr@f8028000 {
> +				compatible = "atmel,sama5d4-sfr", "syscon";
> +				reg = <0xf0038000 0x4000>;

Obviously, that should be reg = <0xf8028000 0x4000>, I'll fix it

> +			};
> +
>  			mmc1: mmc@fc000000 {
>  				compatible = "atmel,hsmci";
>  				reg = <0xfc000000 0x600>;
> -- 
> 2.1.0
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
