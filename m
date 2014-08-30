Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaH3VFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:05:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3VFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:05:33 -0400
Date: Sat, 30 Aug 2014 14:05:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Purnendu Kapadia <pro8linux@gmail.com>
Cc: joe@perches.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        konkers@android.com
Subject: Re: [PATCH] staging: android: Add blank line after declaration
Message-ID: <20140830210533.GA29432@kroah.com>
References: <1408547959-27963-1-git-send-email-pro8linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408547959-27963-1-git-send-email-pro8linux@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 04:19:19PM +0100, Purnendu Kapadia wrote:
> Signed-off-by: Purnendu Kapadia <pro8linux@gmail.com>
> ---
>  drivers/staging/android/sync.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
> index e7b2e02..0d37495 100644
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

Someone sent this same patch just before you did, sorry.

greg k-h
