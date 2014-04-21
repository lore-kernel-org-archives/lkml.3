Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaDUPSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:18:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaDUPSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:18:11 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org
Subject: [PATCH RESEND 0/2] : block: Use pci_enable_msix_exact()
Date: Mon, 21 Apr 2014 17:19:30 +0200
Message-Id: <cover.1398093399.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The series is against v3.15-rc1. The patches complete converison
of block layer device drivers to the new MSI initialization API.

Thanks!

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (2):
  skd: Use pci_enable_msix_exact() instead of pci_enable_msix_range()
  cciss: Use pci_enable_msix_exact() instead of pci_enable_msix()

 drivers/block/cciss.c    |    6 +-----
 drivers/block/skd_main.c |    7 +++----
 2 files changed, 4 insertions(+), 9 deletions(-)

-- 
1.7.7.6

