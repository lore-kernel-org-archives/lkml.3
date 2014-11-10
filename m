Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaKJHsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:48:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49297 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaKJHs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:48:29 -0500
X-AuditID: cbfee68f-f791c6d000004834-5e-54606dcb6345
Date: Mon, 10 Nov 2014 16:47:12 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: implement -o dirsync
Message-id: <20141110074712.GD14659@lcm>
References: <1415600662-23337-1-git-send-email-jaegeuk@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1415600662-23337-1-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+Zse7p3IQQg+NPhS2erJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgylg86S5bwWPJil9T
	NRoYn4t0MXJwSAiYSCxa5dbFyAlkiklcuLeerYuRi0NIYBmjxMPri9ggEiYS625tZIVILGKU
	OLXwFlhCSOAno8T7Hh4Qm0VAVeLetC3MIDabgJZE++m1LCC2iICKxKFFl9lBbGaBTIkJ/S/A
	bGEBK4m+5+dZQWxeAQ2JS+v7GCFmOkn8X3CWHSIuKPFj8j0WiF4tifU7jzNB2NISj/7OAKvh
	FHCWuLbgKNheUaBdU05uA/tAQmARu0TjtOeMEMcJSHybfIgF4mNZiU0HmCEek5Q4uOIGywRG
	sVlI1s1Csm4WknULGJlXMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoTET/8OxrsHrA8xCnAw
	KvHwenyJDxFiTSwrrsw9xGgKdMVEZinR5HxglOaVxBsamxlZmJqYGhuZW5opifMulPoZLCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoGxeNuPhHUT2i5s+p/LxV3L8Xjq4dnpf8sbbz1cmvbY
	SXpfuzuT4vXJLms5d6y3OvBg4/r75kHVkhMYdrJHaBfv9rL9P2XdqT87YkN3bd2wSfsC5yPB
	4/mnriy7fqMl9W92xQm9n458+WFL9otvkTy+x1syh/FbzG/9o08XzBed8vpm0H2xLJPED0os
	xRmJhlrMRcWJAGOqQh2aAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd3TuQkhBue7BCyerJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xYPOkuW8FjyYpfUzUaGJ+LdDFyckgImEisu7WRFcIWk7hwbz1bFyMXh5DA
	IkaJUwtvsYEkhAR+Mkq87+EBsVkEVCXuTdvCDGKzCWhJtJ9eywJiiwioSBxadJkdxGYWyJSY
	0P8CzBYWsJLoe34ebAGvgIbEpfV9jBAznST+LzjLDhEXlPgx+R4LRK+WxPqdx5kgbGmJR39n
	gNVwCjhLXFtwFGyvKNCuKSe3sU1gFJiFpH0WkvZZSNoXMDKvYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAiOz2dSOxhXNlgcYhTgYFTi4XV4Gx8ixJpYVlyZe4hRgoNZSYS39j9QiDclsbIq
	tSg/vqg0J7X4EKMpMDQmMkuJJucDU0deSbyhsYmZkaWRmYWRibm5kjjvgVbrQCGB9MSS1OzU
	1ILUIpg+Jg5OqQbGltKpxcf/fqsNyDPsOLt+mbqBUfqCzSdPmMyvTez3nleQ5zjn0bOesgub
	uD/9Z5H1Nv4ovYYnpSbDsPfxrOyvSYJr1uU++XH5ytJYm6dlKru1pib/5X326IQM1yOf3+uF
	LNX8uU+yP16zzGXfnrksUzMnrrK5k+T64uZT8fhtfDcEl+1wm3hCRomlOCPRUIu5qDgRAEqo
	BkzlAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 10:24:22PM -0800, Jaegeuk Kim wrote:
> If a mount option has dirsync, we should call checkpoint for all the directory
> operations.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/namei.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 6312dd2..db3ee09 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -138,6 +138,9 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  	stat_inc_inline_inode(inode);
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
> +
> +	if (IS_DIRSYNC(dir))
> +		f2fs_sync_fs(sbi->sb, 1);
>  	return 0;
>  out:
>  	handle_failed_inode(inode);
> @@ -164,6 +167,9 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
>  	f2fs_unlock_op(sbi);
>  
>  	d_instantiate(dentry, inode);
> +
> +	if (IS_DIRSYNC(dir))
> +		f2fs_sync_fs(sbi->sb, 1);
>  	return 0;
>  out:
>  	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
> @@ -233,6 +239,9 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
>  	f2fs_delete_entry(de, page, dir, inode);
>  	f2fs_unlock_op(sbi);
>  
> +	if (IS_DIRSYNC(dir))
> +		f2fs_sync_fs(sbi->sb, 1);
> +
>  	/* In order to evict this inode, we set it dirty */
>  	mark_inode_dirty(inode);

Let's move it below mark_inode_dirty.
After sync, it's unnecessary inserting inode into dirty_list.


>  fail:
> @@ -268,6 +277,9 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
>  
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
> +
> +	if (IS_DIRSYNC(dir))
> +		f2fs_sync_fs(sbi->sb, 1);
>  	return err;
>  out:
>  	handle_failed_inode(inode);
> @@ -304,6 +316,8 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
>  
> +	if (IS_DIRSYNC(dir))
> +		f2fs_sync_fs(sbi->sb, 1);
>  	return 0;
>  
>  out_fail:
> @@ -346,8 +360,12 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
>  	f2fs_unlock_op(sbi);
>  
>  	alloc_nid_done(sbi, inode->i_ino);
> +
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
> +
> +	if (IS_DIRSYNC(dir))
> +		f2fs_sync_fs(sbi->sb, 1);
>  	return 0;
>  out:
>  	handle_failed_inode(inode);
> @@ -461,6 +479,9 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	}
>  
>  	f2fs_unlock_op(sbi);
> +
> +	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
> +		f2fs_sync_fs(sbi->sb, 1);
>  	return 0;
>  
>  put_out_dir:
> @@ -600,6 +621,9 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	update_inode_page(new_dir);
>  
>  	f2fs_unlock_op(sbi);
> +
> +	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
> +		f2fs_sync_fs(sbi->sb, 1);
>  	return 0;
>  out_undo:
>  	/* Still we may fail to recover name info of f2fs_inode here */
> -- 
> 2.1.1
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
