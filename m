Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbbAFKYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:24:45 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:57615 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbbAFKYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:24:43 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54ABB7E8.6060002@mev.co.uk>
Date: Tue, 06 Jan 2015 10:24:40 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Piotr Kubus <p.t.kubus@gmail.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: comedi: dmm32at: Fix a code indent issue
References: <1420539376-15323-1-git-send-email-p.t.kubus@gmail.com>
In-Reply-To: <1420539376-15323-1-git-send-email-p.t.kubus@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 10:16, Piotr Kubus wrote:
> Fixed a code indent error found by checkpatch.pl in dmm32at.c.
>
> Signed-off-by: Piotr Kubus <p.t.kubus@gmail.com>
> ---
> v2: make the commit message clearer and shorter
>
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
