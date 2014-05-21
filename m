Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaEUO5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:57:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56311 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbaEUO5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:57:15 -0400
Message-ID: <537CBEA9.2090105@ti.com>
Date: Wed, 21 May 2014 17:56:41 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <santosh.shilimkar@ti.com>
CC: <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <grygorii.strashko@ti.com>, <m-karicheri2@ti.com>
Subject: Re: [Patch] ARM: dts: keystone: add device state control syscon entry
References: <1400681760-24351-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1400681760-24351-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore this. It'll be included in "Introduce keystone reset driver" 
patch series

On 05/21/2014 05:16 PM, Ivan Khoronzhuk wrote:
> Device state control registers has register regions with different
> purposes so add syscon entry in order to be able to correctly access
> them from appropriate places.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>
> Based on linux-next/master
>
>   arch/arm/boot/dts/keystone.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
> index 5e67c5b..8b899ba 100644
> --- a/arch/arm/boot/dts/keystone.dtsi
> +++ b/arch/arm/boot/dts/keystone.dtsi
> @@ -71,6 +71,11 @@
>   			reg = <0x2310000 0x200>;
>   		};
>   
> +		devctrl: device_state_control {
> +			compatible = "ti,keystone-devctrl", "syscon";
> +			reg = <0x2620000 0x1000>;
> +		};
> +
>   		rstctrl: reset-controller {
>   			compatible = "ti,keystone-reset";
>   			reg = <0x023100e8 4>;	/* pll reset control reg */

-- 
Regards,
Ivan Khoronzhuk

