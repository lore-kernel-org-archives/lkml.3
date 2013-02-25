Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697Ab3BYCnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:43:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62288 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759618Ab3BYCnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:43:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,731,1355068800"; 
   d="scan'208";a="6760673"
From: liguang <lig.fnst@cn.fujitsu.com>
To: tglx@linutronix.de, hpa@zytor.com, pavel@ucw.cz, rjw@sisk.pl,
        lv.zheng@intel.com, jarkko.sakkinen@intel.com, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [rebased-again][PATCH 4/4] remove include asm/acpi.h in process_driver.c
Date: Mon, 25 Feb 2013 10:38:37 +0800
Message-Id: <1361759917-5195-5-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1361759917-5195-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361759917-5195-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:38:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:38:51,
	Serialize complete at 2013/02/25 10:38:51
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

