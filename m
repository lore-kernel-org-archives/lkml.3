Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaIXHxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:53:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34612 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIXHxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:53:52 -0400
X-AuditID: cbfee68e-f79b46d000002b74-e1-5422788d0294
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Dmitry Monakhov'" <dmonakhov@openvz.org>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Luk?? Czerner'" <lczerner@redhat.com>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>, xfs@oss.sgi.com
Subject: Unifying XFS_IOC_SWAPEXT and EXT4_IOC_MOV_EXT (was Re: [PATCH 2/3]
 xfs: Add support IOC_MOV_DATA ioctl)
Date: Wed, 24 Sep 2014 16:53:49 +0900
Message-id: <000001cfd7cc$ad447a00$07cd6e00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/Xy52Ab6BrJjpeQYusNfdax1wxOA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWyRsSkWLevQinE4OF1VoulEy8xW7z7XGWx
	5dg9RosTMz0tTk9YxGSx7MFmFouZ8+6wWezZe5LF4vKuOWwWrT0/2S0W9d1idOD2OLVIwmPz
	Ci2PpjNHmT0mHf7M5LH6wlZGj/f7rrJ59G1ZxejxeZNcAEcUl01Kak5mWWqRvl0CV8bqHwuY
	C2bxVNxentrA+ICzi5GTQ0LAROLKo4lsELaYxIV764FsLg4hgaWMEvPWfGODKZo3dx8TiC0k
	MJ1RYmsfI0TRX0aJ5Vu3M3cxcnCwCWhL/NkiChIXEZjOLLHgyDFmkAZhgSKJc/9WMILYLAKq
	Es8PrwMbyitgKbGqcy0jhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khjlCQ2HH2NVi9iICe
	RP+v7VD1IhL7XrwDO0hC4CO7xNm9n6CWCUh8m3yIBeQ4CQFZiU0HoOZIShxccYNlAqPoLCSr
	ZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERizp/8969vBePOA9SFG
	AQ5GJR7eCeJKIUKsiWXFlbmHGE2BLprILCWanA9MDHkl8YbGZkYWpiamxkbmlmZK4rwJUj+D
	hQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDW+LnkBf/Yrn9P+YeDbqBNVvK5h64/q+5Xtwc4
	r52zfOljyWshLzR+CEieE7OqU227qnvEd9n7F3avuVlVmx9PFOs+O/PmZfX7ywrelRvO777L
	+1ls1t8paTOWdQZKpv3415J5/rrkhpNPmCJ/Zwv0aC7UnD/18mn5wqSIr1n/Lzz35M1VZ4hS
	YinOSDTUYi4qTgQA2y5nVtQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoG5vhVKIwclDVhZLJ15itnj3ucpi
	y7F7jBYnZnpanJ6wiMli2YPNLBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDtcWqRhMfm
	FVoeTWeOMntMOvyZyWP1ha2MHu/3XWXz6NuyitHj8ya5AI6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAzlRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZq38sYC6YxVNxe3lqA+MDzi5GTg4JAROJeXP3MUHYYhIX7q1n
	A7GFBKYzSmztY+xi5AKy/zJKLN+6nbmLkYODTUBb4s8WUZC4iMB0ZokFR44xgzQICxRJnPu3
	ghHEZhFQlXh+eB3YIF4BS4lVnWsZIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMcYSCxI6z
	r8HqRQT0JPp/bYeqF5HY9+Id4wRG/llIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iRGcEJ5J7WBc2WBxiFGAg1GJh3eCuFKIEGtiWXFl7iFGCQ5mJRHeE6VAId6U
	xMqq1KL8+KLSnNTiQ4ymQJ9OZJYSTc4HJqu8knhDYxMzI0sjc0MLI2NzJXHeA63WgUIC6Ykl
	qdmpqQWpRTB9TBycUg2M8do+Mzs3ZFznzr8VJ14wwbjkUp+j3TY/zVwP45QX848rsegvmJeY
	eCUu9seOuF1neC+6ywca21Tum1RrGVczU4Wnt8zcfO+fHedFtp1W6dZeNMGqyGIb/7VH3bqT
	1n+b9fLzvdbaT2byW62eC1znWtneMWUrf7xrtUhzUcRdwVdMN56//PhbiaU4I9FQi7moOBEA
	2zUEWh4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> FWIW, what we ideally need for these sorts of defrag programs is
> per-file freezing. i.e. we freeze the file to be defragged, then do
> the copy in userspace, swap/move the copied range and then unfreeze
> it once complete.  That guarantees that the file is not modified in
> any way while userspace is doing the defrag...
I am trying to unify xfs_swap extent and ext4 move extent so that both of these 
could be called via new ioctl mov_data. Both ioctl have different interface
because  both xfs and ext4 have different way of avoiding change in source file
while defrag is running. XFS uses xfs_bstat_t while ext4 performs copying of
data within kernel space after taking mutex lock.
To make them use same approach, we should use something like file sealing as
suggessted by you.
First of all, I am trying to find proper way of sealing file as suggested by
you. I am considering to use S_IMMUTABLE flag set to avoid file modification
during defrag. I am thinking of first syncing  dirty pages, then truncating
page cache pages of inode and lastly setting immutable flag of inode.
This will block further attempts of modifying the file by opening new file
pointer but already open file pointer can still change it.
Although immutable file mean file can not be modified, there is no immutable
check condition in write path and mmap path.
I am wondering it is just missing to add immutable check condition or there
is other reason I am not aware.

Thanks!
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

