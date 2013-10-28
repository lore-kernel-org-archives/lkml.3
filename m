Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3J1Mpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:45:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53606 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3J1Mpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:45:33 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f3d6d000001c4a-83-526e5c6cbd87
Content-transfer-encoding: 8BIT
Message-id: <1382964295.992.122.camel@kjgkr>
Subject: Re: [f2fs-dev 5/5] f2fs: Handle inline data operations
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Mon, 28 Oct 2013 21:44:55 +0900
In-reply-to: <1382716919-23345-6-git-send-email-huajun.li.lee@gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
 <1382716919-23345-6-git-send-email-huajun.li.lee@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zA92cmLwgg9V7WSxeHtK0OPOsg9Fi
	y5YYi6/9d9gsLi1yt9iz9ySLxeVdc9gsNp38xerA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mp4N+Mjc8F59or+y5fYGxjvs3YxcnJICJhItK3oZ4Sw
	xSQu3FvP1sXIxSEksIxRovvLGxaYogVH37JAJBYxSrw4+Y4ZJMErICjxY/I9oAQHB7OAvMSR
	S9kgYWYBdYlJ8xYxQ9S/YpR4uXgbI0S9jsSxh6/YQWxhAXuJ5smv2UF62QS0JTbvNwAJCwko
	SrzdfxfsOBGgOa9fzGUFmcMscItR4mHrEbCDWARUJTZfXAR2A6eAh8SDD4+glrUySqz+sQ5s
	Gb+AqMThhduZIT5Qktjd3skOYf9kl5hylw9ikIDEt8mHwB6QEJCV2HQAqlxS4uCKGywTGCVm
	IXlzFsKbs5C8uYCReRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSMRO2MF474D1IcZkoI0T
	maVEk/OBEZ9XEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYz9+q3Bpt0unW+XLzVu8gj+5i/T79B/TSMih08+ufepxvNv/6TvX45u6T0clxngozwl
	SCpyRvYH/8WzJj1Yzy9yqnWdGLfKsrdhgmx2VeaWHrPvVWyLuR/s2xWQvbVLqIRT5Ezu+rc2
	Jp9/rHT8d+2v0fqIHS+9AlMsPR5avssOOWHWKfBkixJLcUaioRZzUXEiAPF8NZfuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd3smLwgg4NfbCxeHtK0OPOsg9Fi
	y5YYi6/9d9gsLi1yt9iz9ySLxeVdc9gsNp38xerA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAG6RkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8W7GR+aC8+wV
	/ZcvsTcw3mftYuTkkBAwkVhw9C0LhC0mceHeerYuRi4OIYFFjBIvTr5jBknwCghK/Jh8D6iI
	g4NZQF7iyKVskDCzgLrEpHmLmCHqXzFKvFy8jRGiXkfi2MNX7CC2sIC9RPPk1+wgvWwC2hKb
	9xuAhIUEFCXe7r8LdoMI0JzXL+aygsxhFrjFKPGw9QjYQSwCqhKbLy4Cu4FTwEPiwYdHUMta
	GSVW/1gHtoxfQFTi8MLtzBAfKEnsbu9kn8AoNAvJ3bMQ7p6F5O4FjMyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYITwjOpHYwrGywOMQpwMCrx8G5YmxskxJpYVlyZe4hRgoNZSYTXwz4v
	SIg3JbGyKrUoP76oNCe1+BBjMtDlE5mlRJPzgckqryTe0NjEzMjSyMzCyMTcnDRhJXHeA63W
	gUIC6YklqdmpqQWpRTBbmDg4pRoYT2Srum8ufF7X+mZ+rthl9y3uq02nNv3mashr5ExV+T93
	re0EgZ0l5jPNP+1m1rLZUyPs7sF1ueJ8dMOmVf6h9/bdsjNJmHqkYC/r3ZfnDpWunTXnT7ng
	gQOiW083i/9+fnTlxyrxaNd9vqlbRJZ153JNiDw1OfebBceyoKCoBSYT19w2WvY4UImlOCPR
	UIu5qDgRAA9dILZMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-26 (토), 00:01 +0800, Huajun Li:
> From: Huajun Li <huajun.li@intel.com>
> 

[snip]

>  
> @@ -538,7 +553,7 @@ static int f2fs_write_data_page(struct page *page,
>  	loff_t i_size = i_size_read(inode);
>  	const pgoff_t end_index = ((unsigned long long) i_size)
>  							>> PAGE_CACHE_SHIFT;
> -	unsigned offset;
> +	unsigned offset = 0;
>  	bool need_balance_fs = false;
>  	int err = 0;
>  
> @@ -572,7 +587,14 @@ write:
>  		err = do_write_data_page(page);
>  	} else {
>  		f2fs_lock_op(sbi);
> -		err = do_write_data_page(page);
> +		if (test_opt(sbi, INLINE_DATA) && (i_size <= MAX_INLINE_DATA)) {
> +			err = f2fs_write_inline_data(inode, page, offset);
> +			ClearPageDirty(page);

Don't need to call ClearPageDirty(page).

> +			f2fs_unlock_op(sbi);
> +			goto out;
> +		} else {
> +			err = do_write_data_page(page);
> +		}
>  		f2fs_unlock_op(sbi);
>  		need_balance_fs = true;
>  	
-- 
Jaegeuk Kim
Samsung

