Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaL3WkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:40:20 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:46974 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbaL3WkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:40:19 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54A329CB.9090808@mev.co.uk>
Date: Tue, 30 Dec 2014 22:40:11 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Andreas Siegling <andreas.siegling@fau.de>, devel@linuxdriverproject.org
CC: linux-kernel@i4.cs.fau.de, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ebru.akagunduz@gmail.com,
        chase.southwood@gmail.com, rickard_strandqvist@spectrumdigital.se,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: Re: [PATCH 1/3] comedi: checkpatch error: tabs instead of spaces
References: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de> <1419792975-31519-2-git-send-email-andreas.siegling@fau.de>
In-Reply-To: <1419792975-31519-2-git-send-email-andreas.siegling@fau.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/12/14 18:56, Andreas Siegling wrote:
> This patch fixes all occurrences of 8 whitespaces instead of a tab.
> It will remove the 8 whitespaces and replace them with a tab, thereby
> the checkpatch-error:
> 		ERROR: code indent should use tabs where possible
> is removed from all files in drivers/staging/comedi/
> It also brings some consistency of indentation in the comments.
>
> Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
> Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>
> ---
>   drivers/staging/comedi/drivers/daqboard2000.c | 62 +++++++++++++--------------
>   drivers/staging/comedi/drivers/das16m1.c      |  4 +-
>   drivers/staging/comedi/drivers/dmm32at.c      |  2 +-
>   drivers/staging/comedi/drivers/pcl818.c       | 36 ++++++++--------
>   4 files changed, 52 insertions(+), 52 deletions(-)

Most of these aren't worth doing as they only affect multi-line comments 
that should be reformatted to the usual block comment style anyway.


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

That bit of the patch is fine, but has already been tackled in a patch 
by David Decotigny.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
