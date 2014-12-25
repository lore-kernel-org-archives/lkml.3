Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaLYLEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 06:04:50 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34652 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaLYLEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 06:04:49 -0500
Date: Thu, 25 Dec 2014 03:04:44 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: David Decotigny <ddecotig@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH v1] staging: comedi: dmm32at: fix style issues
Message-ID: <20141225110444.GA30022@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	David Decotigny <ddecotig@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>
References: <1419472538-8035-1-git-send-email-ddecotig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419472538-8035-1-git-send-email-ddecotig@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Wed, Dec 24, 2014 at 05:55:38PM -0800, David Decotigny wrote:
> Before:
>       1 ERROR: code indent should use tabs where possible
>       1 WARNING: please, no spaces at the start of a line
> 
> After:
>   (none)
> 
> Signed-off-by: David Decotigny <ddecotig@gmail.com>
> ---
>  drivers/staging/comedi/drivers/dmm32at.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
> index 6df298a..1615103 100644
> --- a/drivers/staging/comedi/drivers/dmm32at.c
> +++ b/drivers/staging/comedi/drivers/dmm32at.c
> @@ -363,9 +363,9 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
>  	outb(hi2, dev->iobase + DMM32AT_CLK2);
>  
>  	/* enable the ai conversion interrupt and the clock to start scans */
> -	outb(DMM32AT_INTCLK_ADINT |
> -	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
> -             dev->iobase + DMM32AT_INTCLK_REG);
> +	outb(DMM32AT_INTCLK_ADINT | DMM32AT_INTCLK_CLKEN |
> +		 DMM32AT_INTCLK_CLKSEL,
> +	     dev->iobase + DMM32AT_INTCLK_REG);
>  }
>  
>  static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)

Your patch re-formats this section, but I don't think this is needed.
Some people like to format their code so it is aligned at the left
parenthesis.

The warning is about the line which is indented entirely using spaces
and no tabs.  The following patch would fix the warning without
disrupting the formatting.

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 6df298a..31919b8 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -365,7 +365,7 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 	/* enable the ai conversion interrupt and the clock to start scans */
 	outb(DMM32AT_INTCLK_ADINT |
 	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
-             dev->iobase + DMM32AT_INTCLK_REG);
+	     dev->iobase + DMM32AT_INTCLK_REG);
 }
 
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)

-- 
- Jeremiah Mahler
