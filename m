Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaILRLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:11:12 -0400
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:57179 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaILRLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:11:08 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 13:11:08 EDT
Date: Fri, 12 Sep 2014 18:47:54 +0200
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 8/8] ARM: at91: document Atmel SMART compatibles
Message-ID: <20140912184754.546b26cf@e6520eb>
In-Reply-To: <1410536587-24607-9-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1410536587-24607-9-git-send-email-alexandre.belloni@free-electrons.com>
Organization: =?ISO-8859-1?B?RXVrculh?= Electromatique
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 2662471806198197651
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrfeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrfeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 12 Sep 2014 17:43:07 +0200,
Alexandre Belloni <alexandre.belloni@free-electrons.com> a écrit :

> 
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
> + * "atmel,at91sam9260"
> + * "atmel,at91sam9261"
> + * "atmel,at91sam9263"
> + * "atmel,at91sam9x5" for the x5 family, shall be extended with the specific SoC
> +   compatible:
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
> +   SoC family:
> +    o "atmel,sama5d3" shal be exteneded with the specific SoC compatible:
                                 ^ extended

> +       - "atmel,samad31"
> +       - "atmel,samad33"
> +       - "atmel,samad34"
> +       - "atmel,samad35"
> +       - "atmel,samad36"
> +    o "atmel,sama5d4"
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
maybe remove those 10 last lines ;-)

Eric
