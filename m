Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbaIKQR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:17:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59699 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaIKQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:17:26 -0400
Message-ID: <5411CAE7.9010108@ti.com>
Date: Thu, 11 Sep 2014 12:16:39 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: keystone: dts: fix bindings for pcie and usb clock
 nodes
References: <1410450009-19892-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1410450009-19892-1-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2014 11:40 AM, Murali Karicheri wrote:
> Fix incorrect clock names for usb1, pcie1 and domain register
> offset for pcie1 clock nodes on K2E EVM
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
Thanks Murali. I will queue this up.

>  arch/arm/boot/dts/k2e-clocks.dtsi |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/k2e-clocks.dtsi b/arch/arm/boot/dts/k2e-clocks.dtsi
> index 598afe9..4773d6a 100644
> --- a/arch/arm/boot/dts/k2e-clocks.dtsi
> +++ b/arch/arm/boot/dts/k2e-clocks.dtsi
> @@ -40,7 +40,7 @@ clocks {
>  		#clock-cells = <0>;
>  		compatible = "ti,keystone,psc-clock";
>  		clocks = <&chipclk16>;
> -		clock-output-names = "usb";
> +		clock-output-names = "usb1";
>  		reg = <0x02350004 0xb00>, <0x02350000 0x400>;
>  		reg-names = "control", "domain";
>  		domain-id = <0>;
> @@ -60,8 +60,8 @@ clocks {
>  		#clock-cells = <0>;
>  		compatible = "ti,keystone,psc-clock";
>  		clocks = <&chipclk12>;
> -		clock-output-names = "pcie";
> -		reg = <0x0235006c 0xb00>, <0x02350000 0x400>;
> +		clock-output-names = "pcie1";
> +		reg = <0x0235006c 0xb00>, <0x02350048 0x400>;
>  		reg-names = "control", "domain";
>  		domain-id = <18>;
>  	};
> 

