Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaIAWPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:15:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaIAWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:15:19 -0400
Date: Mon, 1 Sep 2014 15:15:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Grzegorz Swirski <grzegorz@swirski.name>
Cc: john.stultz@linaro.org, daniel@ffwll.ch, waydi1@gmail.com,
        alistair.strachan@imgtec.com, pkamliya@codeaurora.org,
        executerx@gmail.com, maarten.lankhorst@canonical.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: add a blank line after declarations
Message-ID: <20140901221518.GA29791@kroah.com>
References: <1409517795-10237-1-git-send-email-grzegorz@swirski.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409517795-10237-1-git-send-email-grzegorz@swirski.name>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 09:43:15PM +0100, Grzegorz Swirski wrote:
> Signed-off-by: Grzegorz Swirski <grzegorz@swirski.name>
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

This patch is already in my tree, sorry, I can't accept it ;(

greg k-h
