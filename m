Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaL2HHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:07:23 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44952 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaL2HHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:07:20 -0500
Date: Mon, 29 Dec 2014 12:37:12 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        pankaj.saraf@nektech.in
Subject: Re: [PATCH 3/3] Staging: comedi: fix space and 80 char coding style
 issue
Message-ID: <20141229070712.GD3749@sudip-PC>
References: <1419803085-9441-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419803085-9441-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 03:14:45AM +0530, jitendra kumar khasdev wrote:
> This is a patch to the s626.c file that fixes up spcae and maximum
> character limit warning found by the checkpatch.pl tool

you are doing two different kind of changes in this patch. it should be in two different patches. One patch should do only one type of change.

thanks
sudip

> 
> Signed-off-by: Jitendra Kumar Khasdev  <jkhasdev@gmail.com>
> ---
>  drivers/staging/comedi/drivers/s626.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 14932c5..77f715b 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -118,7 +118,7 @@ static void s626_mc_enable(struct comedi_device *dev,
>  static void s626_mc_disable(struct comedi_device *dev,
>  			    unsigned int cmd, unsigned int reg)
>  {
> -	writel(cmd << 16 , dev->mmio + reg);
> +	writel(cmd << 16, dev->mmio + reg);
>  	mmiowb();
>  }
>  
> @@ -2534,7 +2534,8 @@ static int s626_initialize(struct comedi_device *dev)
>  	for (i = 0; i < 2; i++) {
>  		writel(S626_I2C_CLKSEL, dev->mmio + S626_P_I2CSTAT);
>  		s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
> -		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
> +		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc,
> +		0);
>  		if (ret)
>  			return ret;
>  	}
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
