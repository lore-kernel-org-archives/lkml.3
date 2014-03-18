Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaCRQKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:10:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47079 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbaCRQKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:10:06 -0400
Message-ID: <53286FB2.1040903@ti.com>
Date: Tue, 18 Mar 2014 12:09:22 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: keystone: Fix domain register range for clkfftc1
References: <1395148697-22481-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1395148697-22481-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2014 09:18 AM, Ivan Khoronzhuk wrote:
> The domain register range for clkfftc1 has to be 0x0235004c
> instead of 0x023504c0.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
Thanks .. Applying for 3.15-fixes

>  arch/arm/boot/dts/k2hk-clocks.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/k2hk-clocks.dtsi b/arch/arm/boot/dts/k2hk-clocks.dtsi
> index 8855b1f..96e6536 100644
> --- a/arch/arm/boot/dts/k2hk-clocks.dtsi
> +++ b/arch/arm/boot/dts/k2hk-clocks.dtsi
> @@ -209,7 +209,7 @@ clocks {
>  		compatible = "ti,keystone,psc-clock";
>  		clocks = <&chipclk13>;
>  		clock-output-names = "fftc-1";
> -		reg = <0x02350074 0xb00>, <0x023504c0 0x400>;
> +		reg = <0x02350074 0xb00>, <0x0235004c 0x400>;
>  		reg-names = "control", "domain";
>  		domain-id = <19>;
>  	};
> 

