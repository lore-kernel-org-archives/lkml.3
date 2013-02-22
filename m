Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3BVFop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:44:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20695 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab3BVFoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:44:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,714,1355068800"; 
   d="scan'208";a="6748269"
From: liguang <lig.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, rientjes@google.com, x86@kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [rebased][PATCH 4/4] remove include asm/acpi.h in process_driver.c
Date: Fri, 22 Feb 2013 13:44:47 +0800
Message-Id: <1361511887-29241-5-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1361511887-29241-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361511887-29241-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 13:43:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 13:43:49,
	Serialize complete at 2013/02/22 13:43:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

process_driver.c include linux/acpi.h which already
include asm/acpi.h, so remove it.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 drivers/acpi/processor_driver.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index df34bd0..341258a 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -53,7 +53,6 @@
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
-#include <asm/acpi.h>
 
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
-- 
1.7.2.5

