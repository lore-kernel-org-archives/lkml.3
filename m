Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab3BOUNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:13:00 -0500
Received: from mout.gmx.net ([212.227.17.21]:57738 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3BOUM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:12:59 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+FONVG/F+FmM9OFNvo61hXCwrOKbSA1NoXPVXcxx
	M/Cj/e73Yx0WX8
From: Peter Huewe <peterhuewe@gmx.de>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/4] staging/ozwpan: Add missing header includes
Date: Fri, 15 Feb 2013 21:17:21 +0100
Message-Id: <1360959444-5961-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ozcdev.c and ozhcd.c should include their own header file, so sparse
knows which functions are declared and which not.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/ozwpan/ozcdev.c |    1 +
 drivers/staging/ozwpan/ozhcd.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index a38716f..25f677ad 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -19,6 +19,7 @@
 #include "ozpd.h"
 #include "ozproto.h"
 #include "ozevent.h"
+#include "ozcdev.h"
 /*------------------------------------------------------------------------------
  */
 #define OZ_RD_BUF_SZ	256
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b48663e..417a52d 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -36,6 +36,7 @@
 #include "oztrace.h"
 #include "ozurbparanoia.h"
 #include "ozevent.h"
+#include "ozhcd.h"
 /*------------------------------------------------------------------------------
  * Number of units of buffering to capture for an isochronous IN endpoint before
  * allowing data to be indicated up.
-- 
1.7.8.6

