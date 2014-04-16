Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161130AbaDPN0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:26:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:20169 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbaDPN0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:26:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,872,1389772800"; 
   d="scan'208";a="514168653"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, lenb@kernel.org,
        mika.westerberg@linux.intel.com, awilliam@redhat.com,
        tianyu.lan@intel.com, robert.moore@intel.com, lv.zheng@intel.com,
        rafael.j.wysocki@intel.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH 2/9] ACPICA: Export acpi_buffer_to_resource symbol
Date: Wed, 16 Apr 2014 21:24:35 +0800
Message-Id: <1397654682-7094-3-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
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

