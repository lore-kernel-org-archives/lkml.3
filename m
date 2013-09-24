Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3IXAFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:05:40 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63726 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3IXAFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:05:39 -0400
X-AuditID: 9c93017d-b7c8cae000000bbb-22-5240d7507023
Date: Tue, 24 Sep 2013 09:06:03 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: Re: [PATCH v3 1/3] mm/zswap: bugfix: memory leak when re-swapon
Message-ID: <20130924000603.GF17725@bbox>
References: <000301ceb836$7b4a1340$71de39c0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301ceb836$7b4a1340$71de39c0$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:21:49PM +0800, Weijie Yang wrote:
> zswap_tree is not freed when swapoff, and it got re-kmalloc in swapon,
> so memory-leak occurs.
> 
> Modify: free memory of zswap_tree in zswap_frontswap_invalidate_area().
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> Reviewed-by: Bob Liu <bob.liu@oracle.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: stable@vger.kernel.org
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
