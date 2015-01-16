Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbbAPFyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 00:54:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40137 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbbAPFyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 00:54:18 -0500
X-AuditID: cbfee68f-f791c6d000004834-bf-54b8a78859c1
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dmitry Monakhov'" <dmonakhov@openvz.org>,
        "'Dave Chinner'" <david@fromorbit.com>,
        "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>
Cc: "'Brian Foster'" <bfoster@redhat.com>,
        "=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?=" <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
 <87sifc137b.fsf@openvz.org>
In-reply-to: <87sifc137b.fsf@openvz.org>
Subject: RE: [RFC PATCH] fs: file freeze support
Date: Fri, 16 Jan 2015 14:54:15 +0900
Message-id: <003e01d03150$dc823590$9586a0b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIaHX/tiVElMfpe/JaCs3xh3Ky4MgIUlRronB3A0dA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkRLdj+Y4Qg7kfZSyWTrzEbPHuc5XF
	lmP3GC1OzPS0WPZgM4vFnr0nWSwu75rDZtHa85Pd4vzf46wOnB6nFkl4NJ05yuwx6fBnJo/3
	+66yefRtWcXo8XmTnMemJ2+ZAtijuGxSUnMyy1KL9O0SuDJeHTrDWLBBteLd/namBsYbsl2M
	nBwSAiYSpz48YYGwxSQu3FvP1sXIxSEksJRRYmf/IvYuRg6wolsfHCDiixglVsw/xQ7h/GWU
	mLrjCStIEZuAtsSfLaIgg0QEFjNKfLiTA1LDLHCBUeL0+4lsIAkhgXCJ51e6mEBsTgENiedT
	X7GD2MICBhJHes6D2SwCqhJX3y4Eu4hXwFJi0tpzzBC2oMSPyfdYQHYxC+hIfJ0UARJmFpCX
	2LzmLTPEAwoSO86+ZoS4wUri1e+9bBA1IhL7XrxjBLlHQqCXQ2L/6+2MELsEJL5NPsQC8aSs
	xKYDUHMkJQ6uuMEygVFiFpLNsxA2z0KyeRaSDQsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn
	525iBEb36X/P+ncw3j1gfYhRgINRiYeXwW97iBBrYllxZe4hRlOggyYyS4km5wNTSF5JvKGx
	mZGFqYmpsZG5pZmSOO9CqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhibNW2W504X+Xpw
	8cujexd+VGGQyuPn+vNZ1frMVM6jbZEHJDX2J181U4lR3S21eO1x/fhLBrOt7G+8kKh272+V
	PCJz9ct/LmNHDUGeTTIRMTv+fDGu8wsPmsQb9qTnmdbBkOuXDW6wnc9xtA1eE2Rm4pf/ZPGt
	Rd3bzum0nBKrU3ixcpWkdYQSS3FGoqEWc1FxIgATQY046QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd2O5TtCDK7tErVYOvESs8W7z1UW
	W47dY7Q4MdPTYtmDzSwWe/aeZLG4vGsOm0Vrz092i/N/j7M6cHqcWiTh0XTmKLPHpMOfmTze
	77vK5tG3ZRWjx+dNch6bnrxlCmCPamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAE6TEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOY8erQGcaCDaoV7/a3MzUw3pDtYuTgkBAwkbj1waGLkRPIFJO4cG89WxcjF4eQwCJGiRXz
	T7FDOH8ZJabueMIK0sAmoC3xZ4soSIOIwGJGiQ93ckBqmAUuMEqcfj+RDSQhJBAu8fxKFxOI
	zSmgIfF86it2EFtYwEDiSM95MJtFQFXi6tuFLCA2r4ClxKS155ghbEGJH5PvsYDsYhbQkfg6
	KQIkzCwgL7F5zVtmiEMVJHacfc0IcYOVxKvfe9kgakQk9r14xziBUWgWkkmzECbNQjJpFpKO
	BYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCU8cz6R2MqxosDjEKcDAq8fAy+G0PEWJN
	LCuuzD3EKMHBrCTC29i9I0SINyWxsiq1KD++qDQntfgQoynQnxOZpUST84FpLa8k3tDYxMzI
	0sjc0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgdHIsbH01pp217LlMiuMYueXi2b6
	X80P/rzCWdrx8L8upy2TFz9YsTCl6Z3eq5KVSoWVHnz53795NsdOi3stMWHnjnXf164w9UvR
	PPfdfvmmqhWXmB42KlnNv3Ik6GN8oLfIJ79rd08n1B3fd+s9/3Qn+RPMOowVQa4+iiqJN18V
	nvo92/uvv4kSS3FGoqEWc1FxIgA/q1soMwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > For implementation purpose, initially we tried to keep percpu usage counters
