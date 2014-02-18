Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaBRRGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:06:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaBRRG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:06:28 -0500
Date: Tue, 18 Feb 2014 09:07:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: android: binder: remove unnecessary comment
Message-ID: <20140218170753.GB32227@kroah.com>
References: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 08:23:25PM +0900, SeongJae Park wrote:
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> ---
>  drivers/staging/android/binder.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index eaec1da..b23cbc9 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2553,8 +2553,6 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	unsigned int size = _IOC_SIZE(cmd);
>  	void __user *ubuf = (void __user *)arg;
>  
> -	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/

It's useful for debugging, I'll leave it as-is, sorry.
