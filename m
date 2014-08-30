Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaH3TVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 15:21:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaH3TU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 15:20:59 -0400
Date: Sat, 30 Aug 2014 12:20:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Janet Liu <jianhua.ljh@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 2/4] staging:lustre:lnet: lib-md.c delete space before
 '(' for code style
Message-ID: <20140830192058.GA370@kroah.com>
References: <1409381575-2211-1-git-send-email-jianhua.ljh@gmail.com>
 <1409381769-2311-1-git-send-email-jianhua.ljh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409381769-2311-1-git-send-email-jianhua.ljh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 02:56:09PM +0800, Janet Liu wrote:
> Silences the following checkpatch warning:
>   WARNING: space prohibited between function name and open parenthesis '('
> 
> Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
> ---
>  drivers/staging/lustre/lnet/lnet/lib-md.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
> index efd1b82..13f4332 100644
> --- a/drivers/staging/lustre/lnet/lnet/lib-md.c
> +++ b/drivers/staging/lustre/lnet/lnet/lib-md.c
> @@ -110,7 +110,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
>  
>  		lmd->md_niov = niov = umd->length;
>  		memcpy(lmd->md_iov.iov, umd->start,
> -		       niov * sizeof (lmd->md_iov.iov[0]));
> +		       niov * sizeof(lmd->md_iov.iov[0]));
>  
>  		for (i = 0; i < (int)niov; i++) {
>  			/* We take the base address on trust */
> @@ -131,7 +131,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
>  	} else if ((umd->options & LNET_MD_KIOV) != 0) {
>  		lmd->md_niov = niov = umd->length;
>  		memcpy(lmd->md_iov.kiov, umd->start,
> -		       niov * sizeof (lmd->md_iov.kiov[0]));
> +		       niov * sizeof(lmd->md_iov.kiov[0]));
>  
>  		for (i = 0; i < (int)niov; i++) {
>  			/* We take the page pointer on trust */
> @@ -266,15 +266,15 @@ int
>  LNetMDAttach(lnet_handle_me_t meh, lnet_md_t umd,
>  	     lnet_unlink_t unlink, lnet_handle_md_t *handle)
>  {
> -	LIST_HEAD		(matches);
> -	LIST_HEAD		(drops);
> +	LIST_HEAD(matches);
> +	LIST_HEAD(drops);

This really isn't a "function", but I'll take it anyway...

greg k-h
