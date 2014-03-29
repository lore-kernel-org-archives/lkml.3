Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaC2S0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:26:51 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59677 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaC2S0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:26:49 -0400
Date: Sat, 29 Mar 2014 23:57:14 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 38/55] scsi: Mark function as static in qla2xxx/qla_bsg.c
Message-ID: <c3a16784d115b3af27a8415a00add57041e9cda5.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in qla2xxx/qla_bsg.c because it is not used
outside this file.

This eliminates the following warning in qla2xxx/qla_bsg.c:
drivers/scsi/qla2xxx/qla_bsg.c:409:1: warning: no previous prototype for ‘qla24xx_calc_ct_iocbs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index f15d03e..16b7e58 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -405,7 +405,7 @@ done:
 	return rval;
 }
 
-inline uint16_t
+static inline uint16_t
 qla24xx_calc_ct_iocbs(uint16_t dsds)
 {
 	uint16_t iocbs;
-- 
1.7.9.5

