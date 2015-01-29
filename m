Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbbA2Gzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:55:44 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:37376 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbbA2GzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:55:22 -0500
Date: Thu, 29 Jan 2015 17:54:46 +1100 (AEDT)
From: Finn Thain <fthain@telegraphics.com.au>
To: Wolfram Sang <wsa@the-dreams.de>
cc: linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 17/28] scsi: drop owner assignment from
 platform_drivers
In-Reply-To: <1419196495-9626-18-git-send-email-wsa@the-dreams.de>
Message-ID: <alpine.LNX.2.00.1501291747020.7510@nippy.intranet>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de> <1419196495-9626-18-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

On Sun, 21 Dec 2014, Wolfram Sang wrote:

> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
> 
>  drivers/scsi/atari_scsi.c | 1 -
>  drivers/scsi/mac_scsi.c   | 1 -
>  drivers/scsi/sun3_scsi.c  | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index d1c37a386947..5ede3daa93dc 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -1014,7 +1014,6 @@ static struct platform_driver atari_scsi_driver = {
>  	.remove = __exit_p(atari_scsi_remove),
>  	.driver = {
>  		.name	= DRV_MODULE_NAME,
> -		.owner	= THIS_MODULE,
>  	},
>  };
>  
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 1e85c07e3b62..d64a769b8155 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -483,7 +483,6 @@ static struct platform_driver mac_scsi_driver = {
>  	.remove = __exit_p(mac_scsi_remove),
>  	.driver = {
>  		.name	= DRV_MODULE_NAME,
> -		.owner	= THIS_MODULE,
>  	},
>  };
>  
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index 2a906d1d34ba..22a42836d193 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -676,7 +676,6 @@ static struct platform_driver sun3_scsi_driver = {
>  	.remove = __exit_p(sun3_scsi_remove),
>  	.driver = {
>  		.name	= DRV_MODULE_NAME,
> -		.owner	= THIS_MODULE,
>  	},
>  };
>  
> 
