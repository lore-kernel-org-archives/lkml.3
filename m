Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaAJKeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:34:10 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39807 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaAJKeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:34:06 -0500
Message-ID: <52CFCC9B.2090204@mev.co.uk>
Date: Fri, 10 Jan 2014 10:34:03 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] Staging: comedi: fix spacing coding style issue in 8255.c.
References: <1389326381-8526-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1389326381-8526-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-10 03:59, Chase Southwood wrote:
> This patch for 8255.c fixes a spacing warning found by checkpatch.pl.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   drivers/staging/comedi/drivers/8255.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
> index b4009e8..48817f0 100644
> --- a/drivers/staging/comedi/drivers/8255.c
> +++ b/drivers/staging/comedi/drivers/8255.c
> @@ -94,7 +94,7 @@ I/O port base address can be found in the output of 'lspci -v'.
>
>   struct subdev_8255_private {
>   	unsigned long iobase;
> -	int (*io) (int, int, int, unsigned long);
> +	int (*io)(int, int, int, unsigned long);
>   };
>
>   static int subdev_8255_io(int dir, int port, int data, unsigned long iobase)
> @@ -262,7 +262,7 @@ static int subdev_8255_cancel(struct comedi_device *dev,
>   }
>
>   int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
> -		     int (*io) (int, int, int, unsigned long),
> +		     int (*io)(int, int, int, unsigned long),
>   		     unsigned long iobase)
>   {
>   	struct subdev_8255_private *spriv;
> @@ -289,7 +289,7 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
>   EXPORT_SYMBOL_GPL(subdev_8255_init);
>
>   int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
> -			 int (*io) (int, int, int, unsigned long),
> +			 int (*io)(int, int, int, unsigned long),
>   			 unsigned long iobase)
>   {
>   	int ret;
>

Harmless.  (Good!)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
