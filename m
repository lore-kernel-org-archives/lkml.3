Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaI2Lpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:45:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbaI2Lpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:45:43 -0400
Date: Mon, 29 Sep 2014 13:45:40 +0200
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1 linux-next] udf: remove redundant sys_tz declaration
Message-ID: <20140929114540.GA6328@quack.suse.cz>
References: <1411834487-17547-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411834487-17547-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 27-09-14 18:14:47, Fabian Frederick wrote:
> sys_tz is already declared in include/linux/time.h
  Thanks. I've added the patch to my tree.

								Honza

> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/udf/udftime.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
> index 1f11483..77c331f 100644
> --- a/fs/udf/udftime.c
> +++ b/fs/udf/udftime.c
> @@ -81,8 +81,6 @@ static time_t year_seconds[MAX_YEAR_SECONDS] = {
>  /*2038*/ SPY(68, 17, 0)
>  };
>  
> -extern struct timezone sys_tz;
> -
>  #define SECS_PER_HOUR	(60 * 60)
>  #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
>  
> -- 
> 1.9.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
