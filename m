Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaCGGI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:08:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54089 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaCGGIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:08:25 -0500
Message-ID: <5319623D.5030909@ti.com>
Date: Fri, 7 Mar 2014 11:37:57 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <rogerq@ti.com>, <balbi@ti.com>
Subject: Re: [PATCH v3] phy: omap-control: update dra7 and am437 usb2 bindings
References: <1394171280-13359-1-git-send-email-kishon@ti.com>
In-Reply-To: <1394171280-13359-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/2014 11:18 AM, Kishon Vijay Abraham I wrote:
> From: Roger Quadros <rogerq@ti.com>
>
> The dra7-usb2 and am437-usb2 bindings have not yet been used.
> Change them to be more elegant.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> Changes from v2:
> Kept only the drivers/phy part in this patch
>
>   drivers/phy/phy-omap-control.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
> index 17fc200..a7e2d7f 100644
> --- a/drivers/phy/phy-omap-control.c
> +++ b/drivers/phy/phy-omap-control.c
> @@ -228,11 +228,11 @@ static const struct of_device_id omap_control_phy_id_table[] = {
>   		.data = &pipe3_data,
>   	},
>   	{
> -		.compatible = "ti,control-phy-dra7usb2",
> +		.compatible = "ti,control-phy-dra7-usb2",
>   		.data = &dra7usb2_data,
>   	},
>   	{
> -		.compatible = "ti,control-phy-am437usb2",
> +		.compatible = "ti,control-phy-am437-usb2",

Tony suggested to keep the compatible

ti,control-phy-usb2-dra7 and ti,control-phy-usb2-am437

http://www.spinics.net/lists/linux-omap/msg104040.html

Since we already have a ti,control-phy-usb2 I think it make sense to keep the new comaptible for dra7 and am437 as above.

>   		.data = &am437usb2_data,
>   	},
>   	{},


-- 
-George

