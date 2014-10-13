Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaJMWWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 18:22:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:31667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaJMWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 18:22:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,714,1406617200"; 
   d="scan'208";a="588304306"
From: James Ralston <james.d.ralston@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: James Ralston <james.d.ralston@intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] hda_intel: Add Device IDs for Intel Sunrise Point PCH
Date: Mon, 13 Oct 2014 15:22:03 -0700
Message-Id: <1413238923-5578-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the HD Audio Device IDs for the Intel Sunrise Point PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 sound/pci/hda/hda_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index aa302fb..8856604 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -218,6 +218,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, LPT},"
 			 "{Intel, LPT_LP},"
 			 "{Intel, WPT_LP},"
+			 "{Intel, SPT},"
 			 "{Intel, HPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
@@ -1984,6 +1985,9 @@ static const struct pci_device_id azx_ids[] = {
 	/* 9 Series */
 	{ PCI_DEVICE(0x8086, 0x8ca0),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	/* Sunrise Point */
+	{ PCI_DEVICE(0x8086, 0xa170),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Wellsburg */
 	{ PCI_DEVICE(0x8086, 0x8d20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
-- 
1.8.3.1

