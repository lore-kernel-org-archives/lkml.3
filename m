Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbbALTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:16:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbbALSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 013/216] [media] sound: Update au0828 quirks table
Date: Mon, 12 Jan 2015 18:02:10 +0000
Message-Id: <1421085933-32536-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit 678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904 upstream.

The au0828 quirks table is currently not in sync with the au0828
media driver.

Syncronize it and put them on the same order as found at au0828
driver, as all the au0828 devices with analog TV need the
same quirks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/quirks-table.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 8f3e2bf100eb..83bddbdb90e9 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2827,14 +2827,22 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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
2.1.4

