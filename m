Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbbASMeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:34:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11935 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbASMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:34:09 -0500
X-AuditID: cbfee691-f79b86d000004a5a-e3-54bcf9bef7c6
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
 <003f01d03158$60c9def0$225d9cd0$@samsung.com>
 <20150116105712.GF25884@quack.suse.cz>
In-reply-to: <20150116105712.GF25884@quack.suse.cz>
Subject: RE: [RFC PATCH] fs: file freeze support
Date: Mon, 19 Jan 2015 21:34:06 +0900
Message-id: <005501d033e4$37149440$a53dbcc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIaHX/tiVElMfpe/JaCs3xh3Ky4MgGd5BIAAURlWrACbfHER5wJCznA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkWHffzz0hBo83ClgsnXiJ2eLd5yqL
	LcfuMVqcmOlpMXt6M5PFsgebWSz27D3JYnF51xw2i9aen+wW5/8eZ3Xg8ji1SMKj6cxRZo9J
	hz8zebzfd5XNo2/LKkaPMwuOsHt83iTnsenJW6YAjigum5TUnMyy1CJ9uwSujHm75jIWLFGq
	+LjnJ0sD41qpLkZODgkBE4mPxx+yQ9hiEhfurWfrYuTiEBJYyihxa/YHVpiitQ+2MkMkpjNK
	fGibAFX1l1Fi4v8lQFUcHGwC2hJ/toiCmCICshKnT5aBlDALfGSSaNx8Hqp5N6PEpcsPGUGm
	cgoYSzTOvM4EYgsLGEgc6TkPdgaLgKrE1AsTwGp4BSwlun7fgLIFJX5MvscCsoBZQEfi66QI
	kDCzgLzE5jVvmSEOVZDYcfY1WLmIgJtE679WJogaEYl9L94xgtwgITCVQ+LDoblMELsEJL5N
	PgQ2UwLo6E0HoOZIShxccYNlAqPELCSbZyFsnoVk8ywkGxYwsqxiFE0tSC4oTkovMtUrTswt
	Ls1L10vOz93ECIz50/+eTdzBeP+A9SFGAQ5GJR7ejb57QoRYE8uKK3MPMZoCHTSRWUo0OR+Y
	WPJK4g2NzYwsTE1MjY3MLc2UxHl1pH8GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA0mqDz
	wzv4fdbMjPhDoYevZr5hkWKZ5csdqN3kERQR5SXBHfD2zAWvmUFcJ9YLWyc82rdybfAcESHp
	kPoXYrYcp9PXr45YPEXWU77w52SlmtUCjpxHFcMn8HdvWW+ZG3D6HZ9IWL4q46RTtfwvNZ7t
	bb65ffIMD1eZg1dbl9426RBWPn48LFuJpTgj0VCLuag4EQBTI5Su9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd19P/eEGFxazGGxdOIlZot3n6ss
	thy7x2hxYqanxezpzUwWyx5sZrHYs/cki8XlXXPYLFp7frJbnP97nNWBy+PUIgmPpjNHmT0m
	Hf7M5PF+31U2j74tqxg9ziw4wu7xeZOcx6Ynb5kCOKIaGG0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgE5UUihLzCkFCgUkFhcr6dthmhAa4qZrAdMY
	oesbEgTXY2SABhLWMGbM2zWXsWCJUsXHPT9ZGhjXSnUxcnJICJhIrH2wlRnCFpO4cG89Wxcj
	F4eQwHRGiQ9tE6Ccv4wSE/8vYe1i5OBgE9CW+LNFFMQUEZCVOH2yDKSEWeAjk0Tj5vPMEPW7
	GSUuXX7ICDKVU8BYonHmdSYQW1jAQOJIz3l2EJtFQFVi6oUJYDW8ApYSXb9vQNmCEj8m32MB
	WcAsoCPxdVIESJhZQF5i85q3UIcqSOw4+xqsXETATaL1XysTRI2IxL4X7xgnMArNQjJpFsKk
	WUgmzULSsYCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEJ5Jr2DcVWDxSFGAQ5GJR7e
	Db57QoRYE8uKK3MPMUpwMCuJ8AZ8AQrxpiRWVqUW5ccXleakFh9iNAX6cyKzlGhyPjDZ5ZXE
	GxqbmBlZGpkbWhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1MNpe/Cx+/u9kjz1HZvZM
	mjuzeH/lqz+Hwxclu9fYt76f2GJzc09Yptl9D/PHEyaaKnF82TCr+HD4qrvzHJh7+Wdbty0r
	3PT/I892MVeTfRopjX4lAqt2iqfVfXztWMLR/2jK6bXGP75MOny0JfvunJr35+acNZi+4Vjk
	G0P+gHvvI+V4Pk2JPzBNiaU4I9FQi7moOBEArB6Dvj4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Hello,
