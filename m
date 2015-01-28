Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526AbbA2DBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:01:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338AbbA2Cht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 023/139] [media] sound: Update au0828 quirks table
Date: Wed, 28 Jan 2015 14:19:26 -0800
Message-Id: <1422483682-15393-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit 678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904 upstream.

The au0828 quirks table is currently not in sync with the au0828
media driver.

Syncronize it and put them on the same order as found at au0828
driver, as all the au0828 devices with analog TV need the
same quirks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/quirks-table.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index cf946cd..13a915e 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2766,14 +2766,22 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 }
 
 AU0828_DEVICE(0x2040, 0x7200, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
 AU0828_DEVICE(0x2040, 0x7210, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x7217, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721b, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721e, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721f, "Hauppauge", "HVR-950Q"),
-AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
 AU0828_DEVICE(0x2040, 0x7280, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x0fd9, 0x0008, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7201, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x2040, 0x7211, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x2040, 0x7281, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x05e1, 0x0480, "Hauppauge", "Woodbury"),
+AU0828_DEVICE(0x2040, 0x8200, "Hauppauge", "Woodbury"),
+AU0828_DEVICE(0x2040, 0x7260, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7213, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 
 /* Digidesign Mbox */
 {
-- 
1.9.1

