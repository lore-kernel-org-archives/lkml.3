Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbaLBTV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:21:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaLBTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:21:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Devin Ryles <devin.ryles@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 066/121] ALSA: hda_intel: Add DeviceIDs for Sunrise Point-LP
Date: Tue,  2 Dec 2014 11:19:05 -0800
Message-Id: <1417548000-1794-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Ryles <devin.ryles@intel.com>

commit b4565913460cbd7d86c6bd52913dfaa07fa384aa upstream.

This patch adds DeviceIDs for Sunrise Point-LP

Signed-off-by: Devin Ryles <devin.ryles@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 304fbbf..a045023 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -171,6 +171,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, LPT_LP},"
 			 "{Intel, WPT_LP},"
 			 "{Intel, SPT},"
+			 "{Intel, SPT_LP},"
 			 "{Intel, HPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
@@ -4069,6 +4070,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* Sunrise Point */
 	{ PCI_DEVICE(0x8086, 0xa170),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	/* Sunrise Point-LP */
+	{ PCI_DEVICE(0x8086, 0x9d70),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Haswell */
 	{ PCI_DEVICE(0x8086, 0x0a0c),
 	  .driver_data = AZX_DRIVER_HDMI | AZX_DCAPS_INTEL_HASWELL },
-- 
1.9.1

