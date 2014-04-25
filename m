Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaDYWVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:21:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDYWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:21:05 -0400
Date: Fri, 25 Apr 2014 15:23:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging:keucr:scsiglue.c-no semicolon terminated
Message-ID: <20140425222356.GA24112@kroah.com>
References: <1396974765-30902-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396974765-30902-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:32:45PM +0100, Paul McQuade wrote:
> WARNING: do {} while (0) macros should not be semicolon terminated
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/keucr/scsiglue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
> index ac3d34d..fce19a4 100644
> --- a/drivers/staging/keucr/scsiglue.c
> +++ b/drivers/staging/keucr/scsiglue.c
> @@ -277,7 +277,7 @@ static int show_info(struct seq_file *m, struct Scsi_Host *host)
>  	do { \
>  		if (us->fflags & value) \
>  			SPRINTF(" " #name); \
> -	} while (0);
> +	} while (0)
>  US_DO_ALL_FLAGS
>  #undef US_FLAG
>  	seq_putc(m, '\n');

Why would you send a patch that you obviously have not at least compile
tested?

Hint, this breaks the build :(

ALWAYS test build your patches, to not do so is rude to others, don't
you agree?

greg k-h
