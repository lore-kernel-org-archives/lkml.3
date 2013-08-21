Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3HUJRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:17:49 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:41029 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3HUJRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:17:48 -0400
Message-ID: <521485D1.8040308@atmel.com>
Date: Wed, 21 Aug 2013 11:18:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: DTS: SAMA5: Add PMU support
References: <1375716366-19121-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1375716366-19121-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 17:26, Alexandre Belloni :
> ARM Performance Monitor Units are available on the sama5d3, add the support in
> the dtsi.
>
> Tested with perf and oprofile on the sama5d31ek.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Stacked on at91-3.12-dt.

Thanks.

> ---
>   arch/arm/boot/dts/sama5d3.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index a1d5e25..afa68ac 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -48,6 +48,11 @@
>   		};
>   	};
>
> +       pmu {
> +               compatible = "arm,cortex-a5-pmu";
> +               interrupts = <46 IRQ_TYPE_LEVEL_HIGH 0>;
> +       };
> +
>   	memory {
>   		reg = <0x20000000 0x8000000>;
>   	};
>


-- 
Nicolas Ferre
