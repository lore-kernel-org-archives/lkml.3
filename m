Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab3LKHJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:09:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22196 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKHJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:09:07 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7fd26d000003f7b-b4-52a80f8c830f
Content-transfer-encoding: 8BIT
Message-id: <1386745678.2101.152.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: fix the location of tracepoint
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 11 Dec 2013 16:07:58 +0900
In-reply-to: <1386741927-6007-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1386741927-6007-1-git-send-email-jaegeuk.kim@samsung.com>
 <1386741927-6007-2-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI90e/hVBBs3LZS0uLXK32LP3JIvF
	5V1z2ByYPXYv+Mzk8XmTXABTFJdNSmpOZllqkb5dAlfG2o+zWQreclRsnDuXuYGxkb2LkZND
	QsBE4tz7Y0wQtpjEhXvr2boYuTiEBJYxSvxrvM8CU7T1xR12iMQiRokdS36AJXgFBCV+TL4H
	ZHNwMAvISxy5lA0SZhZQl5g0bxEzRP0rRokVK78xQtTrSjxedg1sm7CArcTDnnZ2kF42AW2J
	zfsNQMJCAooSb/ffZQUJiwDZl987QUz3kNh1rBTEZBFQlXj13hGkmFPAXaJ7znUWiMZmRomt
	k1VBbH4BUYnDC7czQxyvJLG7vRPseAmBTewSN9pusYEkWAQEJL5NPgR2vISArMSmA1D1khIH
	V9xgmcAoMQvJi7MQXpyF5MUFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUKiauIOxvsH
	rA8xJgNtnMgsJZqcD4zKvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphakFsUX
	leakFh9iZOLglGpgdEp6vum170772XFnZF5fruOWsWotmclvwn9xe2HupreqHFURX3e8uOUe
	KJfPpr9OZNuDRJFLBkmih5kO6V44qP28b/9S6ZhjG3tf8vGtu8bOyD1djmvX8tpLMU8Zfr5L
	XPPDwkdp5+MeSfc/i2pe/qg86bKZ42zUrmYRcQ/WeI1dv5nUny6pVmIpzkg01GIuKk4EAOXv
	q6HAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG4P/4ogg+O3JS0uLXK32LP3JIvF
	5V1z2ByYPXYv+Mzk8XmTXABTVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmS
	Ql5ibqqtkotPgK5bZg7QDiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1j
	xtqPs1kK3nJUbJw7l7mBsZG9i5GTQ0LARGLriztQtpjEhXvr2boYuTiEBBYxSuxY8oMFJMEr
	ICjxY/I9IJuDg1lAXuLIpWyQMLOAusSkeYuYIepfMUqsWPmNEaJeV+LxsmtMILawgK3Ew552
	dpBeNgFtic37DUDCQgKKEm/332UFCYsA2ZffO0FM95DYdawUxGQRUJV49d4RpJhTwF2ie851
	FojGZkaJrZNVQWx+AVGJwwu3M0McrySxu72TfQKj0CwkJ89COHkWkpMXMDKvYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAiO2WdSOxhXNlgcYhTgYFTi4T1QtDxIiDWxrLgy9xCjBAezkgjv
	CoYVQUK8KYmVValF+fFFpTmpxYcYk4HunsgsJZqcD0wneSXxhsYmZkaWRmYWRibm5qQJK4nz
	Hmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAeHTKFAVlza8XtASay5dEvTD7Mi1x+29lAxGbq20V
	cks6urbIe8rOFvGL21p9+n30hSu31zpMvP1n/5Mmd96MyfWzFDzOf9ylbCQev/H55Y1OjbFe
	ifNfaEzy3pt2aleR8d/6JmOew68OtG1Olr+7+0nlnLjQwru2PKrt9reWJ75SCn1hJOJgqsRS
	nJFoqMVcVJwIAOCCj0IdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops,
Please ignore the second patch.
Sorry for the noise.

2013-12-11 (수), 15:05 +0900, Jaegeuk Kim:
> We need to get a trace before submit_bio, since its bi_sector is remapped during
> the submit_bio.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/data.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index ebc9177..969df55 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -103,9 +103,10 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
>  
>  	rw = fio->rw | fio->rw_flag;
>  
> +	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
> +
>  	if (is_read_io(rw)) {
>  		submit_bio(rw, io->bio);
> -		trace_f2fs_submit_read_bio(io->sbi->sb, rw, fio->type, io->bio);
>  		io->bio = NULL;
>  		return;
>  	}
> @@ -122,7 +123,6 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
>  	} else {
>  		submit_bio(rw, io->bio);
>  	}
> -	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
>  	io->bio = NULL;
>  }
>  

-- 
Jaegeuk Kim
Samsung

