Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaCMKdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:33:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39245 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaCMKdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:33:02 -0400
Message-ID: <53218944.7000102@ti.com>
Date: Thu, 13 Mar 2014 12:32:36 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <anatol.pomozov@gmail.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH v3 1/5] doc: Add "ti,am437x-dwc3" comaptible for dwc3
 glue
References: <1394193422-18242-1-git-send-email-george.cherian@ti.com> <1394193422-18242-2-git-send-email-george.cherian@ti.com>
In-Reply-To: <1394193422-18242-2-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 03/07/2014 01:56 PM, George Cherian wrote:
> Add the compatible "ti,am437x-dwc3" for dwc3 glue driver.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
> index 38b2fae..38d9bb8 100644
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

Why do you need a new compatible for am437x? Isn't "ti,dwc3" sufficient?

>   - ti,hwmods : Should be "usb_otg_ss"
>   - reg : Address and length of the register set for the device.
>   - interrupts : The irq number of this device that is used to interrupt the
> 

cheers,
-roger
