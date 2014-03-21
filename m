Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbaCURil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:38:41 -0400
Received: from cobra.newdream.net ([66.33.216.30]:49200 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbaCURid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:38:33 -0400
Date: Fri, 21 Mar 2014 10:38:32 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/1 RESEND] fs/ceph/inode.c: Remove get/set acl on
 symlinks
In-Reply-To: <20140321174001.3a2c665e84aed66f387ca4fc@skynet.be>
Message-ID: <alpine.DEB.2.00.1403211037400.5823@cobra.newdream.net>
References: <20140321174001.3a2c665e84aed66f387ca4fc@skynet.be>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've pulled this into the Ceph tree.

Thanks, Fabian!
sage


On Fri, 21 Mar 2014, Fabian Frederick wrote:

> Remove unsupported symlink operations.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/ceph/inode.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 32d519d..704d714 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1616,8 +1616,6 @@ static const struct inode_operations ceph_symlink_iops = {
>  	.getxattr = ceph_getxattr,
>  	.listxattr = ceph_listxattr,
>  	.removexattr = ceph_removexattr,
> -	.get_acl = ceph_get_acl,
> -	.set_acl = ceph_set_acl,
>  };
>  
>  /*
> -- 
> 1.8.4.5
> 
> 
