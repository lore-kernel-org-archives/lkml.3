Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaG2AMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:12:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63233 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbaG2AMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:12:50 -0400
From: Yannick Brosseau <scientist@fb.com>
To: <JBottomley@parallels.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <kernel-team@fb.com>, Yannick Brosseau <scientist@fb.com>
Subject: [PATCH] =?UTF-8?q?[SCSI]=C2=A0Remove=20reference=20to=20scsi=5Fwa?= =?UTF-8?q?it=5Fscan=20module=20in=20SCSI=5FSCAN=5FASYNC=20doc?=
Date: Mon, 28 Jul 2014 17:12:31 -0700
Message-ID: <1406592751-15093-1-git-send-email-scientist@fb.com>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-28_04:2014-07-28,2014-07-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=0.000873769407464253 kscore.compositescore=0
 circleOfTrustscore=46.6901492871467 compositescore=0.998851358762094
 urlsuspect_oldscore=0.998851358762094 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998851358762094 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407290000
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module was removed in c6072609d9bb91ff54aee3ef29304bd5b4fc88aae
   Author: James Bottomley <JBottomley@Parallels.com>
   Date:   Sun May 27 10:13:46 2012 +0100

    [SCSI] Remove scsi_wait_scan module

Signed-off-by: Yannick Brosseau <scientist@fb.com>
---
 drivers/scsi/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index baca589..6e126d1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -255,8 +255,7 @@ config SCSI_SCAN_ASYNC
 
 	  If you have built SCSI as modules, enabling this option can
 	  be a problem as the devices may not have been found by the
-	  time your system expects them to have been.  You can load the
-	  scsi_wait_scan module to ensure that all scans have completed.
+	  time your system expects them to have been.
 	  If you build your SCSI drivers into the kernel, then everything
 	  will work fine if you say Y here.
 
-- 
2.0.1

