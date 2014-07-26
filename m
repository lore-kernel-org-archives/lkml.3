Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaGZUGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:06:48 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:47604 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaGZUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:06:46 -0400
Message-ID: <53D40A60.2060100@cogentembedded.com>
Date: Sun, 27 Jul 2014 00:06:56 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91/dt: sam9x5: fix ADC compatible string
References: <1406038067-14697-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1406038067-14697-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/22/2014 06:07 PM, Alexandre Belloni wrote:

> Use the correct compatible string for the ADC of the at91sam9x5 family of SoCs.

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/boot/dts/at91sam9x5.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index 2c0d6ea3ab41..5d7cf394f537 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -964,7 +964,7 @@
>   			adc0: adc@f804c000 {
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> -				compatible = "atmel,at91sam9260-adc";
> +				compatible = "atmel,at91sam9x5-adc";

    Actually, wildcards are not allowed in the "compatible" prop.

WBR, Sergei

