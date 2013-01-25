Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab3AYRrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:47:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60504 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757718Ab3AYRq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:46:58 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] staging: zsmalloc: various cleanups/improvments
Date: Fri, 25 Jan 2013 11:46:14 -0600
Message-Id: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012517-7182-0000-0000-000004B66B68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are the first 4 patches of the zswap patchset I
sent out previously.  Some recent commits to zsmalloc and
zcache in staging-next forced a rebase. While I was at it, Nitin
(zsmalloc maintainer) requested I break these 4 patches out from
the zswap patchset, since they stand on their own.

All are already Acked-by Nitin.

Based on staging-next as of today.

Seth Jennings (4):
  staging: zsmalloc: add gfp flags to zs_create_pool
  staging: zsmalloc: remove unused pool name
  staging: zsmalloc: add page alloc/free callbacks
  staging: zsmalloc: make CLASS_DELTA relative to PAGE_SIZE

 drivers/staging/zram/zram_drv.c          |    4 +-
 drivers/staging/zsmalloc/zsmalloc-main.c |   60 ++++++++++++++++++------------
 drivers/staging/zsmalloc/zsmalloc.h      |   10 ++++-
 3 files changed, 47 insertions(+), 27 deletions(-)

-- 
1.7.9.5

