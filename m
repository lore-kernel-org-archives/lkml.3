Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaCFIzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:55:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42523 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaCFIzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:55:31 -0500
Message-ID: <531837F0.607@ti.com>
Date: Thu, 6 Mar 2014 10:55:12 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <anatol.pomozov@gmail.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <kishon@ti.com>, <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <bcousson@baylibre.com>,
        <tony@atomide.com>
Subject: Re: [PATCH 5/5] doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
References: <1393854834-23810-1-git-send-email-george.cherian@ti.com> <1393854834-23810-6-git-send-email-george.cherian@ti.com>
In-Reply-To: <1393854834-23810-6-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 03:53 PM, George Cherian wrote:
> Add the compatible "ti,am437x-dwc3" for dwc3 glue driver.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

The patch order could be the rearranged so that this appears before the
am437x bindings are used.

cheers,
-roger

> 
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
> index c495135..1d38569 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -44,7 +44,9 @@ Board specific device node entry
>  };
>  
>  OMAP DWC3 GLUE
> - - compatible : Should be "ti,dwc3"
> + - compatible : Should be
> +	* "ti,dwc3" for OMAP5 and DRA7
> +	* "ti,am437x-dwc3" for AM437x
>   - ti,hwmods : Should be "usb_otg_ss"
>   - reg : Address and length of the register set for the device.
>   - interrupts : The irq number of this device that is used to interrupt the
> 

