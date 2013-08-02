Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3HBTPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:15:35 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51605 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3HBTPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:15:34 -0400
Date: Fri, 2 Aug 2013 15:15:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 1/2] mm, vmalloc: remove useless variable in vmap_block
Message-ID: <20130802191528.GS715@cmpxchg.org>
References: <1375408621-16563-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375408621-16563-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 10:57:00AM +0900, Joonsoo Kim wrote:
> vbq in vmap_block isn't used. So remove it.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
