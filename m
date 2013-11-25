Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3KYBaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:30:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52266 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3KYBaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:30:20 -0500
X-AuditID: cbfee61b-b7f076d0000004f6-57-5292a8253912
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <001e01cee5cc$3d118310$b7348930$@samsung.com>
 <1385262534.26319.88.camel@kjgkr>
In-reply-to: <1385262534.26319.88.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 1/2] f2fs: adds a tracepoint for submit_read_page
Date: Mon, 25 Nov 2013 09:29:23 +0800
Message-id: <000d01cee97d$e381ee10$aa85ca30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIis3ifiLRyzsYwDWLrxt3Htni+xAKB6MlfmXmCpsA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQV3VFZOCDObt17W4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujIlbHQre
	sVfcbVvM0sB4gK2LkZNDQsBE4tf/qYwQtpjEhXvrgeJcHEIC0xkljs3qYIVwfjBKXN04GayD
	TUBFYnnHfyYQW0RAWmLWp3ksIEXMArMZJXq+PAMaxQHUEStx44Q4SA2ngJ7E/74VYGFhgQCJ
	65OlQMIsAqoSS49PYwMJ8wpYSjz6ZAsS5hUQlPgx+R4LSJhZQF1iypRckDCzgLbEk3cXWCHO
	VJDYcfY12EARASuJ269qIUrEJTYeucUygVFoFpJBsxAGzUIyaBaSjgWMLKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxggP/mfQOxlUNFocYBTgYlXh4J1ZPChJiTSwrrsw9xCjBwawkwrun
	DijEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBsewEzzLZ
	vBOeCf9czOV3bbu3K33+xfCjUfczgrWf5izX7/hc/HT6QZmEPuW1Ea4+GwM3a3hemdvm5a8c
	vikg4tK9SWxHLmtLvp197Xb11LXyUl8/li+Qv1UXW+57a5/IT9Usxm9z85dmmOTXyH2/lf/B
	P3XLL+/ZzevTBX+Zvjj6J2y6+GfX+0osxRmJhlrMRcWJANgrRCN4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Sunday, November 24, 2013 11:09 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: Re: [f2fs-dev] [PATCH 1/2] f2fs: adds a tracepoint for submit_read_page
> 
> Hi,
> 
> We need to avoid redundancy as much as possible.
> So, how about this patch?

Ah, It's more neat!
Thanks. :)


> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Sunday, November 24, 2013 11:51 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: adds a tracepoint for f2fs_submit_read_bio
> 
> Hi,
> 
> Again, this tracepoint alos can be integrated with write_bios like this.

Alright, Thanks!

Regards,
Yu

