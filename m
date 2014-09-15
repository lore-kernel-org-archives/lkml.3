Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaIOJCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:02:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13716 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaIOJCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:02:11 -0400
Message-ID: <5416AB11.4060600@atmel.com>
Date: Mon, 15 Sep 2014 11:02:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 8/8] ARM: at91: document Atmel SMART compatibles
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com> <1410536587-24607-9-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410536587-24607-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 17:43, Alexandre Belloni :
> Document all the available compatibles for Atmel "SMART" SoCs.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  .../devicetree/bindings/arm/atmel-at91.txt         | 40 ++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> index 6e3e3e5c611f..2ef92e04ed10 100644
> --- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
> +++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> @@ -1,6 +1,46 @@
>  Atmel AT91 device tree bindings.
>  ================================
>  
> +Boards with a SoC of the Atmel AT91 or SMART family shall have the following
> +properties:
> +
> +Required root node properties:
> +compatible: must be one of:
> + * "atmel,rm9200"

No, this one doesn't exists. Does it? It must be "atmel,at91rm9200".

> + * "atmel,at91sam9260"
> + * "atmel,at91sam9261"
> + * "atmel,at91sam9263"
> + * "atmel,at91sam9x5" for the x5 family, shall be extended with the specific SoC
> +   compatible:

We call it the "5 series" or at91sam9x5 family, not the x5 family.

> +    o "atmel,at91sam9g15"
> +    o "atmel,at91sam9g25"
> +    o "atmel,at91sam9g35"
> +    o "atmel,at91sam9x25"
> +    o "atmel,at91sam9x35"
> + * "atmel,at91sam9g20"
> + * "atmel,at91sam9g45"
> + * "atmel,at91sam9n12"
> + * "atmel,at91sam9rl"
> + * "atmel,sama5" for the cortexA5 family, shall be extended with the specific

for SoC using a Cortex-A5.

> +   SoC family:
> +    o "atmel,sama5d3" shal be exteneded with the specific SoC compatible:

s/shal/shall/

> +       - "atmel,samad31"

samad31 => sama5d31

> +       - "atmel,samad33"
> +       - "atmel,samad34"
> +       - "atmel,samad35"
> +       - "atmel,samad36"

Ditto for all 4 above.

> +    o "atmel,sama5d4"

Same here, you can also talk about a family:

o "atmel,sama5d41"
o "atmel,sama5d42"
o "atmel,sama5d43"
o "atmel,sama5d44"


> +
> +
> +In addition, the above compatible shall be extended with the specific
> +SoC and board used. Currently known SoC compatibles are:
> +    "marvell,berlin2"      for Marvell Armada 1500 (BG2, 88DE3100),
> +    "marvell,berlin2cd"    for Marvell Armada 1500-mini (BG2CD, 88DE3005)
> +    "marvell,berlin2ct"    for Marvell Armada ? (BG2CT, 88DE????)
> +    "marvell,berlin2q"     for Marvell Armada 1500-pro (BG2Q, 88DE3114)
> +    "marvell,berlin3"      for Marvell Armada ? (BG3, 88DE????)
> +
> +

;-)

>  PIT Timer required properties:
>  - compatible: Should be "atmel,at91sam9260-pit"
>  - reg: Should contain registers location and length
> 


-- 
Nicolas Ferre
