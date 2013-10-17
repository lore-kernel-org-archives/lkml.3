Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979Ab3JQVwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:52:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:35575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762875Ab3JQVwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:52:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,517,1378882800"; 
   d="scan'208";a="394625550"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v9 03/14] mrst: Fixed checkpatch warnings
Date: Thu, 17 Oct 2013 14:55:46 -0700
Message-Id: <1382046957-15987-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382046957-15987-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1382046957-15987-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

Fixed checkpatch warnings in mrst related files.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/mrst/mrst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 235a742..2a45eab 100644
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
-- 
1.8.4.rc3

