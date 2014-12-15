Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbaLOPEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:04:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaLOO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Devin Ryles <devin.ryles@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 055/168] ALSA: hda_intel: Add DeviceIDs for Sunrise Point-LP
Date: Mon, 15 Dec 2014 14:25:09 +0000
Message-Id: <1418653622-21105-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Ryles <devin.ryles@intel.com>

commit b4565913460cbd7d86c6bd52913dfaa07fa384aa upstream.

This patch adds DeviceIDs for Sunrise Point-LP

Signed-off-by: Devin Ryles <devin.ryles@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 050033e2ef9b..007a1a8298fc 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -174,6 +174,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, LPT_LP},"
 			 "{Intel, WPT_LP},"
 			 "{Intel, SPT},"
+			 "{Intel, SPT_LP},"
 			 "{Intel, HPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
@@ -1788,6 +1789,9 @@ static const struct pci_device_id azx_ids[] = {
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
2.1.3

