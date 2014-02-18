Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaBRUKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:10:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaBRUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:10:09 -0500
Date: Tue, 18 Feb 2014 12:11:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] usb: phy: twl4030-usb: Remove redundant semicolon
Message-ID: <20140218201134.GB21119@kroah.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
 <1392627565-1829-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392627565-1829-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:29:19PM +0530, Kishon Vijay Abraham I wrote:
> From: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Semicolon after switch statement is not needed.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-twl4030-usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
> index 254c72c..ab64182 100644
> --- a/drivers/phy/phy-twl4030-usb.c
> +++ b/drivers/phy/phy-twl4030-usb.c
> @@ -338,7 +338,7 @@ static void twl4030_usb_set_mode(struct twl4030_usb *twl, int mode)
>  		dev_err(twl->dev, "unsupported T2 transceiver mode %d\n",
>  				mode);
>  		break;
> -	};
> +	}

Not a 3.14-final issue.
