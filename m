Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaHYGwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:52:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18456 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaHYGwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:52:37 -0400
X-AuditID: cbfee690-f79ce6d00000115a-27-53fadd2a22c4
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org,
        "=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?=" <lczerner@redhat.com>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>
References: <004301cfb2c6$6ef2d330$4cd87990$@samsung.com>
 <20140822120659.GF3152@laptop.bfoster>
In-reply-to: <20140822120659.GF3152@laptop.bfoster>
Subject: RE: [PATCH v5 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Mon, 25 Aug 2014 15:52:26 +0900
Message-id: <001901cfc031$2140a950$63c1fbf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH4GbaBpWRVdUyOkzDMM+qmsuCaGAJIM1vgm33n5UA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkWFfr7q9gg7arkhbvPldZbDl2j9Fi
	2YPNLBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKpvH
	501yAaxRXDYpqTmZZalF+nYJXBkLuvezFdzkr/iw16uBcRdPFyMnh4SAicSHJbuYIGwxiQv3
	1rN1MXJxCAksZZRYe34vK0zRrv8rmCES0xkldq86xwjh/GWU6PpzBSjDwcEmoC3xZ4soSIOI
	gLrEnXkTWEBqmAVamCRWHF7FDpIQEkiSuLbmL9g6TgFjibZLD8A2CAuESJxuWMMGYrMIqEq8
	6tgPVs8rYCnx+MZsKFtQ4sfkeywgu5gFdCS+TooACTMLyEtsXvOWGeJQBYkdZ18zQtxgJdHQ
	+5IdokZEYt+Ld2A3Swh8ZJe4/G8KI8QuAYlvkw+BzZQQkJXYdABqjqTEwRU3WCYwSsxCsnkW
	wuZZSDbPQrJhASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYzACD7979mEHYz3DlgfYhTg
	YFTi4V3B+StYiDWxrLgy9xCjKdBBE5mlRJPzgWkiryTe0NjMyMLUxNTYyNzSTEmc97XUz2Ah
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNNyzzPMvrDhxU4xzWf7PfOWrDV/NEfI4NTOSzdD
	u9hjFqdUav1g4VFgLilt9xFZ+LpwDlO8A8d0HtUbi1TLBJeYdmwwnxB3MPnOUkbWCOb5fg5B
	7iwH3v9eP6vG69arhYX3t108VKs2Z6LMxYhepwPFArMkFL4VBfKVu092uOVw4MukxLbARUos
	xRmJhlrMRcWJAN+c9sXbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQV2tu7+CDX4eE7R497nKYsuxe4wW
	yx5sZrGYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsaB7P1vBTf6KD3u9
	Ghh38XQxcnJICJhI7Pq/ghnCFpO4cG89WxcjF4eQwHRGid2rzjFCOH8ZJbr+XAGq4uBgE9CW
	+LNFFKRBREBd4s68CSwgNcwCLUwSKw6vYgdJCAkkSVxb85cJxOYUMJZou/SAFcQWFgiRON2w
	hg3EZhFQlXjVsR+snlfAUuLxjdlQtqDEj8n3WEB2MQvoSHydFAESZhaQl9i85i3UoQoSO86+
	ZoS4wUqiofclO0SNiMS+F+8YJzAKzUIyaRbCpFlIJs1C0rGAkWUVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnB6eCa9g3FVg8UhRgEORiUe3pWcv4KFWBPLiitzDzFKcDArifBOOQ4U4k1J
	rKxKLcqPLyrNSS0+xGgK9OdEZinR5Hxg6soriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliS
	mp2aWpBaBNPHxMEp1cCob8O0IOjYggj5m92dTH+/bSrqZv5r7KL6SEWiYOP2yQJv4rftXLEh
	nW/pGV+vc87OYT1W0ypPS1/QzTk9tXLb3L+cB94UX97lN+P4BhvL0z+Fdom8S6zgyk5c/sNT
	f6bw+huqk5PPbxdW6Hlrcvjz0S+3fhrGWnzbwqPAVPDG2Lzqu1LIaw4vJZbijERDLeai4kQA
	t28YjiUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Namjae,
Hi Brian.

Thanks for your mail :)
> 
> Sorry for finding things so late, but it looks like this suffers from
> the same couple bugs we've recently discovered with the collapse range
> patches. See the following for a couple fixes that have been proposed
> recently:
> 
> http://oss.sgi.com/archives/xfs/2014-08/msg00292.html
> 
> This one helps prevent scenarios where we try to cancel a transaction
> that is dirty. This leads to a shutdown on XFS. The idea is basically to
> avoid logging until we actually make a change, so errors hit early in
> the function (before we change anything) won't lead to an abort in the
> error path. It looks like the bmap split and shift functions in this
> patch could use the very same attention.
Okay, I will add this commit to insert range patch.

> 
> http://oss.sgi.com/archives/xfs/2014-08/index.html
> 
> This one deals with a problem with the high level shift algorithm. The
> problem with the algorithm here is that 'current_ext' can change
> unexpectedly once we release the ilock due to writeback on parts of the
> file before the range being collapsed/inserted. E.g., it is not a stable
> index once ilock is dropped. The temporary solution is to flush the
> entire file, since we have the iolock during the entire operation and
> nothing else can dirty the file. The better fix is to track via an
> offset across iterations of the shift, rather than the extent count
> (iirc, xfs_bunmapi() and other bmap functions provide examples of this
> kind of algorithm).
Okay, I will check your points.

> 
> Brian
> 
> P.S., It's probably a good idea to remove my r-b tag on the next post as
> well to avoid confusion and remind me that I need to take another look
> at this. ;) Thanks again.
Okay, I will remove it.

Thanks Brian!
> 

> > --
> > 1.7.11-rc0
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

