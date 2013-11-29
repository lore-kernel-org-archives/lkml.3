Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3K2KPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:15:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:45454 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3K2KPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:15:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f666d0000048b0-37-52986931f4ae
Content-transfer-encoding: 8BIT
Message-id: <1385720057.2417.46.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 2/5] f2fs: add unlikely macro for compiler
 optimization
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Fri, 29 Nov 2013 19:14:17 +0900
In-reply-to: <003301ceec0d$77ddaef0$67990cd0$@samsung.com>
References: <003301ceec0d$77ddaef0$67990cd0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ13DzBlBBr1/VC3+N31ks7i0yN1i
	z96TLBaXd81hs2hdeJ7ZgdVj94LPTB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcfH5MaaC
	f+wVhx9sZGlgnMHWxcjJISFgInHt3jV2CFtM4sK99WBxIYFljBLnZ6jD1Hw4vYCxi5ELKD6d
	UWL6zZ9gDbwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6V4wSMz7OZoWo15F49xJi
	sbBAhMTaO9+YQXrZBLQlNu83gNirKPF2/12wchEBJYlf8xexgsxhFljIKHFwwU2wXhYBVYkf
	H18ygticAlYSvdceMYLMERKwlJj3HGwOv4CoxOGF25kh7leS2N3eyQ4yR0LgHLvEs2uvoOYI
	SHybfAjsfgkBWYlNB6DqJSUOrrjBMoFRYhaSL2chfDkLyZcLGJlXMYqmFiQXFCelF5nqFSfm
	Fpfmpesl5+duYoTE3cQdjPcPWB9iTAbaOJFZSjQ5Hxi3eSXxhsZmRhamJqbGRuaWZqQJK4nz
	pj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWNO40CuQfeXkcw/XXp++6rnonJ8iKfuv
	x+q+mcmpfWHWdy7vuUvLTK+cW1D++sAq2a9ssfnvdY4smH4pd72JZuDelCsPyitvJ33KXDwv
	0UnwwppVW+YazrFu1P/Aem+D4yL9W+pqHh9Mnld+q31T83zrqgceHtVLV3VeYjf0/nvvoWOt
	qP6JIhElluKMREMt5qLiRAD97OP70QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQV3DzBlBBrc+Klr8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePi82NMBf/YKw4/2MjSwDiDrYuRk0NCwETiw+kFjBC2mMSFe+uB
	4lwcQgLTGSWm3/zJDpLgFRCU+DH5HksXIwcHs4C8xJFL2SBhZgF1iUnzFjFD1L9ilJjxcTYr
	RL2OxLuXEAuEBSIk1t75xgzSyyagLbF5vwFIWEhAUeLt/rtg5SICShK/5i9iBZnDLLCQUeLg
	gptgvSwCqhI/Pr4EO45TwEqi99ojRpA5QgKWEvOeg83hFxCVOLxwOzPE/UoSu9s72ScwCs1C
	cvUshKtnIbl6ASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzguH4mtYNxZYPFIUYBDkYl
	Ht4V3dODhFgTy4orcw8xSnAwK4nw/ioCCvGmJFZWpRblxxeV5qQWH2JMBrp7IrOUaHI+MOXk
	lcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjpgc2pS+yVISn
	Bt+Srfe+98s1lHMlK/OUgi8ca1/FFf7v/f2VicW8aLJF5bJrl9TnLNzUUvsq0aRwN0vw+WUb
	3iw1ijx5aH7E/RdbDvmsPLfmdtKRE+IRzap1W0x5RG/qcyvVTX35wFz8eWn72/DwlDobiX+C
	N0+c+/r87q0pF1uufDdab7xjthJLcUaioRZzUXEiAB4IzJUvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you make a patch to add *unlikely* as many as possible across the
whole source files at once?
It is wasteful to add it with a bunch of patches at multiple times.

And please write descriptions for all the patches even if nothing is
special.
In this case, why should we set *unlikely* for checking this condition?

Thanks,

2013-11-28 (목), 15:42 +0800, Chao Yu:
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 0fe9a97..954155b 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1160,7 +1160,7 @@ int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
>  			struct page *page = pvec.pages[i];
>  
>  			/* until radix tree lookup accepts end_index */
> -			if (page->index > end)
> +			if (unlikely(page->index > end))
>  				continue;
>  
>  			if (ino && ino_of_node(page) == ino) {

-- 
Jaegeuk Kim
Samsung