Hi Jan.
> 
> On Fri 16-01-15 15:48:04, Namjae Jeon wrote:
> > > > +int file_write_unfreeze(struct inode *inode)
> > > > +{
> > > > +	struct super_block *sb = inode->i_sb;
> > > > +
> > > > +	if (!S_ISREG(inode->i_mode))
> > > > +		return -EINVAL;
> > > > +
> > > > +	spin_lock(&inode->i_lock);
> > > > +
> > > > +	if (!(inode->i_state & I_WRITE_FREEZED)) {
> > > > +		spin_unlock(&inode->i_lock);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	inode->i_state &= ~I_WRITE_FREEZED;
> > > > +	smp_wmb();
> > > > +	wake_up(&sb->s_writers.wait_unfrozen);
> > > > +	spin_unlock(&inode->i_lock);
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL(file_write_unfreeze);
> > >   So I was looking at the implementation and I have a few comments:
> > > 1) The trick with freezing superblock looks nice but I'm somewhat worried
> > > that if we wanted to heavily use per-inode freezing to defrag the whole
> > > filesystem it may be too slow to freeze the whole fs, mark one inode as
> > > frozen and then unfreeze the fs. But I guess we'll see that once have some
> > > reasonably working implementation.
> > Dmitry has given a good idea to avoid multiple freeze fs and unfreeze fs
> > calls.
> >
> > ioctl(sb,FIFREEZE)
> > while (f = pop(files_list))
> >   ioctl(f,FS_IOC_FWFREEZE)
> > ioctl(sb,FITHAW)
> >
> > In file_write_freeze, we could first check if the fs is already frozen,
> > if yes than we can directly set inode write freeze state after taking
> > relevant lock to prevent fs_thaw while the inode state is being set.
>   Well, doing fs-wide freezing from userspace makes sense as Dmitry pointed
> out. We can then just fail FS_IOC_FWFREEZE with error when the whole fs isn't
> frozen. I'm just somewhat worried whether the fs-wide freezing won't be too
> fragile. E.g. consider a situation when you are running a defrag program
> which is freezing and unfreezing the filesystem and then some background
> work kicks which will want to snapshot the filesystem so it will freeze &
> unfreeze the fs as well. Now depending on how exactly defrag and snapshot
> race one of the FIFREEZE ioctls will return EBUSY and the process
> (hopefully gracefully) fails.
> 
> This isn't a new situation - if you ran two snapshots at once, you'd see
> the same failure. But the more fs-wide freezing gets used in different
> places the stranger and less expected failure you'll see...
Yes, Right. Thanks for your opinion. I will consider your point.

> 
> > > 2) The tests you are currently doing are racy. If
> > > things happen as:
> > >   CPU1					CPU2
> > > inode_start_write()
> > > 					file_write_freeze()
> > > sb_start_pagefault()
> > > Do modifications.
> > >
> > > Then you have a CPU modifying a file while file_write_freeze() has
> > > succeeded so it should be frozen.
> > >
> > > If you swap inode_start_write() with sb_start_pagefault() the above race
> > > doesn't happen but userspace program has to be really careful not to hit a
> > > deadlock. E.g. if you tried to freeze two inodes the following could happen:
> > >   CPU1					CPU2
> > > 					file_write_freeze(inode1)
> > > fault on inode1:
> > > sb_start_pagefault()
> > > inode_start_write() -> blocks
> > > 					file_write_freeze(inode2)
> > > 					  blocks in freeze_super()
> > >
> > > So I don't think this is a good scheme for inode freezing...
> > To solve this race, we can fold inode_start_write with sb_start_write and use
> > similar appraoch of __sb_start_write.
> > How about the below scheme ?
> >
> > void inode_start_write(struct inode *inode)
> > {
> > 	struct super_block *sb = inode->i_sb;
> >
> > retry:
> >
> > 	if (unlikely(inode->i_state & I_WRITE_FREEZED)) {
> > 		DEFINE_WAIT(wait);
> >
> > 		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
> > 			TASK_UNINTERRUPTIBLE);
> > 		schedule();
> > 		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
> >
> > 		goto retry;
> > 	}
> >
> > 	sb_start_write(sb);
> >
> > 	/* check if file_write_freeze race with us */
> > 	if (unlikely(inode->i_state & I_WRITE_FREEZED) {
> > 		sb_end_write(sb);
> > 		goto retry;
> > 	}
> > }
>   Yes, this should work. You'll need a similar wrapper for page faults but
> that's easy enough.
Okay, Thanks :)
> 
> 								Honza
> 
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

