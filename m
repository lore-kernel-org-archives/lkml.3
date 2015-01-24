Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbbAXC3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 21:29:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAXC3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 21:29:44 -0500
Date: Sat, 24 Jan 2015 10:29:41 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] Staging: comedi: fix line over 80 characters
 warning
Message-ID: <20150124022941.GA4161@kroah.com>
References: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com>
 <1422040280-20213-3-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422040280-20213-3-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 12:41:20AM +0530, jitendra kumar khasdev wrote:
> This is patch to file jr3_pci.c that fix up warning line
> over 80 character which is found by checkpatch tool. Made change into signature
> of struct jr3_pci_poll_delay jr3_pci_poll_subdevice function by giving a newline
> so that 80 character line over warning to be reduced.

The irony of not properly line-wrapping your changelog comment for a
patch that you are fixing up proper line size is huge :)


> 
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>  drivers/staging/comedi/drivers/jr3_pci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
> index 81fab2d..1de843d 100644
> --- a/drivers/staging/comedi/drivers/jr3_pci.c
> +++ b/drivers/staging/comedi/drivers/jr3_pci.c
> @@ -449,7 +449,8 @@ static int jr3_download_firmware(struct comedi_device *dev,
>  	return 0;
>  }
>  
> -static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice *s)
> +static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice
> +							*s)

Be reasonable, this is now looks worse than the code did before, just
leave this as-is, coding style is a guideline, not hard rules.

thanks,

greg k-h
