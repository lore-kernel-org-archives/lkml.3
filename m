Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab3DXD2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:28:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43708 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473Ab3DXD2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:28:54 -0400
Date: Tue, 23 Apr 2013 20:28:49 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 2/2] mm, nobootmem: do memset() after memblock_reserve()
Message-ID: <20130424032849.GO2018@cmpxchg.org>
References: <1366619113-28017-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1366619113-28017-2-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366619113-28017-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 05:25:13PM +0900, Joonsoo Kim wrote:
> Currently, we do memset() before reserving the area.
> This may not cause any problem, but it is somewhat weird.
> So change execution order.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
