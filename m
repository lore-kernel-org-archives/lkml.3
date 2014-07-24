Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167AbaGXXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:09:56 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35892 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759814AbaGXXHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:08 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 09/14] staging: vt6655: Remove unreachable break statements
Date: Fri, 25 Jul 2014 01:06:23 +0200
Message-Id: <1406243188-13413-10-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes break "break is not useful after a goto or return"
checkpatch warnings.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/rf.c  | 2 --
 drivers/staging/vt6655/wpa.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index d2d7dff..42b257f 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -873,11 +873,9 @@ bool RFvWriteWakeProgSyn(void __iomem *dwIoBase, unsigned char byRFType, unsigne
 
 	case RF_NOTHING:
 		return true;
-		break;
 
 	default:
 		return false;
-		break;
 	}
 
 	MACvSetMISCFifo(dwIoBase, MISCFIFO_SYNINFO_IDX, (unsigned long)MAKEWORD(bySleepCount, byInitCount));
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
index 505c895..2bd9e1f 100644
--- a/drivers/staging/vt6655/wpa.c
+++ b/drivers/staging/vt6655/wpa.c
@@ -262,7 +262,6 @@ WPA_SearchRSN(
 				return false;
 		}
 		return true;
-		break;
 
 	default:
 		break;
-- 
1.8.5.5

