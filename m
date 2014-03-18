Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaCRQKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:10:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48774 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbaCRQKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:10:14 -0400
Message-ID: <53286FBF.6050708@ti.com>
Date: Tue, 18 Mar 2014 12:09:35 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH] ARM: dts: keystone: Fix control register range for clktsip
References: <1395148991-22538-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1395148991-22538-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2014 09:23 AM, Ivan Khoronzhuk wrote:
> The control register range for clktsio interferes with clkaemifspi clock.
> And it causes issues for NAND/AEMIF. So fix it.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
> 
> Only comment is corrected.
> 
Thanks .. Applying for 3.15-fixes

>  arch/arm/boot/dts/k2hk-clocks.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/k2hk-clocks.dtsi b/arch/arm/boot/dts/k2hk-clocks.dtsi
> index a71aa29..8855b1f 100644
> --- a/arch/arm/boot/dts/k2hk-clocks.dtsi
> +++ b/arch/arm/boot/dts/k2hk-clocks.dtsi
> @@ -59,7 +59,7 @@ clocks {
>  		compatible = "ti,keystone,psc-clock";
>  		clocks = <&chipclk16>;
>  		clock-output-names = "tsip";
> -		reg = <0x0235000c 0xb00>, <0x02350000 0x400>;
> +		reg = <0x02350000 0xb00>, <0x02350000 0x400>;
>  		reg-names = "control", "domain";
>  		domain-id = <0>;
>  	};
> 

