Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaDVGcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:32:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:30102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbaDVGcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:32:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="524673049"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tianyu.lan@intel.com
Subject: [Resend Patch 2/9] ACPICA: Export acpi_buffer_to_resource symbol
Date: Tue, 22 Apr 2014 14:24:08 +0800
Message-Id: <1398147855-9868-3-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_buffer_to_resource is needed in i2c module
to convert aml buffer to struct acpi_resource

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/acpica/rscreate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/rscreate.c b/drivers/acpi/acpica/rscreate.c
index 75d3690..5828649 100644
--- a/drivers/acpi/acpica/rscreate.c
+++ b/drivers/acpi/acpica/rscreate.c
@@ -112,6 +112,7 @@ acpi_buffer_to_resource(u8 *aml_buffer,
 
 	return (status);
 }
+ACPI_EXPORT_SYMBOL(acpi_buffer_to_resource);
 
 /*******************************************************************************
  *
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

