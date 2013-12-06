Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423106Ab3LFXVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:21:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423075Ab3LFXVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:21:02 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wang Xingchao <xingchao.wang@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 053/152] ALSA - HDA: New PCI ID for Haswell ULT
Date: Fri,  6 Dec 2013 15:09:37 -0800
Message-Id: <1386371476-2477-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Xingchao <xingchao.wang@linux.intel.com>

commit 4a7c516bf0cd697dbbee11db6258e3b3146e41a6 upstream.

Add new PCI ID 0x0a0c for Haswell ULT platform.

Signed-off-by: Wang Xingchao <xingchao.wang@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 714b801..efe16d2 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3619,6 +3619,8 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	{ PCI_DEVICE(0x8086, 0x9c21),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Haswell */
+	{ PCI_DEVICE(0x8086, 0x0a0c),
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH },
 	{ PCI_DEVICE(0x8086, 0x0c0c),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH },
 	{ PCI_DEVICE(0x8086, 0x0d0c),
-- 
1.8.3.2

