Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3K0FPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:15:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43607 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3K0FPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:15:09 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f666d0000048b0-3e-52957fd86b50
Content-transfer-encoding: 8BIT
Message-id: <1385529248.2417.19.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: remove unneeded code in punch_hole
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>,
        fanofcode.li@samsung.com
Date: Wed, 27 Nov 2013 14:14:08 +0900
In-reply-to: <000201cee760$58df9f10$0a9edd30$@samsung.com>
References: <000201cee760$58df9f10$0a9edd30$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zI90b9VODDB6fYbH43/SRzeLz1kZ2
	i0uL3C327D3JYnF51xw2i9aF55kd2Dx2L/jM5NG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZ
	x/42sBTM4aiYtP46WwPjdrYuRk4OCQETiSVHv7FD2GISF+6tB4pzcQgJLGOUOPVlHlzRyocv
	GCES0xklNtxvYgFJ8AoISvyYfA/I5uBgFpCXOHIpGyTMLKAuMWneImYQW0jgFaPE0XmWEOU6
	ElMnrmMFKRcW8JB4s98WxGQT0JbYvN8AolpR4u3+u6wgtoiAksSv+YtYISbuZpRY1w42kUVA
	VeLzky5GEJtTwEpi/aJJLBC9lhJ3v24Di/MLiEocXridGeJ6JYnd7Z3sINdLCJxjl+i5d5QF
	YpCAxLfJh8CulxCQldh0AKpeUuLgihssExglZiH5cRbCj7OQ/LiAkXkVo2hqQXJBcVJ6kale
	cWJucWleul5yfu4mRkj8TdzBeP+A9SHGZKCNE5mlRJPzgfGbVxJvaGxmZGFqYmpsZG5pRpqw
	kjhv+qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mp3LebmH9sqaHL4Bj9wGWttpLG2OV
	bEzWZGjpLdy7fkPdhHmf+ucf8fBXlv1d0NXKP1d775XzrQdKf8ucvz/vZA+PXvdsOxM3veZr
	ffGT/Q92bHY9kWW9TWdZtpqpvHTkgjepG87ILEj/88gl8Oai7XYT9+k3cNVsPRJ5UsJE/Z/O
	+u+h3cKFSizFGYmGWsxFxYkADODEwdUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd0b9VODDM6aWPxv+shm8XlrI7vF
	pUXuFnv2nmSxuLxrDptF68LzzA5sHrsXfGby6NuyitHj8ya5AOaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaMY38bWArmcFRMWn+drYFxO1sXIyeHhICJxMqHLxghbDGJ
	C/fWA8W5OIQEpjNKbLjfxAKS4BUQlPgx+R6QzcHBLCAvceRSNkiYWUBdYtK8RcwgtpDAK0aJ
	o/MsIcp1JKZOXMcKUi4s4CHxZr8tiMkmoC2xeb8BRLWixNv9d1lBbBEBJYlf8xexQkzczSix
	rh1sIouAqsTnJ11gl3EKWEmsXzSJBaLXUuLu121gcX4BUYnDC7czQ1yvJLG7vZN9AqPQLCQ3
	z0K4eRaSmxcwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7tZ9I7GFc1WBxiFOBgVOLh
	nXB5SpAQa2JZcWXuIUYJDmYlEd7wyqlBQrwpiZVVqUX58UWlOanFhxiTgQ6fyCwlmpwPTDt5
	JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cA4T/rqxZ8r1MQs
	U98+TDHqnL97z9UV3zstO3iVdaKqpifPyvA+aF7R4/BzocnXgL+TmR6GB9t/CeV/Ya3w+HzJ
	n/Wz7rP15bWoLtgQwXvS2/rqnOR+l4J1yhwG836tqnV/z8wsvlRv7/1Ar7OL7GSqd1Y5qk/v
	ecV55bGLapf1bDmWB+JWzmlKLMUZiYZazEXFiQBn5gxHMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got it.

But, with this patch, we can also remove the parameter, int mode, in
punch_hole().
If no objection, I'll fix that in your patch.
Thanks,

2013-11-22 (금), 16:52 +0800, Chao Yu:
> Because FALLOC_FL_PUNCH_HOLE flag must be ORed with FALLOC_FL_KEEP_SIZE 
> in fallocate, so we could remove the useless 'keep size' branch code which 
> will never be excuted in punch_hole.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> Signed-off-by: Fan Li <fanofcode.li@samsung.com>
> ---
>  fs/f2fs/file.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 7d714f4..0087d2a 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -499,12 +499,6 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
>  		}
>  	}
>  
> -	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> -		i_size_read(inode) <= (offset + len)) {
> -		i_size_write(inode, offset);
> -		mark_inode_dirty(inode);
> -	}
> -
>  	return ret;
>  }
>  

-- 
Jaegeuk Kim
Samsung

