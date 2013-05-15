Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3EOV2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:28:48 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:50049
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3EOV2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:28:46 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/6] Drivers: hv: Add the GUID fot synthetic fiber channel device
Date: Wed, 15 May 2013 15:02:30 -0700
Message-Id: <1368655354-27651-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368655354-27651-1-git-send-email-kys@microsoft.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for supporting synthetic Fiber Channel device, add the GUID for
this service.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 include/linux/hyperv.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index a1a97a7..bffee1d 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1389,6 +1389,16 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 		}
 
 /*
+ * Synthetic FC GUID
+ * {2f9bcc4a-0069-4af3-b76b-6fd0be528cda}
+ */
+#define HV_SYNTHFC_GUID \
+	.guid = { \
+			0x4A, 0xCC, 0x9B, 0x2F, 0x69, 0x00, 0xF3, 0x4A, \
+			0xB7, 0x6B, 0x6F, 0xD0, 0xBE, 0x52, 0x8C, 0xDA \
+		}
+
+/*
  * Common header for Hyper-V ICs
  */
 
-- 
1.7.4.1

