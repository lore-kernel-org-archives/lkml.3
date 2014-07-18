Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbaGRXQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:16:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaGRXQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:16:11 -0400
Date: Fri, 18 Jul 2014 16:16:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: devel@driverdev.osuosl.org, waydi1@gmail.com, swetland@google.com,
        linux-kernel@vger.kernel.org, daniel@ffwll.ch
Subject: Re: [PATCH] staging: android: Fixed missing blank line
Message-ID: <20140718231610.GA29987@kroah.com>
References: <1405658874-24448-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405658874-24448-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 10:17:54AM +0530, Sanjeev Sharma wrote:
> This patch will add an blank line after
> declaration reported by checkpatch.pl script.
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
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

I already applied a previous version of this patch, with your gmail
address :(
