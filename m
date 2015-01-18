Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbbARAEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:04:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbARAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:04:29 -0500
Date: Sat, 17 Jan 2015 16:00:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: lustre: Fix spacing error in libcfs_string.c
Message-ID: <20150118000001.GA10033@kroah.com>
References: <20150111184403.GA17805@Caladan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111184403.GA17805@Caladan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 01:44:03PM -0500, Nickolaus Woodruff wrote:
> This patch fixes the following checkpatch.pl error in libcfs_string.c:
> 
> ERROR: spaces required around that '='
> 
> Signed-off-by: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
> ---
>  drivers/staging/lustre/lustre/libcfs/libcfs_string.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
> index fb88733..e67a18d 100644
> --- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
> +++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
> @@ -132,7 +132,7 @@ char *cfs_firststr(char *str, size_t size)
>  		++end;
>  	}
>  
> -	*end= '\0';
> +	*end = '\0';
>  out:
>  	return str;
>  }
> -- 
> 1.9.1

Someone already sent this patch before you did, sorry.

greg k-h
