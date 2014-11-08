Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaKHQx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 11:53:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaKHQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 11:53:26 -0500
Date: Sat, 8 Nov 2014 08:52:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: sharon <sharon.dvir1@mail.huji.ac.il>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: Fix coding style warning.
Message-ID: <20141108165211.GA17400@kroah.com>
References: <1415464746.12634.10.camel@mail.huji.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415464746.12634.10.camel@mail.huji.ac.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 06:39:06PM +0200, sharon wrote:
> Fix coding style warning.

What coding style warning?  Be specific please.

And your subject:, you aren't saying where in the kernel you are fixing
anything, look at other patches for this file in git, what did the
subject look like for them?

> (First submission, sorry in advance for any dumb stuff I'm missing.
> Let me know and I'll fix it.)

These two sentances don't need to be here :)

> Signed-off-by: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>

This doesn't match up with what the From: line above says, so please fix
the from: line.

> diff --git a/drivers/staging/android/binder.c
> b/drivers/staging/android/binder.c
> index c69c40d..655c3bf 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -1267,8 +1267,8 @@ static void
> binder_transaction_buffer_release(struct binder_proc *proc,
>  		switch (fp->type) {
>  		case BINDER_TYPE_BINDER:
>  		case BINDER_TYPE_WEAK_BINDER: {
> -			struct binder_node *node = binder_get_node(proc, fp->binder);
> -
> +			struct binder_node *node = binder_get_node(proc,
> +								fp->binder);
>  			if (node == NULL) {
>  				pr_err("transaction release %d bad node %016llx\n",
>  				       debug_id, (u64)fp->binder);

What tree did you make this against?  This file isn't in linux-next
anymore, is it?

thanks,

greg k-h
