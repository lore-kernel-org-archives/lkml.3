Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3EPHhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:37:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:9194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab3EPHht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:37:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="242332303"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ALSA: hda - add PCI IDs for Intel BayTrail
Date: Thu, 16 May 2013 15:36:12 +0800
Message-Id: <1368689772-27074-1-git-send-email-chiau.ee.chew@intel.com>
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
index bcd40ee..fa902a4 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3847,6 +3847,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* Oaktrail */
 	{ PCI_DEVICE(0x8086, 0x080a),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	/* BayTrail */
+	{ PCI_DEVICE(0x8086, 0x0f04),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* ICH */
 	{ PCI_DEVICE(0x8086, 0x2668),
 	  .driver_data = AZX_DRIVER_ICH | AZX_DCAPS_OLD_SSYNC |
-- 
1.7.4.4

