Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3CEIVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:21:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37765 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab3CEIVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:21:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,785,1355068800"; 
   d="scan'208";a="6815907"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, trival@kernel.org
Subject: [PATCH 4/6] In acpi_tb_install_table()
Date: Tue, 5 Mar 2013 16:23:26 +0800
Message-Id: <1362471808-9437-5-git-send-email-tangchen@cn.fujitsu.com>
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

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/acpica/tbutils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index ce3d5db..27e7715 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -539,7 +539,7 @@ acpi_tb_install_table(acpi_physical_address address,
 		acpi_tb_delete_table(table_desc);
 	}
 
-      unmap_and_exit:
+unmap_and_exit:
 
 	/* Always unmap the table header that we mapped above */
 
-- 
1.7.1

