Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaG0UBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 16:01:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaG0UBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 16:01:24 -0400
Date: Sun, 27 Jul 2014 13:00:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Liviu I." <liviu.i.2222@gmail.com>
Cc: amk@cray.com, liang.zhen@intel.com, uja.ornl@gmail.com,
        emoly.liu@intel.com, rashika.kheria@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Eudyptula Challenge (Task 10)
Message-ID: <20140727200055.GA17243@kroah.com>
References: <20140727195637.GA23931@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140727195637.GA23931@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 08:56:38PM +0100, Liviu I. wrote:
> Hello Kernel Developers!
> 
> I've attached a small patch to fix a coding style problem and make checkpatch happy, as part of challenge 10 of Eudyptula.
> 
> Thank you

> --- drivers/staging/lustre/lustre/ldlm/ldlm_extent.c.orig	2014-07-27 20:26:53.714161698 +0100
> +++ drivers/staging/lustre/lustre/ldlm/ldlm_extent.c	2014-07-27 20:27:50.410159692 +0100
> @@ -151,7 +151,8 @@ static inline int lock_mode_to_index(ldl
>  
>  	LASSERT(mode != 0);
>  	LASSERT(IS_PO2(mode));
> -	for (index = -1; mode; index++, mode >>= 1) ;
> +	for (index = -1; mode; index++, mode >>= 1)
> +		;
>  	LASSERT(index < LCK_MODE_NUM);
>  	return index;
>  }

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch does not have a Signed-off-by: line.  Please read the
  kernel file, Documentation/SubmittingPatches and resend it after
  adding that line.  Note, the line needs to be in the body of the
  email, before the patch, not at the bottom of the patch or in the
  email signature.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