> > inside struct inode just like there is struct sb_writers in super_block.
> > But considering that it will significantly bloat up struct inode when actually
> > the usage of file write freeze will be infrequent, we dropped this idea.
> > Instead we have tried to use already present filesystem freezing infrastructure.
> > Current approach makes it possible for implementing file write freeze without
> > bloating any of struct super_block/inode.
> > In FS_IOC_FWFREEZE, we wait for complete fs to be frozen, set I_WRITE_FREEZED to
> > inode's state and unfreeze the fs.
> Looks interesting. I have added some comments below.
Hi Dmitry,
First, Thanks for your opinion.
> >

> > @@ -40,6 +40,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
> >
> >  	f2fs_balance_fs(sbi);
> >
> > +	inode_start_write(inode);
> >  	sb_start_pagefault(inode->i_sb);
> IMHO it is reasonable to fold sb_start_{write,pagefault}, to inode_start_{write,pagefault}
Agree.
> >
> > +void inode_start_write(struct inode *inode)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +
> > +retry:
> > +	spin_lock(&inode->i_lock);
> This means that i_lock will be acquired on each mkpage_write for all
> users who do not care about fsfreeze which result smp performance drawback
> It is reasonable to add lockless test first because flag is set while
> whole fs is frozen so we can not enter this routine.
Right, I will remove it.
> 
> > +	if (inode->i_state & I_WRITE_FREEZED) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
> > +				TASK_UNINTERRUPTIBLE);
> > +		spin_unlock(&inode->i_lock);
> > +		schedule();
> > +		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
> > +		goto retry;
> > +	}
> > +	spin_unlock(&inode->i_lock);
> > +}
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 214c3c1..c8e9ae3 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -540,6 +540,28 @@ static int ioctl_fsthaw(struct file *filp)
> >  	return thaw_super(sb);
> >  }
> >
> > +static int ioctl_filefreeze(struct file *filp)
> > +{
> > +	struct inode *inode = file_inode(filp);
> > +
> > +	if (!inode_owner_or_capable(inode))
> > +		return -EPERM;
> > +
> > +	/* Freeze */
> > +	return file_write_freeze(inode);
> > +}
> 
> > +
> > +static int ioctl_filethaw(struct file *filp)
> > +{
> > +	struct inode *inode = file_inode(filp);
> > +
> > +	if (!inode_owner_or_capable(inode))
> > +		return -EPERM;
> > +
> > +	/* Thaw */
> > +	return file_write_unfreeze(inode);
> > +}
> > +
> >  /*
> >   * When you add any new common ioctls to the switches above and below
> >   * please update compat_sys_ioctl() too.
> > @@ -589,6 +611,14 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
> >  		error = ioctl_fsthaw(filp);
> >  		break;
> >
> > +	case FS_IOC_FWFREEZE:
> > +		error = ioctl_filefreeze(filp);
> > +		break;
> > +
> > +	case FS_IOC_FWTHAW:
> > +		error = ioctl_filethaw(filp);
> > +		break;
> > +
> >  	case FS_IOC_FIEMAP:
> >  		return ioctl_fiemap(filp, arg);
> >
> > diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> > index 3a03e0a..5110d9d 100644
> > --- a/fs/nilfs2/file.c
> > +++ b/fs/nilfs2/file.c
> > @@ -66,6 +66,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
> >  		return VM_FAULT_SIGBUS; /* -ENOSPC */
> >
> > +	inode_start_write(file_inode(vma->vm_file));
> >  	sb_start_pagefault(inode->i_sb);
> >  	lock_page(page);
> >  	if (page->mapping != inode->i_mapping ||
> > diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> > index 10d66c7..d073fc2 100644
> > --- a/fs/ocfs2/mmap.c
> > +++ b/fs/ocfs2/mmap.c
> > @@ -136,6 +136,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	sigset_t oldset;
> >  	int ret;
> >
> > +	inode_start_write(inode);
> >  	sb_start_pagefault(inode->i_sb);
> >  	ocfs2_block_signals(&oldset);
> >
> > diff --git a/fs/super.c b/fs/super.c
> > index eae088f..5e44e42 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -1393,3 +1393,54 @@ out:
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(thaw_super);
> > +
> IMHO it is reasonable to open code this procedure so user is responsible
> for calling  freeze_super(), thaw_super() . This allow to call for
> several inodes in a row like follows:
> 
> ioctl(sb,FIFREEZE)
> while (f = pop(files_list))
>   ioctl(f,FS_IOC_FWFREEZE)
> ioctl(sb,FITHAW)
> 
> This required for directory defragmentation(small files compacting)
Good point, I will check your point on V2.

Thanks!
> 

