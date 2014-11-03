Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaKCLcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:32:45 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59537 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaKCLcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:32:42 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-02-545767d8fc57
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] CMA and DMA-mapping update for v3.18-rc4
Date: Mon, 03 Nov 2014 12:32:37 +0100
Message-id: <1415014357-22431-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJMWRmVeSWpSXmKPExsVy+t/xq7o30sNDDBo+yVlc3jWHzWLtkbvs
	Fo/63rI7MHucmPGbxaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgynnzawlKwkLti7b1JTA2M
	kzm7GDk5JARMJFbuaWCEsMUkLtxbz9bFyMUhJLCUUeLG21vsEE4fk8S2OR1MIFVsAoYSXW+7
	2EBsEQEjic8vrrCC2MwCvhJ3Xq1iAbGFBWwkOpbdYAexWQRUJS7cOATUy8HBK+Ah0d/FArFM
	TuL/yxVMExi5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQI8fTXHYxLj1kdYhTgYFTi
	4Z1wOSxEiDWxrLgy9xCjBAezkgjvv5TwECHelMTKqtSi/Pii0pzU4kOMTBycUg2Mh3au+dpQ
	sujTWrZ/UuG7RV6uqVwyf8YyDkcfvV13a9tW9Yj7/7bnybCQf31ZNs2q8tfdu2b7QqVePc0R
	2nK52UMq6Ly609ulj67oF9z+l2rgmVh7N+Tks7yIq3uN/55rjOlYWx55mefB18m6yg39saUr
	nqjyzd0qLqwzh2m+odn/a9oqZlXnlFiKMxINtZiLihMBnjigJNIBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling patches for cma and dma-mapping
subsystems for v3.18-rc4.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-v3.18

for you to fetch changes up to dda02fd6278d9e995850b3c1dba484f17cbe4de4:

  mm, cma: make parameters order consistent in func declaration and definition (2014-10-27 13:00:55 +0100)

----------------------------------------------------------------
Laurent Pinchart (4):
      mm: cma: Don't crash on allocation if CMA area can't be activated
      mm: cma: Always consider a 0 base address reservation as dynamic
      mm: cma: Ensure that reservations never cross the low/high mem boundary
      mm: cma: Use %pa to print physical addresses

Weijie Yang (1):
      mm, cma: make parameters order consistent in func declaration and definition

 include/linux/cma.h |  8 ++++----
 mm/cma.c            | 68 ++++++++++++++++++++++++++++++++++++++++++++------------------------
 2 files changed, 48 insertions(+), 28 deletions(-)


This pull request contains important fixes for recently introduced
highmem support for default contiguous memory region used for
dma-mapping subsystem.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
