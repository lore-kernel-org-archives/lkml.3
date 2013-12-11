Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab3LKFxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:53:09 -0500
Received: from cobra.newdream.net ([66.33.216.30]:32790 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3LKFxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:53:05 -0500
Date: Tue, 10 Dec 2013 21:53:05 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Libo Chen <clbchenlibo.chen@huawei.com>
cc: majianpeng <majianpeng@gmail.com>, yunchuanwen@ubuntukylin.com,
        liwang@ubuntukylin.com, zheng.z.yan@intel.com,
        ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, milosz@adfin.com
Subject: Re: [PATCH] fs: ceph: new helper: file_inode(file)
In-Reply-To: <52A7FCD7.2080809@huawei.com>
Message-ID: <alpine.DEB.2.00.1312102152210.18451@cobra.newdream.net>
References: <52A7FCD7.2080809@huawei.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!

On Wed, 11 Dec 2013, Libo Chen wrote:

> 
> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
> ---
>  fs/ceph/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 3de8982..7549bd6 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1018,7 +1018,7 @@ static long ceph_fallocate(struct file *file, int mode,
>  				loff_t offset, loff_t length)
>  {
>  	struct ceph_file_info *fi = file->private_data;
> -	struct inode *inode = file->f_dentry->d_inode;
> +	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_osd_client *osdc =
>  		&ceph_inode_to_client(inode)->client->osdc;
> -- 
> 1.8.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
