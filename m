Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaLVKs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:48:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35657 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaLVKsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:48:25 -0500
Message-ID: <5497F6F4.3090204@ti.com>
Date: Mon, 22 Dec 2014 16:18:20 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/28] phy: drop owner assignment from platform_drivers
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de> <1419196495-9626-15-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1419196495-9626-15-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 22 December 2014 02:44 AM, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
> 
>  drivers/phy/phy-armada375-usb2.c | 1 -
>  drivers/phy/phy-berlin-usb.c     | 1 -
>  drivers/phy/phy-miphy28lp.c      | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/drivers/phy/phy-armada375-usb2.c b/drivers/phy/phy-armada375-usb2.c
> index ac7d99d01cb3..db83871a9f68 100644
> --- a/drivers/phy/phy-armada375-usb2.c
> +++ b/drivers/phy/phy-armada375-usb2.c
> @@ -148,7 +148,6 @@ static struct platform_driver armada375_usb_phy_driver = {
>  	.driver = {
>  		.of_match_table	= of_usb_cluster_table,
>  		.name  = "armada-375-usb-cluster",
> -		.owner = THIS_MODULE,
>  	}
>  };
>  module_platform_driver(armada375_usb_phy_driver);
> diff --git a/drivers/phy/phy-berlin-usb.c b/drivers/phy/phy-berlin-usb.c
> index c8a8d53a6ece..bae31d0093da 100644
> --- a/drivers/phy/phy-berlin-usb.c
> +++ b/drivers/phy/phy-berlin-usb.c
> @@ -212,7 +212,6 @@ static struct platform_driver phy_berlin_usb_driver = {
>  	.probe	= phy_berlin_usb_probe,
>  	.driver	= {
>  		.name		= "phy-berlin-usb",
> -		.owner		= THIS_MODULE,
>  		.of_match_table	= phy_berlin_sata_of_match,
>  	 },
>  };
> diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
> index e34da13885e8..359c6cb342a2 100644
> --- a/drivers/phy/phy-miphy28lp.c
> +++ b/drivers/phy/phy-miphy28lp.c
> @@ -1271,7 +1271,6 @@ static struct platform_driver miphy28lp_driver = {
>  	.probe = miphy28lp_probe,
>  	.driver = {
>  		.name = "miphy28lp-phy",
> -		.owner = THIS_MODULE,
>  		.of_match_table = miphy28lp_of_match,
>  	}
>  };
> 
