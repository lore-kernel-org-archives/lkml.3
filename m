Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3KYLGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:06:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8715 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3KYLGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:06:01 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f126d00000418c-74-52932f17ac40
Content-transfer-encoding: 8BIT
Message-id: <1385377506.26319.159.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH V2 3/6] f2fs: Add a new function:
 f2fs_reserve_block()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Mon, 25 Nov 2013 20:05:06 +0900
In-reply-to: <1384096401-25169-4-git-send-email-huajun.li.lee@gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
 <1384096401-25169-4-git-send-email-huajun.li.lee@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zQ11x/clBBideKFi8PKRpceZZB6PF
	li0xFl/777BZXFrkbrFn70kWi8u75rBZbDr5i9WBw2PnrLvsHov3vGTymHcy0GP3gs9MHn1b
	VjF6fN4kF8AWxWWTkpqTWZZapG+XwJVxfsZU5oIWzYrH9w6yNzC2KXQxcnJICJhIzPjdwAhh
	i0lcuLeerYuRi0NIYBmjxKuFK1lhis6++8kEkZjOKLHwZis7SIJXQFDix+R7LF2MHBzMAvIS
	Ry5lg4SZBdQlJs1bxAxR/4pRYtOTy0wQ9XoST2acZgGxhQXCJBYt6WUD6WUT0JbYvN8AJCwk
	oCjxdv9dsL0iQHNev5jLCjKHWeAWo8TD1iNgu1gEVCX2vdMCqeEU8JB4s/A/C8SuVkaJy/tX
	g93GLyAqcXjhdmaIB5Qkdrd3soMUSQj8ZZdY1niGDSTBIiAg8W3yIbChEgKyEpsOQNVLShxc
	cYNlAqPELCRvzkJ4cxaSNxcwMq9iFE0tSC4oTkovMtErTswtLs1L10vOz93ECInYCTsY7x2w
	PsSYDLRxIrOUaHI+MOLzSuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoEx6KfxFc+OX+sbWrYE1YffLPrcNim9We53UYZS9tua0Bipf48SdrsyvL5x
	MrjDwOGe1fZT/ZPWqlqKGB70Oqj17/bL3K+7BT9MCC5y2VhbN1lw/sHvUon1VgFxstd0TZb+
	vfhK8fNT9+en2Ca9udaR/Lhvx+MQllvibWIvr96qT7M6W3lS0vKkEktxRqKhFnNRcSIARMKF
	Ne4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQV1x/clBBo+uSVu8PKRpceZZB6PF
	li0xFl/777BZXFrkbrFn70kWi8u75rBZbDr5i9WBw2PnrLvsHov3vGTymHcy0GP3gs9MHn1b
	VjF6fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQN0jZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/yMqcwFLZoV
	j+8dZG9gbFPoYuTkkBAwkTj77icThC0mceHeerYuRi4OIYHpjBILb7aygyR4BQQlfky+x9LF
	yMHBLCAvceRSNkiYWUBdYtK8RcwQ9a8YJTY9ucwEUa8n8WTGaRYQW1ggTGLRkl42kF42AW2J
	zfsNQMJCAooSb/ffZQWxRYDmvH4xlxVkDrPALUaJh61HwHaxCKhK7HunBVLDKeAh8WbhfxaI
	Xa2MEpf3rwa7jV9AVOLwwu3MEA8oSexu72SfwCg0C8nZsxDOnoXk7AWMzKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxgtPBM+kdjKsaLA4xCnAwKvHwTqyeFCTEmlhWXJl7iFGCg1lJhDdf
	ZXKQEG9KYmVValF+fFFpTmrxIcZkoMMnMkuJJucDU1VeSbyhsYmZkaWRmYWRibk5acJK4rwH
	W60DhQTSE0tSs1NTC1KLYLYwcXBKNTCav/qwyS4h91fKstWWR39d5vbbeDPIKOmR/+fwve/W
	X7m6K/POq/SUpJ2XDWvm7LE5MyVUWGrRwaY/nRxyaYcdd065mhPF69rDnHPhpL7eO0nzHu7n
	SY+Cuc7VnXKUyZlerrS52lXh7vcprB4L1Z7sl4tc5nVzDmdAyBvbI58PGYdGyp+6qtKkxFKc
	kWioxVxUnAgAlRyx5UsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huajun,

I think this clean-up is not related to inline_data series, so I merged
this patch earlier.

Thanks,

