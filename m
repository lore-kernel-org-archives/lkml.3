Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaB1Ogx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:36:53 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:22406 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaB1Ogv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:36:51 -0500
Message-ID: <53109F03.6060506@atmel.com>
Date: Fri, 28 Feb 2014 15:36:51 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, Rob Landley <rob@landley.net>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Felipe Balbi <balbi@ti.com>,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] Doc: USB: gadget: atmel_usba correct atmel,vbus-gpio
 meaning
References: <1393515910-15837-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1393515910-15837-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2014 16:45, Alexandre Belloni :
> atmel,at91sam9rl-udc is a USB gadget, it has now means to control vbus.

s/now/no/

> atmel,vbus-gpio is in fact used to detect the presence of vbus.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  Documentation/devicetree/bindings/usb/atmel-usb.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/atmel-usb.txt b/Documentation/devicetree/bindings/usb/atmel-usb.txt
> index 55f51af08bc7..bc2222ca3f2a 100644
> --- a/Documentation/devicetree/bindings/usb/atmel-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/atmel-usb.txt
> @@ -57,8 +57,8 @@ Required properties:
>   - ep childnode: To specify the number of endpoints and their properties.
>  
>  Optional properties:
> - - atmel,vbus-gpio: If present, specifies a gpio that needs to be
> -   activated for the bus to be powered.
> + - atmel,vbus-gpio: If present, specifies a gpio that allows to detect whether
> +   vbus is present (USB is connected).
>  
>  Required child node properties:
>   - name: Name of the endpoint.
> 


-- 
Nicolas Ferre
