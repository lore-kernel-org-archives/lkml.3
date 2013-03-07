Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3CGKgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:36:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:25950 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3CGKgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:36:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,801,1355068800"; 
   d="scan'208";a="6831342"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, trivial@kernel.org
Subject: [RESEND PATCH 4/6] acpi: Remove the leading spaces of "unmap_and_exit" label in acpi_tb_install_table().
Date: Thu, 7 Mar 2013 18:38:15 +0800
Message-Id: <1362652697-30284-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/07 18:34:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/07 18:34:53,
	Serialize complete at 2013/03/07 18:34:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 6 leading spaces in front of "unmap_and_exit" label in acpi_tb_install_table(). Remove them.

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

