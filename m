Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967445Ab3E3DGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:06:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:20732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967368Ab3E3DDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312628"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com
Subject: [PATCH v1 03/13] mrst: Fixed checkpatch warnings
Date: Wed, 29 May 2013 19:45:13 -0700
Message-Id: <1369881923-27067-4-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch warnings in mrst related files.

Change-Id: I4aa558a1b1c261444ae6b63b0da6273923d0afaa
Signed-off-by: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
---
 arch/x86/pci/mrst.c           |    2 +-
 arch/x86/platform/mrst/mrst.c |    2 +-
 arch/x86/platform/mrst/vrtc.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 66a672e..d5d222e 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -43,7 +43,7 @@
 #define PCI_FIXED_BAR_4_SIZE	0x14
 #define PCI_FIXED_BAR_5_SIZE	0x1c
 
-static int pci_soc_mode = 0;
+static int pci_soc_mode;
 
 /**
  * fixed_bar_cap - return the offset of the fixed BAR cap if found
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 58cdfd1..4784c33 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -977,7 +977,7 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 		case SFI_DEV_TYPE_UART:
 		case SFI_DEV_TYPE_HSI:
 		default:
-			;
+			break;
 		}
 	}
 	return 0;
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index d735deb..05191dc 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -109,7 +109,7 @@ int vrtc_set_mmss(unsigned long nowtime)
 		spin_unlock_irqrestore(&rtc_lock, flags);
 	} else {
 		pr_err("%s: Invalid vRTC value: write of %lx to vRTC failed\n",
-			__FUNCTION__, nowtime);
+			__func__, nowtime);
 		retval = -EINVAL;
 	}
 	return retval;
-- 
1.7.9.5

