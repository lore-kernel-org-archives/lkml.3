Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbbAPGsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:48:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28211 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbAPGsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:48:07 -0500
X-AuditID: cbfee68d-f79296d000004278-e2-54b8b4243a7e
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Jan Kara'" <jack@suse.cz>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Dmitry Monakhov'" <dmonakhov@openvz.org>,
        "=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?=" <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
 <20150115161743.GH12739@quack.suse.cz>
In-reply-to: <20150115161743.GH12739@quack.suse.cz>
Subject: RE: [RFC PATCH] fs: file freeze support
Date: Fri, 16 Jan 2015 15:48:04 +0900
Message-id: <003f01d03158$60c9def0$225d9cd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIaHX/tiVElMfpe/JaCs3xh3Ky4MgGd5BIAnCF3oPA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsWyRsSkUFd1y44Qg+VTWS2WTrzEbPHuc5XF
	lmP3GC1OzPS0mD29mcli2YPNLBZ79p5ksbi8aw6bRWvPT3aL83+PszpweZxaJOHRdOYos8ek
	w5+ZPN7vu8rm0bdlFaPHmQVH2D0+b5Lz2PTkLVMARxSXTUpqTmZZapG+XQJXxsk9ixkLlohX
	fJz8n62BcZ5QFyMnh4SAicTl9h+MELaYxIV769m6GLk4hASWMkosPnqeFabo0NsHzBCJRYwS
	K+5vYgFJCAn8ZZSYcq6mi5GDg01AW+LPFlEQU0RAVuL0yTKQcmaBj0wSjZvPM0OUJ0m8XLSJ
	CcTmFDCWePbmBxuILSxgIHGk5zw7iM0ioCrxdscfsIN4BSwl+t88ZIGwBSV+TL7HAjKfWUBH
	4uukCJAws4C8xOY1b5khzlSQ2HH2NViriICVRPPU2WwQNSIS+168YwS5R0JgJofEvhVHmSF2
	CUh8m3wIbKYE0M2bDkDNkZQ4uOIGywRGiVlINs9C2DwLyeZZSDYsYGRZxSiaWpBcUJyUXmSo
	V5yYW1yal66XnJ+7iREY76f/PevdwXj7gPUhRgEORiUeXodNO0KEWBPLiitzDzGaAh00kVlK
	NDkfmFTySuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpg
	PFKnoHz5mVs9X6+e3q450+Tv/eZf/P6EaXDSn8fa/q08k3bMDonSPB3y+UbSl+ZFj2cYqOQb
	LpfznLm5cufLpsu3/RMOzdJJ6tZYWiTz/ZL1/MMK+y/4n/ZaPeXnC0Fh24faPu+VP8z6+vy3
	gh+vXhnTpBffd9ak+6w7I74gcD6DzGVv41VLxJRYijMSDbWYi4oTAdhzqfjyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV2VLTtCDDYctbRYOvESs8W7z1UW
	W47dY7Q4MdPTYvb0ZiaLZQ82s1js2XuSxeLyrjlsFq09P9ktzv89zurA5XFqkYRH05mjzB6T
	Dn9m8ni/7yqbR9+WVYweZxYcYff4vEnOY9OTt0wBHFENjDYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCcqKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM
	0PUNCYLrMTJAAwlrGDNO7lnMWLBEvOLj5P9sDYzzhLoYOTkkBEwkDr19wAxhi0lcuLeerYuR
	i0NIYBGjxIr7m1hAEkICfxklppyr6WLk4GAT0Jb4s0UUxBQRkJU4fbIMpJxZ4COTROPm88wQ
	5UkSLxdtYgKxOQWMJZ69+cEGYgsLGEgc6TnPDmKzCKhKvN3xhxHE5hWwlOh/85AFwhaU+DH5
	HgvIfGYBHYmvkyJAwswC8hKb17yFOlNBYsfZ12CtIgJWEs1TZ7NB1IhI7HvxjnECo9AsJJNm
	IUyahWTSLCQdCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ5Nn0jsYVzVYHGIU4GBU
	4uFl8NseIsSaWFZcmXuIUYKDWUmEt7F7R4gQb0piZVVqUX58UWlOavEhRlOgPycyS4km5wMT
	XV5JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dUA6Nphm92X17fzv/7
	hM+syJIyeNr1x+DNBn/LiKkXHEOcJtyY6GOxZYFwhhmvDXt+7VaB5xXrBR8Zc1kF68Uc9p29
	dUqulOQHt5oy9SXWTV9c52lWzXdL2qcW8L2b5elkp/afilMkN5sF7f48/YDGs7vl+Up3VoSd
	8JhZ1Pf6RVFC+aZ1p7ZJH1diKc5INNRiLipOBAB68js9PAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>   Hello,
