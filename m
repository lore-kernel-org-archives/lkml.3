Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbbATPeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:34:25 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39409 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbATPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:34:21 -0500
Message-ID: <54BE7547.6010701@gmail.com>
Date: Tue, 20 Jan 2015 23:33:27 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, Hui Zhu <teawater@gmail.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com, vbabka@suse.cz, iamjoonsoo.kim@lge.com,
        isimatu.yasuaki@jp.fujitsu.com, wangnan0@huawei.com, davidlohr@hp.com,
        cl@linux.com, rientjes@google.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hui Zhu <zhuhui@xiaomi.com>, Weixing Liu <liuweixing@xiaomi.com>
Subject: Re: [PATCH] CMA: treat free cma pages as non-free if not ALLOC_CMA
 on watermark checking
References: <1421569979-2596-1-git-send-email-teawater@gmail.com> <20150119065544.GA18473@blaptop>
In-Reply-To: <20150119065544.GA18473@blaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Minchan,

How are you?

在 2015/1/19 14:55, Minchan Kim 写道:
> Hello,
> 
> On Sun, Jan 18, 2015 at 04:32:59PM +0800, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@xiaomi.com>
>>
>> The original of this patch [1] is part of Joonsoo's CMA patch series.
>> I made a patch [2] to fix the issue of this patch.  Joonsoo reminded me
>> that this issue affect current kernel too.  So made a new one for upstream.
> 
> Recently, we found many problems of CMA and Joonsoo tried to add more
> hooks into MM like agressive allocation but I suggested adding new zone

Just out of curiosity, "new zone"? Something like movable zone?

Thanks.

> would be more desirable than more hooks in mm fast path in various aspect.
> (ie, remove lots of hooks in hot path of MM, don't need reclaim hooks
>  for special CMA pages, don't need custom fair allocation for CMA).
> 
> Joonsoo is investigating the direction so please wait.
> If it turns out we have lots of hurdle to go that way,
> this direction(ie, putting more hooks) should be second plan.
> 
> Thanks.
> 

