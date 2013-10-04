Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3JDOTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:19:55 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38829 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3JDOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:19:53 -0400
Message-ID: <524ECE84.6030902@baylibre.com>
Date: Fri, 04 Oct 2013 16:19:48 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP DEVICE TREE..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/9] am33xx: dts: Fix AES interrupt number
References: <1380553986-15910-1-git-send-email-joelf@ti.com> <1380553986-15910-6-git-send-email-joelf@ti.com>
In-Reply-To: <1380553986-15910-6-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/2013 17:13, Joel Fernandes wrote:
> Signed-off-by: Joel Fernandes <joelf@ti.com>

Even if this is obvious, a small changelog is always recommended.


Thanks,
Benoit

> ---
>   arch/arm/boot/dts/am33xx.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 0daa1b2..d7be90a 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -724,7 +724,7 @@
>   			compatible = "ti,omap4-aes";
>   			ti,hwmods = "aes";
>   			reg = <0x53500000 0xa0>;
> -			interrupts = <102>;
> +			interrupts = <103>;
>   			dmas = <&edma 6
>   				&edma 5>;
>   			dma-names = "tx", "rx";
>

