Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3IXBDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:03:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43439 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3IXBDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:03:30 -0400
X-AuditID: 9c930179-b7c8bae000006c65-df-5240e4dfb852
Date: Tue, 24 Sep 2013 10:03:54 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: Re: [PATCH v3 3/3] mm/zswap: avoid unnecessary page scanning
Message-ID: <20130924010354.GH17725@bbox>
References: <000101ceb836$1a4c0ee0$4ee42ca0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000101ceb836$1a4c0ee0$4ee42ca0$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:21:49PM +0800, Weijie Yang wrote:
> add SetPageReclaim before __swap_writepage so that page can be moved to the
> tail of the inactive list, which can avoid unnecessary page scanning as this
> page was reclaimed by swap subsystem before.
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
