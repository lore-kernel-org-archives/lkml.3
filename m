Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaL3WP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:15:29 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:42805 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbaL3WP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:15:28 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54A323F4.8010108@mev.co.uk>
Date: Tue, 30 Dec 2014 22:15:16 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: David Decotigny <ddecotig@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
CC: Jeremiah Mahler <jmmahler@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH v2] staging: comedi: dmm32at: fix style issues
References: <1419539308-19059-1-git-send-email-ddecotig@gmail.com>
In-Reply-To: <1419539308-19059-1-git-send-email-ddecotig@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/12/14 20:28, David Decotigny wrote:
> Before:
>        1 ERROR: code indent should use tabs where possible
>        1 WARNING: please, no spaces at the start of a line
>
> After:
>    (none)
>
> Signed-off-by: David Decotigny <ddecotig@gmail.com>
> ---
>   drivers/staging/comedi/drivers/dmm32at.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
> index 6df298a..31919b8 100644
> --- a/drivers/staging/comedi/drivers/dmm32at.c
> +++ b/drivers/staging/comedi/drivers/dmm32at.c
> @@ -365,7 +365,7 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
>   	/* enable the ai conversion interrupt and the clock to start scans */
>   	outb(DMM32AT_INTCLK_ADINT |
>   	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
> -             dev->iobase + DMM32AT_INTCLK_REG);
> +	     dev->iobase + DMM32AT_INTCLK_REG);
>   }
>
>   static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
