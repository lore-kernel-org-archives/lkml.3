Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423174Ab3FUD4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:56:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48857 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422992Ab3FUD4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:56:38 -0400
Date: Thu, 20 Jun 2013 15:56:38 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] Ceph: Punch hole support
To: Li Wang <liwang@ubuntukylin.com>
Cc: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
        linux-fsdevel@vger.kernel.org
References: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com>
	<1371224340-4926-1-git-send-email-liwang@ubuntukylin.com>
	<alpine.DEB.2.00.1306140902490.26467@cobra.newdream.net>
	<51C1DB17.6040803@ubuntukylin.com>
In-Reply-To: <51C1DB17.6040803@ubuntukylin.com> (from liwang@ubuntukylin.com
	on Wed Jun 19 11:23:51 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371761798.2776.134@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 11:23:51 AM, Li Wang wrote:
> This patch implements punch hole (fallocate) support for Ceph.
> 
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <wenyunchuan@ubuntukylin.com>

> +static int ceph_delete_object(struct inode *inode, u64 offset, u64  
> *length)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +    struct ceph_fs_client *fsc = ceph_inode_to_client(inode);	
> +	struct ceph_osd_request *req;

Mixing tabs and spaces.


> +static int ceph_punch_hole(struct file *file, loff_t offset, loff_t  
> length)
> +{
> +	struct inode *inode = file->f_dentry->d_inode;
> +	int ret = 0;
> +
> +    if (!S_ISREG(inode->i_mode)) {
> +        return -EOPNOTSUPP;
> +	}

And again.

Rob