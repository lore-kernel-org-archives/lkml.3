Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3CEIVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:21:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab3CEIVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:21:08 -0500
X-IronPort-AV: E=Sophos;i="4.84,785,1355068800"; 
   d="scan'208";a="6815904"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, trival@kernel.org
Subject: [PATCH 5/6] In acpi_initialize_tables()
Date: Tue, 5 Mar 2013 16:23:27 +0800
Message-Id: <1362471808-9437-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1362471808-9437-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1362471808-9437-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 16:20:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 16:20:02,
	Serialize complete at 2013/03/05 16:20:02
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

