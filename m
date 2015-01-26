Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbbAZQZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:25:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46856 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbbAZQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:23:17 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] coresight: fix the debug AMBA bus name
Date: Mon, 26 Jan 2015 09:22:21 -0700
Message-Id: <1422289345-2084-6-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
References: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kaixu Xia <xiakaixu@huawei.com>

The right debug AMBA bus name should be APB(Advanced Peripheral Bus),
so just fix it.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 Documentation/trace/coresight.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/coresight.txt b/Documentation/trace/coresight.txt
index bba7dbfc49ed..02361552a3ea 100644
--- a/Documentation/trace/coresight.txt
+++ b/Documentation/trace/coresight.txt
@@ -46,7 +46,7 @@ At typical coresight system would look like this:
   | |   .        | !   | |   .        | !      | !        .   |      | SWD/
   | |   .        | !   | |   .        | !      | !        .   |      | JTAG
   *****************************************************************<-|
- *************************** AMBA Debug ABP ************************
+ *************************** AMBA Debug APB ************************
   *****************************************************************
    |    .          !         .          !        !        .    |
    |    .          *         .          *        *        .    |
@@ -79,7 +79,7 @@ At typical coresight system would look like this:
           To trace port                       TPIU= Trace Port Interface Unit
                                               SWD = Serial Wire Debug
 
-While on target configuration of the components is done via the ABP bus,
+While on target configuration of the components is done via the APB bus,
 all trace data are carried out-of-band on the ATB bus.  The CTM provides
 a way to aggregate and distribute signals between CoreSight components.
 
-- 
1.9.1

