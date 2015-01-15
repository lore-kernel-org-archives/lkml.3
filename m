Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbbAOKWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:22:25 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43345 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbbAOKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:22:22 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: perex@perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH][trivial] ALSA:hda - Fix typo in hda_controller.c
Date: Thu, 15 Jan 2015 19:22:19 +0900
Message-Id: <1421317339-17338-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in hda_controller.c.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/pci/hda/hda_controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 0cfc9c8..657b604 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -1993,4 +1993,4 @@ void azx_notifier_unregister(struct azx *chip)
 EXPORT_SYMBOL_GPL(azx_notifier_unregister);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Common HDA driver funcitons");
+MODULE_DESCRIPTION("Common HDA driver functions");
-- 
2.3.0.rc0

