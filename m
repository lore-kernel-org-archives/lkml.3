Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3ILNYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:24:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42284 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab3ILNYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:24:05 -0400
Message-ID: <5231C040.4040609@ti.com>
Date: Thu, 12 Sep 2013 16:23:12 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] Documentation: dt bindings: move ..usb/usb-phy.txt
 to ..phy/omap-phy.txt
References: <1378136591-7463-1-git-send-email-kishon@ti.com> <1378136591-7463-5-git-send-email-kishon@ti.com>
In-Reply-To: <1378136591-7463-5-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
> Since now we have a separate folder for phy, move the PHY dt binding
> documentation of OMAP to that folder.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  .../devicetree/bindings/{usb/usb-phy.txt => phy/omap-phy.txt}        |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>  rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/omap-phy.txt} (96%)
> 
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/phy/omap-phy.txt
> similarity index 96%
> rename from Documentation/devicetree/bindings/usb/usb-phy.txt
> rename to Documentation/devicetree/bindings/phy/omap-phy.txt
> index 36bdb17..2c485ee 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/omap-phy.txt

ti-phy.txt?

> @@ -1,4 +1,4 @@
> -USB PHY
> +OMAP PHY: DT DOCUMENTATION FOR PHYs in OMAP PLATFORM

TI PHY: PHYs in Texas Instruments SoCs

cheers,
-roger

