Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3CFI21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:28:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53113 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab3CFI1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:27:50 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="6823124"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [RESEND PATCH 5/6] acpi: Add the missing parameter comment for acpi_initialize_tables().
Date: Wed, 6 Mar 2013 16:30:10 +0800
Message-Id: <1362558611-32255-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1362558611-32255-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1362558611-32255-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:26:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 16:26:43,
	Serialize complete at 2013/03/06 16:26:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the comment of acpi_initialize_tables(), it mistakes allow_resize
with allow_realloc.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/acpica/tbxface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index 93d1432..659e0f6 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -80,7 +80,7 @@ acpi_status acpi_allocate_root_table(u32 initial_table_count)
  *                                    array is dynamically allocated.
  *              initial_table_count - Size of initial_table_array, in number of
  *                                    struct acpi_table_desc structures
- *              allow_realloc       - Flag to tell Table Manager if resize of
+ *              allow_resize        - Flag to tell Table Manager if resize of
  *                                    pre-allocated array is allowed. Ignored
  *                                    if initial_table_array is NULL.
  *
-- 
1.7.1

