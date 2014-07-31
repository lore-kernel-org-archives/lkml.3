Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaGaASK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:18:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaGaASI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:18:08 -0400
Date: Wed, 30 Jul 2014 17:17:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        ydroneaud@opteya.com, waydi1@gmail.com, daniel@ffwll.ch,
        maarten.lankhorst@canonical.com, sumit.semwal@linaro.org
Subject: Re: [PATCH] Staging: android: sw_sync.c: fix missing blank line
 after declaration
Message-ID: <20140731001740.GA31573@kroah.com>
References: <1406587103-5784-1-git-send-email-mopsfelder@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406587103-5784-1-git-send-email-mopsfelder@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:38:23PM -0300, Murilo Opsfelder Araujo wrote:
> Fix coding style issue.
> 
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> ---
>  drivers/staging/android/sw_sync.c |    2 ++
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

Does not apply to my tree at all :(
