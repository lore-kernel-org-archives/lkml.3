Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab3G2SUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:20:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3G2SUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:20:50 -0400
Date: Mon, 29 Jul 2013 11:20:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: abbasjasim <abbasjasim.aj@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: logger..c fixed a brace coding style
 issue
Message-ID: <20130729182049.GA18299@kroah.com>
References: <1375019271-10084-1-git-send-email-abbasjasim.AJ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375019271-10084-1-git-send-email-abbasjasim.AJ@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 04:47:51PM +0300, abbasjasim wrote:
> fixed a coding style issue.
> 
> Signed-off-by: Abbas J. Mohammed <abbasjasim.AJ@gmail.com>
> ---
>  drivers/staging/android/logger.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index ffc2d04..3d5180a 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -81,8 +81,9 @@ static inline struct logger_log *file_get_log(struct file *file)
>  	if (file->f_mode & FMODE_READ) {
>  		struct logger_reader *reader = file->private_data;
>  		return reader->log;
> -	} else
> +	} else {
>  		return file->private_data;
> +	}

I think the existing code is just fine, no need for this patch.

thanks,

greg k-h
