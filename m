Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaCEBJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:09:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaCEBJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:09:10 -0500
Date: Tue, 4 Mar 2014 17:10:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Keerthimai Janarthanan <keerthimaipb@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging :keucr:scsiglue.c : fixed a macros should
 not be colon terminated issue
Message-ID: <20140305011054.GA10990@kroah.com>
References: <1393764677-4709-1-git-send-email-keerthimaipb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393764677-4709-1-git-send-email-keerthimaipb@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 06:21:16PM +0530, Keerthimai Janarthanan wrote:
> fixed a coding style issue.
> 
> Signed-off-by: Keerthimai Janarthanan <keerthimaipb@gmail.com>
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

You just broke the build.

Please ALWAYS test your patches, don't break someone else's build with
broken patches...

Please be more careful.
