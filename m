Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaDRCDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:03:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15773 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRCDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:03:12 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7efc6d0000039d3-cb-535087dec48f
Content-transfer-encoding: 8BIT
Message-id: <1397786468.7727.31.camel@kjgkr>
Subject: Re: [PATCH V2] fs/f2fs/node.c: add static to recover_inline_xattr
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Fri, 18 Apr 2014 11:01:08 +0900
In-reply-to: <20140417180154.7a7d35366ef948ab867b5108@skynet.be>
References: <20140417180154.7a7d35366ef948ab867b5108@skynet.be>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zA9177QHBBvMnqVrMWb+GzaLr9082
	i8u75rA5MHucmPGbxeNu9z9mj8+b5AKYo7hsUlJzMstSi/TtErgytt7qYSlYzF7x5s0mtgbG
	H6xdjJwcEgImEnNuf2KEsMUkLtxbz9bFyMUhJLCMUWLR4yZGmKKHe18wQiQWMUpsWPaOCSTB
	KyAo8WPyPZYuRg4OZgF5iSOXskHCzALqEpPmLWKGqH/FKLGy9QcjRL2OxNc5n5hBbGEBL4ne
	q9/BetkEtCU27zcACQsJKEq83X8X7DgRAVWJxy9us0PMDJZYv74NbAwLUPzQp49sIDangIPE
	wsd7WCB67SWWT70PVsMvICpxeOF2Zoj7lSR2t3eyg9wjIbCPXWJ2908miEECEt8mHwK7QUJA
	VmLTAah6SYmDK26wTGCUmIXky1kIX85C8uUCRuZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmb
	GCFxNnEH4/0D1ocYk4E2TmSWEk3OB8ZpXkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwTipXufjca2dpLM+hT5IlepMenPcuvmo8u6JAsuo5t+X8
	CTPDUjKDeKX5f/ovFvSv4b+vc8VObu8CtQUbviaLnPXlef3qAevO4rb3ce4rnzw9Ul8puZPN
	99Q5m7xzq84m3pvU8cZ6/bKbu2wt5sT/2f/xGUdN/cEl2+P237FMjHgzT9xxD7vxHCWW4oxE
	Qy3mouJEAAylG1vJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAd177QHBBtuWKVrMWb+GzaLr9082
	i8u75rA5MHucmPGbxeNu9z9mj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYM7be6mEpWMxe8ebNJrYGxh+sXYycHBICJhIP975ghLDFJC7cW8/WxcjFISSwiFFi
	w7J3TCAJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP0rRomVrT8YIep1JL7O+cQM
	YgsLeEn0Xv0O1ssmoC2xeb8BSFhIQFHi7f67YDeICKhKPH5xmx1iZrDE+vVtYGNYgOKHPn1k
	A7E5BRwkFj7ewwLRay+xfOp9sBp+AVGJwwu3M0PcrySxu72TfQKj0CwkV89CuHoWkqsXMDKv
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO4mdSOxhXNlgcYhTgYFTi4RXQCwgWYk0sK67M
	PcQowcGsJMKrXAoU4k1JrKxKLcqPLyrNSS0+xJgMdPhEZinR5HxggskriTc0NjEzsjQyszAy
	MTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsb8W2xlsy7zWPm8jFeQ/rL9qOmS7Qp7
	Hq1tK3D6q7q7/bX3hfMf5Ntq2NfyeJe4CC0/6fmJa4bo5uL5PQGHpdvOOznM/yDxJXV5bWVR
	l+BDz5Uzp0yYtOpd8hVrdpUylem3p7os7ZTw/83/x/afEtMexbgTK2dFPVzNvG2emoyy6567
	P+/z7y9TYinOSDTUYi4qTgQAJerqqyYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This was already resolved by Jingoo Han.
Thanks,

2014-04-17 (목), 18:01 +0200, Fabian Frederick:
> recover_inline_xattr is only used in node.c
> 
> Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/f2fs/node.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index a161e95..3ce4beb 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1534,7 +1534,7 @@ void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
>  	clear_node_page_dirty(page);
>  }
>  
> -void recover_inline_xattr(struct inode *inode, struct page *page)
> +static void recover_inline_xattr(struct inode *inode, struct page *page)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	void *src_addr, *dst_addr;

-- 
Jaegeuk Kim
Samsung

