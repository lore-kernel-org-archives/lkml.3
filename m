Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065Ab3JOXio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:38:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:3734 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007Ab3JOXim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:38:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,503,1378882800"; 
   d="scan'208";a="393473760"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v4 03/12] mrst: Fixed checkpatch warnings
Date: Tue, 15 Oct 2013 16:42:39 -0700
Message-Id: <1381880568-20730-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381880568-20730-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1381880568-20730-1-git-send-email-david.a.cohen@linux.intel.com>
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

