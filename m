Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199AbaKLBnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:43:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934101AbaKLBnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Libin Yang <libin.yang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 120/203] ALSA: hda - add PCI IDs for Intel Braswell
Date: Wed, 12 Nov 2014 10:16:30 +0900
Message-Id: <20141112011548.173297559@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Libin Yang <libin.yang@intel.com>

commit f31b2ffcad2b8c57cee5ffc634928bcbc8c6a558 upstream.

Add HD Audio Device PCI ID for the Intel Braswell platform.
It is an HDA Intel PCH controller.

AZX_DCAPS_ALIGN_BUFSIZE is not necessary for this controller.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -4027,6 +4027,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids)
 	/* BayTrail */
 	{ PCI_DEVICE(0x8086, 0x0f04),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	/* Braswell */
+	{ PCI_DEVICE(0x8086, 0x2284),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* ICH */
 	{ PCI_DEVICE(0x8086, 0x2668),
 	  .driver_data = AZX_DRIVER_ICH | AZX_DCAPS_OLD_SSYNC |


