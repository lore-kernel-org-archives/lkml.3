Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3DXOij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:38:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab3DXOii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:38:38 -0400
Date: Wed, 24 Apr 2013 16:38:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: fix trivial typo in the comment
In-Reply-To: <1366626999-6270-1-git-send-email-andriy.shevchenko@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1304241637530.29143@pobox.suse.cz>
References: <1366626999-6270-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Andy Shevchenko wrote:

> This fixes "iff" as "if".
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  lib/string.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/string.c b/lib/string.c
> index e5878de..e551284 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -542,7 +542,7 @@ EXPORT_SYMBOL(sysfs_streq);
>   * @s: input string
>   * @res: result
>   *
> - * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
> + * This routine returns 0 if the first character is one of 'Yy1Nn0'.
>   * Otherwise it will return -EINVAL.  Value pointed to by res is
>   * updated upon finding a match.
>   */

And this is correct because ... ?

-- 
Jiri Kosina
SUSE Labs
