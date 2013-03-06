Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3CFI26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:28:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab3CFI1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:27:49 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="6823122"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [RESEND PATCH 3/6] acpi: Remove the leading spaces of "finish_override" label in acpi_tb_table_override().
Date: Wed, 6 Mar 2013 16:30:08 +0800
Message-Id: <1362558611-32255-4-git-send-email-tangchen@cn.fujitsu.com>
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

There is 7 leading spaces in front of "finish_override" label in acpi_tb_table_override(). Remove them.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/acpica/tbinstal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index e57cd38..b1e098d 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -313,7 +313,7 @@ struct acpi_table_header *acpi_tb_table_override(struct acpi_table_header
 
 	return (NULL);		/* There was no override */
 
-      finish_override:
+finish_override:
 
 	ACPI_INFO((AE_INFO,
 		   "%4.4s %p %s table override, new table: %p",
-- 
1.7.1

