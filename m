Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbbAJMHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 07:07:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41146 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbbAJMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 07:07:18 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-3e-54b115f3d4cd
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <009301d0297a$1fc55780$5f500680$@samsung.com>
 <20150106193222.GA54001@jaegeuk-mac02>
In-reply-to: <20150106193222.GA54001@jaegeuk-mac02>
Subject: RE: [f2fs-dev][PATCH 1/2] f2fs: get rid of kzalloc in
 __recover_inline_status
Date: Sat, 10 Jan 2015 20:06:30 +0800
Message-id: <000001d02ccd$fa6d4f90$ef47eeb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFkIXUtDkRce1o7WmW9+6JiusLUmAEkNo0HnYLRySA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd3PohtDDNr+qlpc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY8ut10wF
	V9kqXh1awtjAOI+1i5GTQ0LARGLGqQNMELaYxIV769m6GLk4hAQWMUqcOPoMyvnBKHF9HkiG
	k4NNQEViecd/sA4RATWJ3n1TgGwODmaBIolVKwRAwkICSRJHmqeAlXMKGEs0nFjDDGILC0RI
	nHgzF2wxi4CqxN9Py1lAbF4BS4ljrX2MELagxI/J98DizAJaEut3HmeCsOUlNq95ywxxqILE
	jrOvGSFOsJJY9GI3M0SNuMTGI7dYJjAKzUIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO9
	4sTc4tK8dL3k/NxNjOAYeCa9g3FVg8UhRgEORiUe3h+dG0KEWBPLiitzDzFKcDArifBK3QEK
	8aYkVlalFuXHF5XmpBYfYpTmYFES51WybwsREkhPLEnNTk0tSC2CyTJxcEo1MDod0vivEX5+
	+qMVzsmRO58EJWz7/XXD741vYu8cifv/56/Vn6ca81s2FqiILG34wKleKfjPzkbwWvPuWVk9
	R3znMPKv1O26bny63W/No+2LJFZ98ZFVOKd8+F7x+kmum0XWzE3YlR2TKp4deUma9VDL2/nc
	F87EfK7e58E8ubUgVXDHB512g59KLMUZiYZazEXFiQAMxquxfQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, January 07, 2015 3:32 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 1/2] f2fs: get rid of kzalloc in __recover_inline_status
> 
> Hi Chao,
> 
> On Tue, Jan 06, 2015 at 02:28:43PM +0800, Chao Yu wrote:
> > We use kzalloc to allocate memory in __recover_inline_status, and use this
> > all-zero memory to check the inline date content of inode page by comparing
> > them. This is low effective and not needed, let's check inline date content
> > directly.
> >

[snip]

> 
> I think *goto recovery* is not a good way.
> 
> How's like this?
> If you don't mind, I'll merge the patch with this.

It's OK, thank you!

Regards,
Yu