2013-11-10 (일), 23:13 +0800, Huajun Li:
> From: Huajun Li <huajun.li@intel.com>
> 
> Add the function f2fs_reserve_block() to easily reserve new blocks, and
> use it to clean up more codes.
> 
> Signed-off-by: Huajun Li <huajun.li@intel.com>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> Signed-off-by: Weihong Xu <weihong.xu@intel.com>
> ---
>  fs/f2fs/data.c |   50 +++++++++++++++++++++++---------------------------
>  fs/f2fs/f2fs.h |    1 +
>  fs/f2fs/file.c |   38 ++++++--------------------------------
>  3 files changed, 30 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index aa3438c..92d0724 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -64,6 +64,22 @@ int reserve_new_block(struct dnode_of_data *dn)
>  	return 0;
>  }
>  
> +int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
> +{
> +	bool need_put = dn->inode_page ? false : true;
> +	int err;
> +
> +	err = get_dnode_of_data(dn, index, ALLOC_NODE);
> +	if (err)
> +		return err;
> +	if (dn->data_blkaddr == NULL_ADDR)
> +		err = reserve_new_block(dn);
> +
> +	if (need_put)
> +		f2fs_put_dnode(dn);
> +	return err;
> +}
> +
>  static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
>  					struct buffer_head *bh_result)
>  {
> @@ -300,19 +316,10 @@ struct page *get_new_data_page(struct inode *inode,
>  	int err;
>  
>  	set_new_dnode(&dn, inode, npage, npage, 0);
> -	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
> +	err = f2fs_reserve_block(&dn, index);
>  	if (err)
>  		return ERR_PTR(err);
>  
> -	if (dn.data_blkaddr == NULL_ADDR) {
> -		if (reserve_new_block(&dn)) {
> -			if (!npage)
> -				f2fs_put_dnode(&dn);
> -			return ERR_PTR(-ENOSPC);
> -		}
> -	}
> -	if (!npage)
> -		f2fs_put_dnode(&dn);
>  repeat:
>  	page = grab_cache_page(mapping, index);
>  	if (!page)
> @@ -644,21 +651,15 @@ repeat:
>  	*pagep = page;
>  
>  	f2fs_lock_op(sbi);
> -
>  	set_new_dnode(&dn, inode, NULL, NULL, 0);
> -	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
> -	if (err)
> -		goto err;
> -
> -	if (dn.data_blkaddr == NULL_ADDR)
> -		err = reserve_new_block(&dn);
> -
> -	f2fs_put_dnode(&dn);
> -	if (err)
> -		goto err;
> -
> +	err = f2fs_reserve_block(&dn, index);
>  	f2fs_unlock_op(sbi);
>  
> +	if (err) {
> +		f2fs_put_page(page, 1);
> +		return err;
> +	}
> +
>  	if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
>  		return 0;
>  
> @@ -691,11 +692,6 @@ out:
>  	SetPageUptodate(page);
>  	clear_cold_data(page);
>  	return 0;
> -
> -err:
> -	f2fs_unlock_op(sbi);
> -	f2fs_put_page(page, 1);
> -	return err;
>  }
>  
>  static int f2fs_write_end(struct file *file,
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index cd7d2f9..de84f52 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1119,6 +1119,7 @@ void destroy_checkpoint_caches(void);
>   * data.c
>   */
>  int reserve_new_block(struct dnode_of_data *);
> +int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
>  void update_extent_cache(block_t, struct dnode_of_data *);
>  struct page *find_data_page(struct inode *, pgoff_t, bool);
>  struct page *get_lock_data_page(struct inode *, pgoff_t);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 7d714f4..1cd8e44 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -33,7 +33,6 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
>  	struct page *page = vmf->page;
>  	struct inode *inode = file_inode(vma->vm_file);
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> -	block_t old_blk_addr;
>  	struct dnode_of_data dn;
>  	int err;
>  
> @@ -44,24 +43,10 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
>  	/* block allocation */
>  	f2fs_lock_op(sbi);
>  	set_new_dnode(&dn, inode, NULL, NULL, 0);
> -	err = get_dnode_of_data(&dn, page->index, ALLOC_NODE);
> -	if (err) {
> -		f2fs_unlock_op(sbi);
> -		goto out;
> -	}
> -
> -	old_blk_addr = dn.data_blkaddr;
> -
> -	if (old_blk_addr == NULL_ADDR) {
> -		err = reserve_new_block(&dn);
> -		if (err) {
> -			f2fs_put_dnode(&dn);
> -			f2fs_unlock_op(sbi);
> -			goto out;
> -		}
> -	}
> -	f2fs_put_dnode(&dn);
> +	err = f2fs_reserve_block(&dn, page->index);
>  	f2fs_unlock_op(sbi);
> +	if (err)
> +		goto out;
>  
>  	file_update_time(vma->vm_file);
>  	lock_page(page);
> @@ -532,22 +517,11 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
>  
>  		f2fs_lock_op(sbi);
>  		set_new_dnode(&dn, inode, NULL, NULL, 0);
> -		ret = get_dnode_of_data(&dn, index, ALLOC_NODE);
> -		if (ret) {
> -			f2fs_unlock_op(sbi);
> +		ret = f2fs_reserve_block(&dn, index);
> +		f2fs_unlock_op(sbi);
> +		if (ret)
>  			break;
> -		}
>  
> -		if (dn.data_blkaddr == NULL_ADDR) {
> -			ret = reserve_new_block(&dn);
> -			if (ret) {
> -				f2fs_put_dnode(&dn);
> -				f2fs_unlock_op(sbi);
> -				break;
> -			}
> -		}
> -		f2fs_put_dnode(&dn);
> -		f2fs_unlock_op(sbi);
>  
>  		if (pg_start == pg_end)
>  			new_size = offset + len;

-- 
Jaegeuk Kim
Samsung

