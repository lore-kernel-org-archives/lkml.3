Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3CGKhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:37:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab3CGKgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:36:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,801,1355068800"; 
   d="scan'208";a="6831338"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, trivial@kernel.org
Subject: [RESEND PATCH 3/6] acpi: Remove the leading spaces of "finish_override" label in acpi_tb_table_override().
Date: Thu, 7 Mar 2013 18:38:14 +0800
Message-Id: <1362652697-30284-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/07 18:34:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/07 18:34:51,
	Serialize complete at 2013/03/07 18:34:51
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

