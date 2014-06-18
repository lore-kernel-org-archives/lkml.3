Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaFRSOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:14:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaFRSOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:14:18 -0400
Date: Wed, 18 Jun 2014 20:14:14 +0200
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] fs/udf/file.c: use linux/uaccess.h
Message-ID: <20140618181414.GA23124@quack.suse.cz>
References: <1403113104-7436-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403113104-7436-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-06-14 19:38:24, Fabian Frederick wrote:
> Fix checkpatch warning
> WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
  Thanks. Added to my tree.

								Honza

> ---
>  fs/udf/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index d80738f..72b8dae 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -27,7 +27,7 @@
>  
>  #include "udfdecl.h"
>  #include <linux/fs.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h> /* memset */
>  #include <linux/capability.h>
> -- 
> 1.8.4.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
