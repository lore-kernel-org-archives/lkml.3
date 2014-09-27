Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaI0PBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 11:01:55 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35475 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaI0PBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 11:01:54 -0400
Date: Sat, 27 Sep 2014 20:31:47 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mike Roocroft <mike.linux@btinternet.com>
Cc: gregkh@linuxfoundation.org, swetland@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: android: sw_sync: fixed a coding style
 issues
Message-ID: <20140927150147.GB2413@sudip-PC>
References: <1411686716-2663-1-git-send-email-mike.linux@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411686716-2663-1-git-send-email-mike.linux@btinternet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 12:11:56AM +0100, Mike Roocroft wrote:

you forgot to write the commit message and also mention there what kind of warning you have fixed.

thanks
sudip

> Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
> ---
>  drivers/staging/android/sw_sync.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
> index a76db3f..863d4b1 100644
> --- a/drivers/staging/android/sw_sync.c
> +++ b/drivers/staging/android/sw_sync.c
> @@ -97,6 +97,7 @@ static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
>  				       char *str, int size)
>  {
>  	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
> +
>  	snprintf(str, size, "%d", pt->value);
>  }
>  
> @@ -156,6 +157,7 @@ static int sw_sync_open(struct inode *inode, struct file *file)
>  static int sw_sync_release(struct inode *inode, struct file *file)
>  {
>  	struct sw_sync_timeline *obj = file->private_data;
> +
>  	sync_timeline_destroy(&obj->obj);
>  	return 0;
>  }
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
