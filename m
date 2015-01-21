Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbbAUAPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:15:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:16513 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbbAUAPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:15:11 -0500
X-AuditID: cbfee68f-f791c6d000004834-d8-54beef8d56e7
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
 <20150118233334.GB16552@dastard> <005601d033e8$d0b338a0$7219a9e0$@samsung.com>
 <20150120112137.GC15756@quack.suse.cz>
In-reply-to: <20150120112137.GC15756@quack.suse.cz>
Subject: RE: [RFC PATCH] fs: file freeze support
Date: Wed, 21 Jan 2015 09:15:08 +0900
Message-id: <000001d0350f$50d56bd0$f2804370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIaHX/tiVElMfpe/JaCs3xh3Ky4MgJ33GV2AU+SqUkBqm5kx5wKU4BQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsWyRsSkWLf3/b4Qg/9dEhZLJ15itnj3ucpi
	y7F7jBYnZnpazJ7ezGSx7MFmFos9e0+yWFzeNYfNorXnJ7vF+b/HWR24PE4tkvBoOnOU2WPS
	4c9MHu/3XWXz6NuyitHjzIIj7B6fN8l5bHrylimAI4rLJiU1J7MstUjfLoErY+6DBYwFL6Qq
	Hj42amCcK9rFyMkhIWAiMaHxPiOELSZx4d56ti5GLg4hgaWMEhN+PGWHKVr4ZgFUYhGjxMXt
	M9khnL+MEp03r7J2MXJwsAloS/zZIgpiigjISpw+WQZSwizwkUmicfN5Zoj6zYwSM/6eAFvH
	KWAssW/zYbANwgIGEkd6zoPZLAKqEhPX7WUCsXkFLCWmvjrHDmELSvyYfI8FZAGzgI7E10kR
	IGFmAXmJzWveMkMcqiCx4+xrsPEiAm4SV9snMELUiEjse/GOEeQGCYGZHBLL5h5ghdglIPFt
	8iGwmRJAR286ADVHUuLgihssExglZiHZPAth8ywkm2ch2bCAkWUVo2hqQXJBcVJ6kbFecWJu
	cWleul5yfu4mRmDEn/73rH8H490D1ocYBTgYlXh4X6zaGyLEmlhWXJl7iNEU6KCJzFKiyfnA
	tJJXEm9obGZkYWpiamxkbmmmJM67UOpnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGs6Wy
	Z87fn/ioqWPdrimTZbTOv7q+/KDZj73z3z8Qf/dC+056ksE6Tb5/6SzGL6eLKyVbXtFauOLh
	6hu8E2Z6Hpcymbboqm9TUNhCCbOtERtWNW7U4TNtcClc1nD88JorHyzv/ed8xvjl+ZGrPzPO
	RU2uPeO3fkcJ+3UHqzdq/XNZhMy+Bx1KrVRiKc5INNRiLipOBABjLmGY8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd3e9/tCDO6uF7BYOvESs8W7z1UW
	W47dY7Q4MdPTYvb0ZiaLZQ82s1js2XuSxeLyrjlsFq09P9ktzv89zurA5XFqkYRH05mjzB6T
	Dn9m8ni/7yqbR9+WVYweZxYcYff4vEnOY9OTt0wBHFENjDYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCcqKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM
	0PUNCYLrMTJAAwlrGDPmPljAWPBCquLhY6MGxrmiXYycHBICJhIL3yxgg7DFJC7cWw9kc3EI
	CSxilLi4fSY7hPOXUaLz5lXWLkYODjYBbYk/W0RBTBEBWYnTJ8tASpgFPjJJNG4+zwxRv5lR
	YsbfE4wgUzkFjCX2bT7MDmILCxhIHOk5D2azCKhKTFy3lwnE5hWwlJj66hw7hC0o8WPyPRaQ
	BcwCOhJfJ0WAhJkF5CU2r3nLDHGogsSOs6/BxosIuElcbZ/ACFEjIrHvxTvGCYxCs5BMmoUw
	aRaSSbOQdCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxOnknvYFzVYHGIUYCDUYmH
	12Ht3hAh1sSy4srcQ4wSHMxKIry6h/eFCPGmJFZWpRblxxeV5qQWH2I0BfpzIrOUaHI+MNXl
	lcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphakFsH0MXFwSjUw1m8JsJ0ZeSrXftHh
	6XMWTWfnWpTN+JD7p/KybZ7asj0WgeXxF3RVn/N/YJjCJN+2ft65xk1XPPV2i52+9GRr34So
	izNtBe86nq2a8Kn96IFbyUt3bjA81XX7C9OE2Xx7vy37+3Ge+5GzCy06dhgsFjgm4L83L7ow
	QmHz0S1C6l+emLn35X93clNiKc5INNRiLipOBADNwK2FPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon 19-01-15 22:07:01, Namjae Jeon wrote:
