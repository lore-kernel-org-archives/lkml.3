Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaCRAfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:35:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29744 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaCRAfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:35:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-cf-532794bf7681
Content-transfer-encoding: 8BIT
Message-id: <1395102807.3870.156.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix incorrect parsing with option string
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Mar 2014 09:33:27 +0900
In-reply-to: <000301cf41c5$10f247b0$32d6d710$@samsung.com>
References: <000301cf41c5$10f247b0$32d6d710$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zQ939U9SDDfqvGFr8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgynhwo52t4CF7xbqn
	S5kbGBvZuhg5OSQETCT+nTrIDGGLSVy4tx4ozsUhJLCMUWLp4gbWLkYOsKLty2Ug4osYJfad
	mMUI0sArICjxY/I9FpAaZgF5iSOXskHCzALqEpPmLWKGqH/FKDFvzXRmiHpdiQ0TpzOB2MIC
	fhLLnt5lBOllE9CW2LzfACQsJKAo8Xb/XVYQW0RASeLX/EWsEDMzJe41zWAGKWcRUJXoX8YD
	EuYUsJKY9Wc1M0SrpcSniy3sIDa/gKjE4YXbod5Sktjd3skOco6EwDF2ia5n81hAEiwCAhLf
	Jh9igXhRVmLTAah6SYmDK26wTGCUmIXkyVkIT85C8uQCRuZVjKKpBckFxUnpRcZ6xYm5xaV5
	6XrJ+bmbGCGx1r+D8e4B60OMyUAbJzJLiSbnA2M1ryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+T
	goQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwOvFO6Mu/oCH+dLbVqcczvSW8zrXUr57/NzYi
	SHXPo03xc606U5Y2TTnEb6q3wXOd/VqXCKv5W7kS/9kdnJl3e/KbrASrPAVTO8uNfvnGLtMW
	dJ7Z5pJiGnAp5kbGobrqG5nrV5qsvn9/ldS3X3fSOdiXyT2OvPPiVkad28wF/d+krx57H6qy
	UomlOCPRUIu5qDgRAFWFWgPLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd39U9SDDfpm6Fn8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4cKOdreAhe8W6p0uZGxgb2boYOTgkBEwkti+X6WLkBDLFJC7cWw8U5uIQ
	EljEKLHvxCxGkASvgKDEj8n3WEDqmQXkJY5cygYJMwuoS0yat4gZov4Vo8S8NdOZIep1JTZM
	nM4EYgsL+Ekse3qXEaSXTUBbYvN+A5CwkICixNv9d1lBbBEBJYlf8xexQszMlLjXNIMZpJxF
	QFWifxkPSJhTwEpi1p/VzBCtlhKfLrawg9j8AqIShxduZ4Y4X0lid3sn+wRGoVlIjp6FcPQs
	JEcvYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcyc+kdzCuarA4xCjAwajEw/uCTT1Y
	iDWxrLgy9xCjBAezkgjv0slAId6UxMqq1KL8+KLSnNTiQ4zJQHdPZJYSTc4HJpm8knhDYxMz
	I0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamA0/Mc8Tya5eo5KKWvcDLNt
	mm9v7c58I/mywG3LZf2vW1ILbrRKT7utVtc++4SWO0ewXsmN8MeXcpZ97rgxa++E+6qtBdNm
	7Emc/Sgy+8TfvyeY41MXfqjZsmCb6qbXwupzTRu0vQX99p5aZPvWvJfjh77szfzOLeUOu1wf
	icgciPfd+uDjqZstSizFGYmGWsxFxYkALKYTEygDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-17 (월), 17:40 +0800, Chao Yu:
> Previously 'background_gc={on***,off***}' is being parsed as correct option,
> with this patch we cloud fix the trivial bug in mount process.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 057a3ef..6597290 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -258,9 +258,9 @@ static int parse_options(struct super_block *sb, char *options)
>  
>  			if (!name)
>  				return -ENOMEM;
> -			if (!strncmp(name, "on", 2))
> +			if (!strncmp(name, "on", strlen(name)))

What about 'background_gc=o'?
Need to check strlen(name) == 2...
Thanks,

>  				set_opt(sbi, BG_GC);
> -			else if (!strncmp(name, "off", 3))
> +			else if (!strncmp(name, "off", strlen(name)))
>  				clear_opt(sbi, BG_GC);
>  			else {
>  				kfree(name);

-- 
Jaegeuk Kim
Samsung

