Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3KELhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:37:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28680 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3KELht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:49 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-47-5278d88cd9d7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 05/11] skd: remove SCSI subsystem specific includes
Date: Tue, 05 Nov 2013 12:37:03 +0100
Message-id: <1383651429-4322-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xoG7PjYoggw33TS16e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgypiz8RBjwXy2ir9L7zA3MK5l7WLk5JAQMJF4+X8WlC0mceHeerYuRi4OIYHp
	jBKT939ngXC6mCSOTL7EBFLFJmAlMbF9FSOILSIgLLG/oxWsiFlgAVDHjjnsIAlhATeJDf8m
	gNksAqoS57+dALN5Bdwllv1rZIdYJy/x9H4fG4jNKeAhceXSG7C4EFDNto97WScw8i5gZFjF
	KJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxMz6R2MK5ssDjEKMDBqMTD++BseZAQa2JZcWXu
	IUYJDmYlEd62IxVBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZ
	ODilGhjbp3Dq36spiKjfYHup5Ob0NyfFeWurHyoqNk6O7jpyo0moftkpx+teH7ZbWB+ec+rD
	C1tJ4d7lDy2evbZbFXJSq1Ik8VFddm8/t+3SSV4d86bu9VSsDez/0Wa19kjv5SSn21F//N4p
	Luzh6WvMuVyTrp4xb5X0OrF/f7TTLQ2uma79cr1NOEmJpTgj0VCLuag4EQBTFj1mIgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a SCSI host driver so remove SCSI subsystem specific
includes.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 9ff34be..47d8a6a 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -42,9 +42,6 @@
 #include <linux/wait.h>
 #include <linux/uio.h>
 #include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_cmnd.h>
 #include <scsi/sg.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-- 
1.8.2.3

