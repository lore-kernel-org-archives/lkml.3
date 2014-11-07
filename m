Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaKGXDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:03:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:62481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaKGXDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:03:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,335,1413270000"; 
   d="scan'208,223";a="633581030"
Message-ID: <1415401367.1954.14.camel@localhost.localdomain>
Subject: [PATCH 3/3] hda_intel: Add DeviceIDs for Sunrise Point-LP
From: Devin Ryles <devin.ryles@intel.com>
To: perex@perex.cz
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org, james.d.ralston@intel.com,
        frank.riegel@intel.com, devin.ryles@intel.com
Date: Fri, 07 Nov 2014 18:02:47 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e02662c35ea1352ce711701a46f85e3547f842e1 Mon Sep 17 00:00:00 2001
From: Devin Ryles <devin.ryles@intel.com>
Date: Thu, 6 Nov 2014 12:35:25 -0500
Subject: [PATCH 3/3] hda_intel: Add DeviceIDs for Sunrise Point-LP

This patch adds DeviceIDs for Sunrise Point-LP

Signed-off-by: Devin Ryles <devin.ryles@intel.com>
---
 sound/pci/hda/hda_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 9ab1e63..16660f3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -219,6 +219,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, LPT_LP},"
 			 "{Intel, WPT_LP},"
 			 "{Intel, SPT},"
+			 "{Intel, SPT_LP},"
 			 "{Intel, HPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
@@ -2004,6 +2005,9 @@ static const struct pci_device_id azx_ids[] = {
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
1.9.3



