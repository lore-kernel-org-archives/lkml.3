Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3KVDnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:43:03 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26676 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3KVDm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:42:58 -0500
X-AuditID: cbfee691-b7f866d000001b8c-b7-528ed2c00b61
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1385091679.16054.5.camel@lcm>
Subject: Re: [f2fs-dev] [PATCH] f2fs: merge read IOs at ra_nat_pages()
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Fri, 22 Nov 2013 12:41:19 +0900
In-reply-to: <1385026550-21055-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1385026550-21055-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zA90Dl/qCDHbvNLe4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+P9Kc2Cs7wVU/qf
	MzcwvuDqYuTgkBAwkXh1xr2LkRPIFJO4cG89WxcjF4eQwDJGiZVnVjNDJEwk1j68xwhiCwlM
	Z5SY+t4CxOYVEJT4MfkeC4jNLKAuMWneImYIW0Ri9s77UHFtiWULXzNDDH3NKLFr+TkWiGYt
	iX0vN4M1CAu4SWza+xcszgYUbz+9FswWEdCUeLx8M9TQTIk5ryezgtgsAqoSG+e0gR3EKeAh
	cfT4MnaI49wlnt69wQ5xtJLE7vZOdpDFEgKr2CUev1zKCNEsIPFt8iEWiO9lJTYdgHpSUuLg
	ihssExjFZyH5bRaS32Yh+W0Wkt8WMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiJt4k7
	GO8fsD7EmAy0fiKzlGhyPjBe80riDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBsXm2mc1ljm1el4zsHNx2rEt8PP3iqZVKwlkbD2tzCLlm/Zo26fNW
	Do6sRo1JM3NvWLgZyxVW75p9fmeqInurmYRlbObtnO2zj31uONS/K2rlzkYJmQu7zuy1qAz/
	cc33lPKcIy0+bxZsOxK24eX/tQr1exROpTczfohYIRNbcea88ZeVaQURukosxRmJhlrMRcWJ
	AEZE273NAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQd0Dl/qCDL5uMba4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjz5W3bAU7eSvW329ibmC8wtXFyMkhIWAisfbhPUYIW0ziwr31bCC2kMB0
	Romp7y1AbF4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RcxcjF1D5a0aJXcvPsUDUa0ns
	e7mZGcQWFnCT2LT3L1icDSjefnotmC0ioCnxeDlEDbNApsSc15NZQWwWAVWJjXPawO7hFPCQ
	OHp8GTvEPe4ST+/eYIe4U0lid3sn+wRGgVlIzpuFcN4sJOctYGRexSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iREcnc+kdjCubLA4xCjAwajEwytg0xckxJpYVlyZe4hRgoNZSYTXYwNQiDcl
	sbIqtSg/vqg0J7X4EGMy0LETmaVEk/OBiSOvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLp
	iSWp2ampBalFMFuYODilGhg3lPcL/dvx6u7rKN7PD5XTP/+M66pdNs/gu+/M84szk9+K/ZrS
	ILa62af079Upp3g7Tx2dk2sVaKLZ5FP5XFXZ/VHL1CV2ioVRaw7pW1/gN57V3qEzaUNNUNum
	owtkRNdn+Fo4TVm2W2LhtgDzGTYJJ+rOqmj/eLfSe9tc1/9HXgnbC/NoW/5VYinOSDTUYi4q
	TgQAc2tX/xIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about doing mark_page_accessed(page) in ra_nat_pages like
ra_sit_pages to prevent readahead pages are reclaimed by VM?

On 목, 2013-11-21 at 18:35 +0900, Jaegeuk Kim wrote:
> This patch changes the policy of submitting read bios at ra_nat_pages.
> 
> Previously, f2fs submits small read bios with block plugging.
> But, with this patch, f2fs itself merges read bios first and then submits a
> large bio, which can reduce the bio handling overheads.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/node.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index b843a5b..c06871f 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -89,13 +89,10 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
>  {
>  	struct address_space *mapping = sbi->meta_inode->i_mapping;
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> -	struct blk_plug plug;
>  	struct page *page;
>  	pgoff_t index;
>  	int i;
>  
> -	blk_start_plug(&plug);
> -
>  	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
>  		if (nid >= nm_i->max_nid)
>  			nid = 0;
> @@ -108,12 +105,11 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)

mark_page_accessed(page);

>  			f2fs_put_page(page, 1);
>  			continue;
>  		}
> -		if (f2fs_readpage(sbi, page, index, READ))
> -			continue;
> +		submit_read_page(sbi, page, index, READ_SYNC);
>  

mark_page_accessed(page);

>  		f2fs_put_page(page, 0);
>  	}
> -	blk_finish_plug(&plug);
> +	f2fs_submit_read_bio(sbi, READ_SYNC);
>  }
>  
>  static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)


