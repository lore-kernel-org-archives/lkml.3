Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3JKHOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:14:30 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59763 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3JKHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:14:29 -0400
X-AuditID: 9c93017e-b7c75ae00000230e-25-5257a552827e
Date: Fri, 11 Oct 2013 16:14:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Weijie Yang <weijie.yang@samsung.com>, sjenning@linux.vnet.ibm.com,
        bob.liu@oracle.com, weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: Re: [PATCH v3 3/3] mm/zswap: avoid unnecessary page scanning
Message-ID: <20131011071430.GD6847@bbox>
References: <000101ceb836$1a4c0ee0$4ee42ca0$%yang@samsung.com>
 <20131010125506.158c871becad30328abf6838@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010125506.158c871becad30328abf6838@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 12:55:06PM -0700, Andrew Morton wrote:
> On Mon, 23 Sep 2013 16:21:49 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:
> 
> > add SetPageReclaim before __swap_writepage so that page can be moved to the
> > tail of the inactive list, which can avoid unnecessary page scanning as this
> > page was reclaimed by swap subsystem before.
> > 
> > Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> > Reviewed-by: Bob Liu <bob.liu@oracle.com>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: stable@vger.kernel.org
> > Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> As a minor(?) performance tweak, I don't believe this is suitable for
> -stable backporting, so I took that out.  If you believe this was a
> mistake, please explain why.
> 

Yes. It's never stable stuff.

-- 
Kind regards,
Minchan Kim
