Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3FCI6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab3FCI6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:58:37 -0400
Subject: Re: [Cluster-devel] [PATCH] GFS2: Cocci spatch "ptr_ret.spatch"
From: Steven Whitehouse <swhiteho@redhat.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1370080363.29224.24.camel@localhost.localdomain>
References: <1370080363.29224.24.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 03 Jun 2013 09:55:54 +0100
Message-ID: <1370249754.2785.0.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Sat, 2013-06-01 at 11:52 +0200, Thomas Meyer wrote:
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -587,7 +587,7 @@ static int gfs2_create_inode(struct inod
>  		inode = gfs2_lookupi(dir, &dentry->d_name, 0);
>  		gfs2_glock_dq_uninit(ghs);
>  		d_instantiate(dentry, inode);
> -		return IS_ERR(inode) ? PTR_ERR(inode) : 0;
> +		return PTR_RET(inode);
>  	}
>  	if (error)
>  		goto fail_gunlock;
> 
> 


