Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab3CMWpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:45:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934380Ab3CMWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:45:04 -0400
Date: Wed, 13 Mar 2013 15:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-Id: <20130313154502.415905f01b5fef19cf796bdc@linux-foundation.org>
In-Reply-To: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-3-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 15:16:26 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Export do_splice_direct() to modules.  Needed by overlay filesystem.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/splice.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 718bd00..0e8f44a 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1308,6 +1308,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL(do_splice_direct);

_GPL?
