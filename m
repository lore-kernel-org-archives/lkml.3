Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaFXPxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:53:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbaFXPw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:52:58 -0400
Date: Tue, 24 Jun 2014 17:52:56 +0200
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] FS/UDF: use linux/uaccess.h (2)
Message-ID: <20140624155256.GG25832@quack.suse.cz>
References: <1403293990-3123-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403293990-3123-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-06-14 21:53:10, Fabian Frederick wrote:
> Fix checkpatch warning
> WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> 
> on 3 more files.
  Thanks. I've combined this patch with your previous one for the same
issue.

								Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/udf/lowlevel.c | 2 +-
>  fs/udf/super.c    | 2 +-
>  fs/udf/symlink.c  | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/udf/lowlevel.c b/fs/udf/lowlevel.c
> index 6583fe9..6ad5a45 100644
> --- a/fs/udf/lowlevel.c
> +++ b/fs/udf/lowlevel.c
> @@ -21,7 +21,7 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/cdrom.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  
>  #include "udf_sb.h"
>  
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3286db0..813da94 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -63,7 +63,7 @@
>  #include "udf_i.h"
>  
>  #include <linux/init.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  
>  #define VDS_POS_PRIMARY_VOL_DESC	0
>  #define VDS_POS_UNALLOC_SPACE_DESC	1
> diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
> index d7c6dbe..6fb7945 100644
> --- a/fs/udf/symlink.c
> +++ b/fs/udf/symlink.c
> @@ -20,7 +20,7 @@
>   */
>  
>  #include "udfdecl.h"
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  #include <linux/errno.h>
>  #include <linux/fs.h>
>  #include <linux/time.h>
> -- 
> 1.8.4.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
