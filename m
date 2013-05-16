Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3EPF2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:28:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:42940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3EPF2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="338112760"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda - add PCI IDs for Intel BayTrail
Date: Thu, 16 May 2013 13:27:18 +0800
Message-Id: <1368682038-21434-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Add HD Audio Device PCI ID for the Intel BayTrail platform.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 sound/pci/hda/hda_intel.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index bcd40ee..18640d9 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3811,6 +3811,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* CPT */
 	{ PCI_DEVICE(0x8086, 0x1c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	/* BayTrail */
+	{ PCI_DEVICE(0x8086, 0x0f04),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* PBG */
 	{ PCI_DEVICE(0x8086, 0x1d20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
-- 
1.7.4.4

