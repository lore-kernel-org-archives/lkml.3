Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbbAXAH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:07:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbAXAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:07:25 -0500
Date: Sat, 24 Jan 2015 08:07:22 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in
Subject: Re: [PATCH 2/2] Staging: comedi: Fix warning line over 80 character
Message-ID: <20150124000722.GA11819@kroah.com>
References: <1422035602-17295-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422035602-17295-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:23:22PM +0530, jitendra kumar khasdev wrote:
> This is patch to file ni_labpc_cs.c that fix warning line
> over 80 character which is found by checkpatch tool.
> 
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_labpc_cs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c b/drivers/staging/comedi/drivers/ni_labpc_cs.c
> index 0a8b322..9858ab1 100644
> --- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
> +++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
> @@ -1,7 +1,8 @@
>  /*
>      comedi/drivers/ni_labpc_cs.c
>      Driver for National Instruments daqcard-1200 boards
> -    Copyright (C) 2001, 2002, 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
> +    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
> +    <fmhess@users.sourceforge.net>

That looks worse now, please make changes that need to be made and make
things better looking.

thanks,

greg k-h
