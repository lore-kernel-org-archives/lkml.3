Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaETM7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:59:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:23694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaETM7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:59:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,874,1392192000"; 
   d="scan'208";a="542072720"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [Patch V3 1/5] ACPICA: Export acpi_buffer_to_resource symbol
Date: Tue, 20 May 2014 20:59:20 +0800
Message-Id: <1400590764-11108-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com>
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_buffer_to_resource is needed in i2c module
to convert aml buffer to struct acpi_resource

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
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
1.8.3.1

