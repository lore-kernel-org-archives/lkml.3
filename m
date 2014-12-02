Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaLBTWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:22:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbaLBTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Ralston <james.d.ralston@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 065/121] ALSA: hda_intel: Add Device IDs for Intel Sunrise Point PCH
Date: Tue,  2 Dec 2014 11:19:04 -0800
Message-Id: <1417548000-1794-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit c8b00fd2f4c504a564adcad5b8bd6952ab850b02 upstream.

This patch adds the HD Audio Device IDs for the Intel Sunrise Point PCH.

[the item position rearranged by tiwai]

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a7431d6..304fbbf 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -170,6 +170,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, LPT},"
 			 "{Intel, LPT_LP},"
 			 "{Intel, WPT_LP},"
+			 "{Intel, SPT},"
 			 "{Intel, HPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
@@ -4065,6 +4066,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* Wildcat Point-LP */
 	{ PCI_DEVICE(0x8086, 0x9ca0),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	/* Sunrise Point */
+	{ PCI_DEVICE(0x8086, 0xa170),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Haswell */
 	{ PCI_DEVICE(0x8086, 0x0a0c),
 	  .driver_data = AZX_DRIVER_HDMI | AZX_DCAPS_INTEL_HASWELL },
-- 
1.9.1

