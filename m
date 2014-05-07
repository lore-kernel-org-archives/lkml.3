Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaEGAcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:32:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35748 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaEGAcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:32:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f3e6d000002ce8-6e-53697f065f51
Content-transfer-encoding: 8BIT
Message-id: <1399422592.13268.15.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH 6/6] f2fs: add a tracepoint for
 f2fs_read_data_pages
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 09:29:52 +0900
In-reply-to: <004801cf6908$e2149bd0$a63dd370$@samsung.com>
References: <004801cf6908$e2149bd0$a63dd370$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zA122+sxgg5Z3ghb/mz6yWVxa5G6x
	Z+9JFovLu+awObB47F7wmcmjb8sqRo/Pm+QCmKO4bFJSczLLUov07RK4Ms4eOspY8JK/omvB
	B6YGxtM8XYycHBICJhJ9MzYxQdhiEhfurWfrYuTiEBJYxihxfOkVZpiiQxcPM0IkFjFKnF26
	gBEkwSsgKPFj8j2WLkYODmYBeYkjl7JBwswC6hKT5i1ihqh/xSgx98NhVoh6XYlL89vAhgoL
	hEhsOnINrJdNQFti834DkLCQgKLE2/13wcpFBJQkfs1fxAoxM1PiXtMMsFYWAVWJqw+esYDY
	nAJWEhe+QYwUErCUmHXwGhuIzS8gKnF44Xao+5Ukdrd3skPYh9glji2Lg5gjIPFt8iGwEyQE
	ZCU2HYAql5Q4uOIGywRGiVlInpyF8OQsJE8uYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7
	iRESbRN3MN4/YH2IMRlo40RmKdHkfGC05pXEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD40yBw3Yns1yL1vd7rD+/9NqzutfHL59jOjdRcuuHyaGc
	p3b/e3K2Z/E+9zM5L4JlH/xkzjO6t8EoPu0sZ2GhrsZHy/fX1ya/+89zxVfVVe5679wLlb/+
	d3k/tCqdF3vm4K3//48+s73xJsig96VblOoL7jRF+ylmlh1/iw7lL3x4LIpDTmdL7golluKM
	REMt5qLiRACa3OWmzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV22+sxgg/d9fBb/mz6yWVxa5G6x
	Z+9JFovLu+awObB47F7wmcmjb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS81My89JtlbyD453j
	Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgLYpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwnrGDPOHjrKWPCSv6JrwQemBsbTPF2MnBwSAiYShy4eZoSwxSQu3FvP1sXIxSEk
	sIhR4uzSBWAJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP0rRom5Hw6zQtTrSlya
	38YMYgsLhEhsOnINrJdNQFti834DkLCQgKLE2/13wcpFBJQkfs1fxAoxM1PiXtMMsFYWAVWJ
	qw+esYDYnAJWEhe+QYwUErCUmHXwGhuIzS8gKnF44XZmiPuVJHa3d7JPYBSaheTqWQhXz0Jy
	9QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwdH8THoH46oGi0OMAhyMSjy8Fm8zgoVY
	E8uKK3MPMUpwMCuJ8N7UzQwW4k1JrKxKLcqPLyrNSS0+xJgMdPhEZinR5HxgoskriTc0NjEz
	sjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsZpVnvs3gvuyG7J75JfnROj
	MCvO1SJpqvD2Z+pvmD41RZQ2nfS3Z3GOsWlumr4qJKP8j1r9nBqjzR8NVL8cfGvUee6Wine6
	vfG5V9cs7esanKpOyu5ek3Vv0hntMycyiierKkio9tlVbu3jrD2Y6VEgzzSRoS7v9m0P0eS3
	klKRjQ+4Zv/LUGIpzkg01GIuKk4EAL4+FN0qAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

2014-05-06 (화), 16:54 +0800, Chao Yu:
> This patch adds a tracepoint for f2fs_read_data_pages to trace when pages are
> readahead by VFS.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/data.c              |    3 +++
>  include/trace/events/f2fs.h |   26 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 8c250a5..f2d1e8a 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -729,6 +729,9 @@ static int f2fs_read_data_pages(struct file *file,
>  			struct list_head *pages, unsigned nr_pages)
>  {
>  	struct inode *inode = file->f_mapping->host;
> +	struct page *page = list_entry(pages->prev, struct page, lru);

IMO, it needs to avoid the above line.
Thanks,

> +
> +	trace_f2fs_readpages(inode, page, nr_pages);
>  
>  	/* If the file has inline data, skip readpages */
>  	if (f2fs_has_inline_data(inode))
> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> index b983990..7fbaaaa 100644
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@ -847,6 +847,32 @@ TRACE_EVENT(f2fs_writepages,
>  		__entry->for_sync)
>  );
>  
> +TRACE_EVENT(f2fs_readpages,
> +
> +	TP_PROTO(struct inode *inode, struct page *page, unsigned int nrpage),
> +
> +	TP_ARGS(inode, page, nrpage),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t,	dev)
> +		__field(ino_t,	ino)
> +		__field(pgoff_t,	start)
> +		__field(unsigned int,	nrpage)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->start	= page->index;
> +		__entry->nrpage	= nrpage;
> +	),
> +
> +	TP_printk("dev = (%d,%d), ino = %lu, start = %lu nrpage = %u",
> +		show_dev_ino(__entry),
> +		(unsigned long)__entry->start,
> +		__entry->nrpage)
> +);
> +
>  TRACE_EVENT(f2fs_submit_page_mbio,
>  
>  	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),

-- 
Jaegeuk Kim
Samsung