Hi Jan,
> 

> > +
> > +int file_write_unfreeze(struct inode *inode)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +
> > +	if (!S_ISREG(inode->i_mode))
> > +		return -EINVAL;
> > +
> > +	spin_lock(&inode->i_lock);
> > +
> > +	if (!(inode->i_state & I_WRITE_FREEZED)) {
> > +		spin_unlock(&inode->i_lock);
> > +		return -EINVAL;
> > +	}
> > +
> > +	inode->i_state &= ~I_WRITE_FREEZED;
> > +	smp_wmb();
> > +	wake_up(&sb->s_writers.wait_unfrozen);
> > +	spin_unlock(&inode->i_lock);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(file_write_unfreeze);
>   So I was looking at the implementation and I have a few comments:
> 1) The trick with freezing superblock looks nice but I'm somewhat worried
> that if we wanted to heavily use per-inode freezing to defrag the whole
> filesystem it may be too slow to freeze the whole fs, mark one inode as
> frozen and then unfreeze the fs. But I guess we'll see that once have some
> reasonably working implementation.
Dmitry has given a good idea to avoid multiple freeze fs and unfreeze fs
calls.

ioctl(sb,FIFREEZE)
while (f = pop(files_list))
  ioctl(f,FS_IOC_FWFREEZE)
ioctl(sb,FITHAW)

In file_write_freeze, we could first check if the fs is already frozen,
if yes than we can directly set inode write freeze state after taking
relevant lock to prevent fs_thaw while the inode state is being set.

> 
> 2) The tests you are currently doing are racy. If
> things happen as:
>   CPU1					CPU2
> inode_start_write()
> 					file_write_freeze()
> sb_start_pagefault()
> Do modifications.
> 
> Then you have a CPU modifying a file while file_write_freeze() has
> succeeded so it should be frozen.
> 
> If you swap inode_start_write() with sb_start_pagefault() the above race
> doesn't happen but userspace program has to be really careful not to hit a
> deadlock. E.g. if you tried to freeze two inodes the following could happen:
>   CPU1					CPU2
> 					file_write_freeze(inode1)
> fault on inode1:
> sb_start_pagefault()
> inode_start_write() -> blocks
> 					file_write_freeze(inode2)
> 					  blocks in freeze_super()
> 
> So I don't think this is a good scheme for inode freezing...
To solve this race, we can fold inode_start_write with sb_start_write and use
similar appraoch of __sb_start_write.
How about the below scheme ?

void inode_start_write(struct inode *inode)
{
	struct super_block *sb = inode->i_sb;

retry:

	if (unlikely(inode->i_state & I_WRITE_FREEZED)) {
		DEFINE_WAIT(wait);

		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
			TASK_UNINTERRUPTIBLE);
		schedule();
		finish_wait(&sb->s_writers.wait_unfrozen, &wait);

		goto retry;
	}

	sb_start_write(sb);

	/* check if file_write_freeze race with us */
	if (unlikely(inode->i_state & I_WRITE_FREEZED) {
		sb_end_write(sb);
		goto retry;
	}
}

Thanks for your review!
> 
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