> > > > When this state is set, any process which tries to modify the file's address
> > > > space, either by pagefault mmap writes or using write(2), will block until
> > > > the this state is cleared. I_WRITE_FREEZED is set by calling FS_IOC_FWFREEZE
> > > > ioctl and clear by FS_IOC_FWTHAW ioctl.
> > > >
> > > > File write freeze functionality, when used in conjunction with
> > > > inode's immutable flag can be used for creating truly stable file snapshots
> > > > wherein write freeze will prevent any modification to the file from already
> > > > open file descriptors and immutable flag will prevent any new modification
> > > > to the file. One of the intended uses for stable file snapshots would be in
> > > > the defragmentation applications which defrags single file.
> > >
> > > I don't quite understand why the full filesystem freeze is
> > > necessary? The thaw occurs immediately after I_WRITE_FREEZED is set,
> > We started by looking at fs freeze for file freeze implementation,
> > So got biased for using fs freeze or similar approach.
> > Thanks for suggesting a better way.
> >
> > > which means there's nothing that prevent the file from being
> > > truncated or otherwise modified by fallocate, etc while it is
> > > frozen....
> > Right, So, After that, we had also thought of setting immutable
> > flag of inode. Immutable flag + I_WRITE_FROZEN => truly frozen file.
> >
> > >
> > > AFAICT, fsync will bring the file down to a consistent state and
> > > we've already got freeze hooks for all inode modification
> > > operations. We also have IO barriers for truncate operations so that
> > > we can wait for all outstanding IO to complete, so I would have
> > > thought this covers all bases for an inode freeze. i.e.:
> > Right.
> >
> > >
> > > i_mutex -> I_FROZEN -> fsync -> inode_dio_wait
> > >
> > > Should give us a clean inode where there are not ongoing operations
> > > by the time that inode_dio_wait() completes. All new modification
> > > operations need to check I_FROZEN in addition to the superblock
> > > freeze checks...
> > I checked the routines where checks for I_FROZEN would be required.
> > Most of them are Ok but do_unlinkat() confuses me a little.
> > vfs_unlink is called under parent inode's i_mutex, so we cannot sleep
> > keeping parent's i_mutex held.
> > i.e while freezing file, all file in directory are blocked by parent
> > i_mutex. Is it ok to release parnets->mutex before checking for I_FROZEN
> > or there is some idea?
>   So I believe Dave thought that you'd just reuse places we currently use
> to call sb_start_write() / mnt_want_write(). You'd probably have to come up
> with a function like path_want_write() (takes struct path as an argument)
> and which will call mnt_want_write(), sb_start_write(), and do appropriate
> inode freeze handling. Then you replace all calls to mnt_want_write() with
> calls to path_want_write()... Possibly you can also provide a trivial
> wrapper for path_want_write() which takes struct file instead.
Okay, I will rework as your suggestion.
> 
> This should also deal with the locking problems you describe above as
> mnt_want_write() is always called before taking i_mutex.
Right. will check. I will back with V2 patch.

Thanks for review!
> 
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

