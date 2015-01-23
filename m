Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbbAWTMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:12:10 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46258 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbAWTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:12:07 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v1 1/2] Staging: comedi: fix line over 80 characters warning
Date: Sat, 24 Jan 2015 00:41:19 +0530
Message-Id: <1422040280-20213-2-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com>
References: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to file jr3_pci.h that fix up warning line
over 80 character which is found by checkpatch tool.

Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/jr3_pci.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.h b/drivers/staging/comedi/drivers/jr3_pci.h
index 20478ae..356811d 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.h
+++ b/drivers/staging/comedi/drivers/jr3_pci.h
@@ -261,8 +261,9 @@ struct intern_transform {
 	} link[8];
 };
 
-/*  JR3 force/torque sensor data definition. For more information see sensor and */
-/*  hardware manuals. */
+/*  JR3 force/torque sensor data definition. For more information see sensor
+ *  and hardware manuals.
+ */
 
 struct jr3_channel {
 	/*  Raw_channels is the area used to store the raw data coming from */
-- 
1.9.1

