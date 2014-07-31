Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaGaASd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:18:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaGaASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:18:32 -0400
Date: Wed, 30 Jul 2014 17:17:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: sync.c: fix missing blank line after
 declaration
Message-ID: <20140731001758.GB31573@kroah.com>
References: <1406588626-6882-1-git-send-email-mopsfelder@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406588626-6882-1-git-send-email-mopsfelder@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:03:46PM -0300, Murilo Opsfelder Araujo wrote:
> Fix coding style issue.
> 
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> ---
>  drivers/staging/android/sync.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
> index e7b2e02..69c16cb 100644
> --- a/drivers/staging/android/sync.c
> +++ b/drivers/staging/android/sync.c
> @@ -705,6 +705,7 @@ static long sync_fence_ioctl(struct file *file, unsigned int cmd,
>  			     unsigned long arg)
>  {
>  	struct sync_fence *fence = file->private_data;
> +
>  	switch (cmd) {
>  	case SYNC_IOC_WAIT:
>  		return sync_fence_ioctl_wait(fence, arg);
> @@ -726,4 +727,3 @@ static const struct file_operations sync_fence_fops = {
>  	.unlocked_ioctl = sync_fence_ioctl,
>  	.compat_ioctl = sync_fence_ioctl,
>  };
> -

Also doesn't apply, are you sure you are using the staging-next branch
of staging.git on git.kernel.org?

thanks,

greg k-h
