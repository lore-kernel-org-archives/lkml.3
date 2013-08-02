Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3HBTXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:23:00 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51610 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab3HBTW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:22:59 -0400
Date: Fri, 2 Aug 2013 15:22:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 2/2] mm, vmalloc: use well-defined find_last_bit() func
Message-ID: <20130802192254.GT715@cmpxchg.org>
References: <1375408621-16563-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375408621-16563-2-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375408621-16563-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 10:57:01AM +0900, Joonsoo Kim wrote:
> Our intention in here is to find last_bit within the region to flush.
> There is well-defined function, find_last_bit() for this purpose and
> it's performance may be slightly better than current implementation.
> So change it.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
