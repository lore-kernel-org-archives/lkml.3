Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab3CMUFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:05:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57355 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:05:45 -0400
Date: Wed, 13 Mar 2013 20:05:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] overlayfs: Print info into the logs when loaded
Message-ID: <20130313200542.GN21522@ZenIV.linux.org.uk>
References: <1363204034-2442-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363204034-2442-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 08:47:14PM +0100, Sedat Dilek wrote:
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
>  fs/overlayfs/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 482c26f..e30141f 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -674,6 +674,8 @@ MODULE_ALIAS_FS("overlayfs");
>  
>  static int __init ovl_init(void)
>  {
> +	printk(KERN_INFO "overlayfs: loaded\n");
> +

Could we please create a new maillist for that kind of stuff?  It's seriously
overdue, IMO.  linux-bikeshedding@vger.kernel.org, if davem doesn't mind
touching that...
