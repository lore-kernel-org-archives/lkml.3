Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaJEJAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:00:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55436 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaJEJAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:30 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 08/11] qm1d1c0042: namespace cleanup
Date: Sun,  5 Oct 2014 17:59:44 +0900
Message-Id: <37bb3490954e27725cc9be5f1e44832c3907779a.1412497399.git.knightrider@are.ma>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minimize export

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/tuners/qm1d1c0042.h | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
index 4f5c188..65bca43 100644
--- a/drivers/media/tuners/qm1d1c0042.h
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -1,12 +1,12 @@
 /*
- * Sharp QM1D1C0042 8PSK tuner driver
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,24 +14,10 @@
  * GNU General Public License for more details.
  */
 
-#ifndef QM1D1C0042_H
-#define QM1D1C0042_H
-
-#include "dvb_frontend.h"
-
+#ifndef __QM1D1C0042_H__
+#define __QM1D1C0042_H__
 
-struct qm1d1c0042_config {
-	struct dvb_frontend *fe;
+#define QM1D1C0042_DRVNAME "qm1d1c0042"
 
-	u32  xtal_freq;    /* [kHz] */ /* currently ignored */
-	bool lpf;          /* enable LPF */
-	bool fast_srch;    /* enable fast search mode, no LPF */
-	u32  lpf_wait;         /* wait in tuning with LPF enabled. [ms] */
-	u32  fast_srch_wait;   /* with fast-search mode, no LPF. [ms] */
-	u32  normal_srch_wait; /* with no LPF/fast-search mode. [ms] */
-};
-/* special values indicating to use the default in qm1d1c0042_config */
-#define QM1D1C0042_CFG_XTAL_DFLT 0
-#define QM1D1C0042_CFG_WAIT_DFLT 0
+#endif
 
-#endif /* QM1D1C0042_H */
-- 
1.8.4.5

