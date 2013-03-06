Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3CFI3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:29:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27096 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3CFI1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:27:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="6823121"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [RESEND PATCH 1/6] acpi: Remove the leading space of "unlock" label in acpi_memory_device_notify().
Date: Wed, 6 Mar 2013 16:30:06 +0800
Message-Id: <1362558611-32255-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1362558611-32255-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1362558611-32255-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:26:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:26:42,
	Serialize complete at 2013/03/06 16:26:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a leading space in front of "unlock" label in acpi_memory_device_notify(). Remove it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index da1f82b..8a10c23 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -369,7 +369,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			kfree(ej_event);
 		}
 
- unlock:
+unlock:
 		acpi_scan_lock_release();
 		if (ACPI_SUCCESS(status))
 			return;
-- 
1.7.1

