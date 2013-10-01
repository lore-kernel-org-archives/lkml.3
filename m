Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3JAL3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:29:42 -0400
Received: from imap.thunk.org ([74.207.234.97]:40663 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3JAL3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:29:40 -0400
Date: Tue, 1 Oct 2013 07:29:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the random tree
Message-ID: <20131001112937.GC1994@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20131001110344.GA20249@ulmo.nvidia.com>
 <1380625644-11331-6-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380625644-11331-6-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 01:07:22PM +0200, Thierry Reding wrote:
> Today's linux-next merge of the random tree got a conflict in:
> 
> 	init/main.c
> 
> I fixed it up (see below). Please check if the resolution looks correct.

Looks good, thanks.

						- Ted

> 
> Thanks,
> Thierry
> ---
> diff --cc init/main.c
> index 7cc4b78,586cd33..379090f
> --- a/init/main.c
> +++ b/init/main.c
> @@@ -75,7 -75,7 +75,8 @@@
>   #include <linux/blkdev.h>
>   #include <linux/elevator.h>
>   #include <linux/sched_clock.h>
>  +#include <linux/context_tracking.h>
> + #include <linux/random.h>
>   
>   #include <asm/io.h>
>   #include <asm/bugs.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
