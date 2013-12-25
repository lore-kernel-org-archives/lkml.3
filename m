Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3LYW4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 17:56:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18851 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3LYW4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 17:56:40 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f566d000002344-77-52bb62a62add
Content-transfer-encoding: 8BIT
Message-id: <1388012129.2101.302.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 1/3 V2] f2fs: check filename length in
 recover_dentry
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Thu, 26 Dec 2013 07:55:29 +0900
In-reply-to: <002201ceff8c$efbd2da0$cf3788e0$@samsung.com>
References: <002201ceff8c$efbd2da0$cf3788e0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zA91lSbuDDPafMrL43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH2+QKmgpt8FbPb
	prE0MJ7m7mLk4JAQMJH4fka5i5ETyBSTuHBvPRuILSSwjFFiZTtU3ERi2rr9LF2MXEDxRYwS
	D57dYARJ8AoISvyYfI8FZA6zgLzEkUvZIGFmAXWJSfMWMUPUv2KU+LC3jQmiXlei9ctXsAXC
	AmESO7a3sYH0sgloS2zebwCxV1Hi7f67rCC2iICSxK/5i1ghZmZKzHk9GcxmEVCV+Hb9DCtI
	K6eAlcSSj3oQrZYSBw4uZQax+QVEJQ4v3M4Mcb6SxO72TnaQcyQEjrFLfPl7lQlijoDEt8mH
	WCDBICux6QBUvaTEwRU3WCYwSsxC8uQshCdnIXlyASPzKkbR1ILkguKk9CIjveLE3OLSvHS9
	5PzcTYyQSOvbwXjzgPUhxmSgjROZpUST84GRmlcSb2hsZmRhamJqbGRuaUaasJI476KHSUFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGNd0m/Xdcf96/fy+GbN+3vh95v+0n8fnv55z/lDd
	zDn1Dbmhi1jMD4lbzoxJ3sw4m6G7sURxVu3B3VImjHJSU945dnHF2JrqSk+IDThjKuN2LWvy
	qR2a/pv8C2z32s9ZlB/JfyD4dXVuTnWZxbEWAcniDx1vfMMVni+o2Pxnhz3LO8s2Dfs5wUos
	xRmJhlrMRcWJAItjB5PKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd1lSbuDDG7s1rP43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix9vkCpoKbfBWz26axNDCe5u5i5OSQEDCRmLZuPwuELSZx4d56ti5GLg4h
	gUWMEg+e3WAESfAKCEr8mHwPqIiDg1lAXuLIpWyQMLOAusSkeYuYIepfMUp82NvGBFGvK9H6
	5SsbiC0sECaxY3sbG0gvm4C2xOb9BiBhIQFFibf777KC2CICShK/5i9ihZiZKTHn9WQwm0VA
	VeLb9TOsIK2cAlYSSz7qQbRaShw4uJQZxOYXEJU4vHA7M8T5ShK72zvZJzAKzUJy9CyEo2ch
	OXoBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBYfia9g3FVg8UhRgEORiUe3g7d3UFC
	rIllxZW5hxglOJiVRHj/SwGFeFMSK6tSi/Lji0pzUosPMSYD3T2RWUo0OR+YZvJK4g2NTcyM
	LI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVFiXdqEx6bcRm+fKZybwu3C
	l7ThR1VgVscH1pmda0v0nj/QPbb7+cfzfFtr/x/qvW7/xm978arD11Y89tsj/Z+V/+OMn+HV
	B6Us15xKORgpfkf34gsr34R6Vf2m/w8X99StXl/ofduQT+ZxZtWeU2qL6xbm5U5c1f6CpSeu
	7s0nx3vybSpMy0OUWIozEg21mIuKEwFNVpOhKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-12-23 (월), 11:12 +0800, Chao Yu:
> In current flow, we will get Null return value of f2fs_find_entry in
> recover_dentry when name.len is bigger than F2FS_NAME_LEN, and then we
> still add this inode into its dir entry.
> To avoid this situation, we must check filename length before we use it.
> 
> Another point is that we could remove the code of checking filename length
> In f2fs_find_entry, because f2fs_lookup will be called previously to ensure of
> validity of filename length.

The f2fs_find_entry is called by f2fs_unlink and f2fs_rename too.
So, you can't remove this, instead it'd be better remove it from
f2fs_lookup.
Thanks,

> 
> V2:
>  o add WARN_ON() as Jaegeuk Kim suggested.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/dir.c      |    3 ---
>  fs/f2fs/recovery.c |    6 ++++++
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 07ad850..f0b4630 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -190,9 +190,6 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
>  	unsigned int max_depth;
>  	unsigned int level;
>  
> -	if (unlikely(namelen > F2FS_NAME_LEN))
> -		return NULL;
> -
>  	if (npages == 0)
>  		return NULL;
>  
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index a3f4542..4d411a2 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -62,6 +62,12 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
>  
>  	name.len = le32_to_cpu(raw_inode->i_namelen);
>  	name.name = raw_inode->i_name;
> +
> +	if (unlikely(name.len > F2FS_NAME_LEN)) {
> +		WARN_ON(1);
> +		err = -ENAMETOOLONG;
> +		goto out;
> +	}
>  retry:
>  	de = f2fs_find_entry(dir, &name, &page);
>  	if (de && inode->i_ino == le32_to_cpu(de->ino))

-- 
Jaegeuk Kim
Samsung

