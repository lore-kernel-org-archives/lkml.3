Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbbAJBAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:00:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbbAJBAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:00:47 -0500
Date: Fri, 9 Jan 2015 17:00:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Piotr Kubus <p.t.kubus@gmail.com>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: comedi: dmm32at: Fix a code indent issue
Message-ID: <20150110010047.GA6392@kroah.com>
References: <1420539376-15323-1-git-send-email-p.t.kubus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420539376-15323-1-git-send-email-p.t.kubus@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:16:16AM +0100, Piotr Kubus wrote:
> Fixed a code indent error found by checkpatch.pl in dmm32at.c.
> 
> Signed-off-by: Piotr Kubus <p.t.kubus@gmail.com>
> ---
> v2: make the commit message clearer and shorter
> 
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
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

Already sent by someone else before you :(
