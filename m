Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbaISMim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:38:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:26037 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaISMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:38:40 -0400
Message-ID: <541C23CB.9060208@atmel.com>
Date: Fri, 19 Sep 2014 14:38:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 7/7] ARM: at91: document Atmel SMART compatibles
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com> <1410797759-18675-8-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410797759-18675-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/2014 18:15, Alexandre Belloni :
> Document all the available compatibles for Atmel "SMART" SoCs.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks

> ---
>  .../devicetree/bindings/arm/atmel-at91.txt         | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> index 6e3e3e5c611f..562cda9d86d9 100644
> --- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
> +++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> @@ -1,6 +1,43 @@
>  Atmel AT91 device tree bindings.
>  ================================
>  
> +Boards with a SoC of the Atmel AT91 or SMART family shall have the following
> +properties:
> +
> +Required root node properties:
> +compatible: must be one of:
> + * "atmel,at91rm9200"
> +
> + * "atmel,at91sam9" for SoCs using an ARM926EJ-S core, shall be extended with
> +   the specific SoC family or compatible:
> +    o "atmel,at91sam9260"
> +    o "atmel,at91sam9261"
> +    o "atmel,at91sam9263"
> +    o "atmel,at91sam9x5" for the 5 series, shall be extended with the specific
> +      SoC compatible:
> +       - "atmel,at91sam9g15"
> +       - "atmel,at91sam9g25"
> +       - "atmel,at91sam9g35"
> +       - "atmel,at91sam9x25"
> +       - "atmel,at91sam9x35"
> +    o "atmel,at91sam9g20"
> +    o "atmel,at91sam9g45"
> +    o "atmel,at91sam9n12"
> +    o "atmel,at91sam9rl"
> + * "atmel,sama5" for SoCs using a Cortex-A5, shall be extended with the specific
> +   SoC family:
> +    o "atmel,sama5d3" shall be extended with the specific SoC compatible:
> +       - "atmel,sama5d31"
> +       - "atmel,sama5d33"
> +       - "atmel,sama5d34"
> +       - "atmel,sama5d35"
> +       - "atmel,sama5d36"
> +    o "atmel,sama5d4" shall be extended with the specific SoC compatible:
> +       - "atmel,sama5d41"
> +       - "atmel,sama5d42"
> +       - "atmel,sama5d43"
> +       - "atmel,sama5d44"
> +
>  PIT Timer required properties:
>  - compatible: Should be "atmel,at91sam9260-pit"
>  - reg: Should contain registers location and length
> 


-- 
Nicolas Ferre
