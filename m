Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaKAEm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 00:42:57 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38999 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaKAEm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 00:42:56 -0400
Date: Sat, 1 Nov 2014 10:12:45 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove outdated TODO tasks
Message-ID: <20141101044245.GA3642@sudip-PC>
References: <1414789606-7170-1-git-send-email-marius.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414789606-7170-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:06:46PM +0100, Mariusz Gorski wrote:
> Remove Lindent and checkpatch.pl tasks from TODO file as the first one
> is obsolete and the other one is already done.

when i checked panel.c with checkpatch and with --strict option, i got 20 checks.

thanks
sudip

> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> ---
>  drivers/staging/panel/TODO | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/panel/TODO b/drivers/staging/panel/TODO
> index a4be749..c8040c1 100644
> --- a/drivers/staging/panel/TODO
> +++ b/drivers/staging/panel/TODO
> @@ -1,6 +1,4 @@
>  TODO:
> -	- checkpatch.pl cleanups
> -	- Lindent
>  	- review major/minor usages
>  	- review userspace api
>  	- see if all of this could be easier done in userspace instead.
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
