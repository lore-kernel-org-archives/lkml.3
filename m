Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbbAJBA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:00:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbAJBA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:00:27 -0500
Date: Fri, 9 Jan 2015 17:00:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        sudipm.mukherjee@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: fix space coding style issue
 in s626.c
Message-ID: <20150110010026.GA4239@kroah.com>
References: <1419844376-6660-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419844376-6660-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 02:42:56PM +0530, jitendra kumar khasdev wrote:
> This is a patch to the s626.c file that fixes up a space error
> found by the checkpatch.pl tool
> 
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers/s626.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 14932c5..fc497dd 100644
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
> -- 
> 1.9.1

Someone already sent this patch in before you :(
