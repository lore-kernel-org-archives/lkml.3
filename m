Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbbAJA7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:59:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbbAJA7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:59:48 -0500
Date: Fri, 9 Jan 2015 16:59:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Piotr Kubus <p.t.kubus@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: dmm32at: Fixed a code indent issue
Message-ID: <20150110005947.GA4176@kroah.com>
References: <1420384955-27336-1-git-send-email-p.t.kubus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420384955-27336-1-git-send-email-p.t.kubus@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 04:22:35PM +0100, Piotr Kubus wrote:
> This is a patch to the dmm32at.c file that fixes up a code indent error found by the checkpatch.pl tool.
> 
> Signed-off-by: Piotr Kubus <p.t.kubus@gmail.com>
> ---
>  drivers/staging/comedi/drivers/dmm32at.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
> index 6df298a..31919b8 100644
> --- a/drivers/staging/comedi/drivers/dmm32at.c
> +++ b/drivers/staging/comedi/drivers/dmm32at.c
> @@ -365,7 +365,7 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
>  	/* enable the ai conversion interrupt and the clock to start scans */
>  	outb(DMM32AT_INTCLK_ADINT |
>  	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
> -             dev->iobase + DMM32AT_INTCLK_REG);
> +	     dev->iobase + DMM32AT_INTCLK_REG);
>  }
>  
>  static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
> -- 
> 1.9.1

Someone already submitted this same change before you :(
