Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaCGI1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:27:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35637 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaCGI1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:27:23 -0500
Message-ID: <531982CF.3040004@ti.com>
Date: Fri, 7 Mar 2014 13:56:55 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <rogerq@ti.com>, <balbi@ti.com>
Subject: Re: [PATCH v4] phy: omap-control: update dra7 and am437 usb2 Documentation
 bindings
References: <53189742.3060705@ti.com> <1394121786-28193-1-git-send-email-balbi@ti.com>
In-Reply-To: <1394121786-28193-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 07 March 2014 01:55 PM, Kishon Vijay Abraham I wrote:
> From: Felipe Balbi <balbi@ti.com>
>
> From: Roger Quadros <rogerq@ti.com>

There seems to be some problem with this patch. Pls ignore this.

Thanks
Kishon
>
> The dra7-usb2 and am437-usb2 bindings have not yet been used.
> Change them to be more elegant.
>
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> Changes from v3:
> * changed the compatible name to 'ti,control-phy-usb2-dra7' and
>    'ti,control-phy-usb2-am437'
>
>   Documentation/devicetree/bindings/phy/ti-phy.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
> index 41dc132..8694aae 100644
> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
> @@ -9,9 +9,9 @@ Required properties:
>                           e.g. USB2_PHY on OMAP5.
>    "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
>                           e.g. USB3 PHY and SATA PHY on OMAP5.
> - "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
> + "ti,control-phy-usb2-dra7" - if it has power down register like USB2 PHY on
>                           DRA7 platform.
> - "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
> + "ti,control-phy-usb2-am437" - if it has power down register like USB2 PHY on
>                           AM437 platform.
>    - reg : Address and length of the register set for the device. It contains
>      the address of "otghs_control" for control-phy-otghs or "power" register
>
