Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaIXWDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:03:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIXWDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:03:44 -0400
Date: Thu, 25 Sep 2014 00:02:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Elshad Mustafayev <elshadimo@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver: staging: android: binder.c: Fixed line over 80
 characters warning.
Message-ID: <20140924220247.GB31890@kroah.com>
References: <20140923231209.GA3785@emustafa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923231209.GA3785@emustafa>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:12:09PM -0400, Elshad Mustafayev wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Elshad Mustafayev <elshadimo@gmail.com>
> ---
>  drivers/staging/android/binder.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index c69c40d..71424bf 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -664,8 +664,9 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
>  		ALIGN(offsets_size, sizeof(void *));
>  
>  	if (size < data_size || size < offsets_size) {
> -		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
> -				proc->pid, data_size, offsets_size);
> +		binder_user_error(
> +			"%d: got transaction with invalid size %zd-%zd\n",
> +			proc->pid, data_size, offsets_size);

Nope, original code is just fine, checkpatch is giving you a
false-warning here.

greg k-h
