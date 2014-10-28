Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbaJ1GyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:54:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28072 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760309AbaJ1GyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:54:15 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-18-544f3d94e743
Message-id: <544F3D91.1070604@samsung.com>
Date: Tue, 28 Oct 2014 07:54:09 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 dma-mapping tree
References: <20141028152444.79bd9fe9@canb.auug.org.au>
 <20141027232910.952850f8.akpm@linux-foundation.org>
In-reply-to: <20141027232910.952850f8.akpm@linux-foundation.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7pTbP1DDN63clnMWb+GzeJs0xt2
	i4lNd1gsLu+aw2ZxcGEbo8XWvVfZLW7/5nNg92i8cYPNY3bHTFaPEzN+s3j0Nr9j8+jbsorR
	4/MmuQC2KC6blNSczLLUIn27BK6Mj4uXMhZ8Zq/Y8uYHYwPjerYuRk4OCQETiSMdz1ggbDGJ
	C/dA4lwcQgJLGSXWr5/JDOF8YpTYuvY6WBWvgJbEvVW7mEFsFgFViV8nIbrZBAwlut52gU0V
	FYiRuL9zNRtEvaDEj8n3wGpEBCIkzm+C2MwscIFR4uQBzS5GDg5hgSiJJzMsQMJCAjkSd2+3
	gZVzCjhIdHzuZ4YoN5P48vIwK4QtL7F5zVvmCYwCs5BsmIWkbBaSsgWMzKsYRVNLkwuKk9Jz
	jfSKE3OLS/PS9ZLzczcxQoL96w7GpcesDjEKcDAq8fBGsPiHCLEmlhVX5h5ilOBgVhLhXa4C
	FOJNSaysSi3Kjy8qzUktPsTIxMEp1cDoyX2raZlZd9OdLY+ll5751nWbueGWwLSub7JeT8IL
	Ta9I38yU/bQtYv6dC9/mH9xv8uy8gIvtlptX4n4UcsiHnxX5eefuwsjTPE/0nyrkJXL8C/1n
	a1u6ZFO6wCK7a9I+PEZa34tfTc3/+6a4UFXhi4bYx7UTPlw8tOpq2dNFx1RFn34qkGs1UGIp
	zkg01GIuKk4EACF8u2dUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-28 07:29, Andrew Morton wrote:
> On Tue, 28 Oct 2014 15:24:44 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Today's linux-next merge of the akpm-current tree got a conflict in
>> mm/cma.c between commit 16195ddd4ebc ("mm: cma: Ensure that
>> reservations never cross the low/high mem boundary") from the
>> dma-mapping tree and commit 2a70e5a78672 ("mm/cma: ake kmemleak ignore
>> CMA regions") from the akpm-current tree.
> hm, we have multiple trees altering mm/cma.c?
>
> I'm a bit surprised that this series was merged, given that Laurent
> said he would be sending out a v2...

v2 of Laurent's patches has been posted on 24th October
(https://lkml.org/lkml/2014/10/24/207 ), but since I didn't notice them 
to be taken
I thought that it would make sense to get them via my tree and send them 
to Linus
during the 3.18-rc cycle. If this was not appropriate, I will drop my tree.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

