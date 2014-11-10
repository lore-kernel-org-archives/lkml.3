Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaKJJz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:55:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41837 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaKJJzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:55:54 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-92-54608ba8dd3d
Date: Mon, 10 Nov 2014 18:54:37 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/5] f2fs: disable roll-forward when active_logs
	= 2
Message-id: <20141110095437.GE14659@lcm>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+Zoe6K7oQQg1tnJC2erJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgyjjx/A5rwQneij8d
	01gbGL9zdTFyckgImEj0X2tlhLDFJC7cW88GYgsJLGOUuLUmDqZm++ILLF2MXEDxRYwSP1Y3
	sEE4PxklJqyZwAJSxSKgKrHw9zawbjYBLYn202vB4iICKhKHFl1mB7GZBTIlJvS/ALOFBUIl
	XjXOBKvnFdCQ6Lz1lhFis5NE168nTBBxQYkfk++xQPRqSazfeZwJwpaWePR3BtgcTgFnic4f
	a1hBbFGgXVNObgM7TkJgEbvElRPNUMcJSHybfAjI5gBKyEpsOsAM8ZmkxMEVN1gmMIrNQrJu
	FpJ1s5CsW8DIvIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJIYm7GC8d8D6EKMAB6MSD6/D
	2/gQIdbEsuLK3EOMpkBXTGSWEk3OB0ZqXkm8obGZkYWpiamxkbmlmZI472upn8FCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGHV+76hOUbyXXZ8/3eDCj62S4obdwcvZ3J+7LzpjM/tNlPEF
	DRELJa/5C+eLHrul8Wqv/zWrPzonP1r2LuRWtvBMZeG+tuHT1dXiT/aKTH21UuD+o2u11j0/
	nGasXGyi2H08O9QtaLJAquAbkY0J9beLpP/mPRJZ+84wO0KqR+/c+rMzQo9Uv1RiKc5INNRi
	LipOBACIhvbvnAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd0V3QkhBrcaxCyerJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w48fwOa8EJ3oo/HdNYGxi/c3UxcnJICJhIbF98gQXCFpO4cG89WxcjF4eQ
	wCJGiR+rG6Ccn4wSE9ZMAKtiEVCVWPh7GxuIzSagJdF+ei1YXERAReLQosvsIDazQKbEhP4X
	YLawQKjEq8aZYPW8AhoSnbfeMoLYQgJOEl2/njBBxAUlfky+xwLRqyWxfudxJghbWuLR3xlg
	czgFnCU6f6xhBbFFgXZNObmNbQKjwCwk7bOQtM9C0r6AkXkVo2hqQXJBcVJ6rpFecWJucWle
	ul5yfu4mRnCMPpPewbiqweIQowAHoxIPr8Pb+BAh1sSy4srcQ4wSHMxKIrzVLQkhQrwpiZVV
	qUX58UWlOanFhxhNgaExkVlKNDkfmD7ySuINjU3MjCyNzCyMTMzNlcR5D7ZaBwoJpCeWpGan
	phakFsH0MXFwSjUw6kwR2Kfq/tL+plBxwSmubCtGlvdbU5UP7Kmu+HHU6W8Hr9TCXQnvus1d
	hBWaozsfl56UuvrFK6fl1ApnecNb1mYRoeuv3vj1620p50l9reLYW3t2TLOfdeHiFl+eRxci
	2JJb9T4ofjypr505QzGx1H/e14L8nTNDHXOWPz0m91a+vmttztkNSizFGYmGWsxFxYkAbTSq
	necCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 11:36:05PM -0800, Jaegeuk Kim wrote:
> The roll-forward mechanism should be activated when the number of active
> logs is not 2.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/file.c    | 2 ++
>  fs/f2fs/segment.c | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 46311e7..54722a0 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -132,6 +132,8 @@ static inline bool need_do_checkpoint(struct inode *inode)
>  		need_cp = true;
>  	else if (test_opt(sbi, FASTBOOT))
>  		need_cp = true;
> +	else if (sbi->active_logs == 2)
> +		need_cp = true;
>  
>  	return need_cp;
>  }
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 2fb3d7f..16721b5d 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -1090,8 +1090,8 @@ static int __get_segment_type_4(struct page *page, enum page_type p_type)
>  		else
>  			return CURSEG_COLD_DATA;
>  	} else {
> -		if (IS_DNODE(page) && !is_cold_node(page))
> -			return CURSEG_HOT_NODE;
> +		if (IS_DNODE(page) && is_cold_node(page))
> +			return CURSEG_WARM_NODE;

Hi Jaegeuk,

We should take hot/cold seperation into account as well.
In case of dir inode, it will be mixed with COLD_NODE.
If it's trade-off, let's notice it kindly as comments.

Regards,
Changman

>  		else
>  			return CURSEG_COLD_NODE;
>  	}
> -- 
> 2.1.1
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
