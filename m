Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbbAVB42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:56:28 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38040 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbAVB4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:56:20 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 22 Jan 2015 10:57:18 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Hui Zhu <teawater@gmail.com>,
        akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com, vbabka@suse.cz, isimatu.yasuaki@jp.fujitsu.com,
        wangnan0@huawei.com, davidlohr@hp.com, cl@linux.com,
        rientjes@google.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hui Zhu <zhuhui@xiaomi.com>, Weixing Liu <liuweixing@xiaomi.com>
Subject: Re: [PATCH] CMA: treat free cma pages as non-free if not ALLOC_CMA
 on watermark checking
Message-ID: <20150122015718.GE21444@js1304-P5Q-DELUXE>
References: <1421569979-2596-1-git-send-email-teawater@gmail.com>
 <20150119065544.GA18473@blaptop>
 <54BE7547.6010701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE7547.6010701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:33:27PM +0800, Zhang Yanfei wrote:
> Hello Minchan,
> 
> How are you?
> 
> 在 2015/1/19 14:55, Minchan Kim 写道:
> > Hello,
> > 
> > On Sun, Jan 18, 2015 at 04:32:59PM +0800, Hui Zhu wrote:
> >> From: Hui Zhu <zhuhui@xiaomi.com>
> >>
> >> The original of this patch [1] is part of Joonsoo's CMA patch series.
> >> I made a patch [2] to fix the issue of this patch.  Joonsoo reminded me
> >> that this issue affect current kernel too.  So made a new one for upstream.
> > 
> > Recently, we found many problems of CMA and Joonsoo tried to add more
> > hooks into MM like agressive allocation but I suggested adding new zone
> 
> Just out of curiosity, "new zone"? Something like movable zone?

Yes, I named it as ZONE_CMA. Maybe I can send prototype of
implementation within 1 or 2 weeks.

Thanks.
