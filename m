Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaHSNfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:35:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:64634 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaHSNfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:35:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="560559044"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: 8250_dw: Add ACPI ID for Intel Braswell
Date: Tue, 19 Aug 2014 16:34:49 +0300
Message-Id: <1408455289-4398-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Another new ACPI identifier for the 8250 dw bindings to cover newer Intel
SoCs such as Braswell.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 4db7987ec225..57d9df84ce5d 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -540,6 +540,7 @@ static const struct acpi_device_id dw8250_acpi_match[] = {
 	{ "INT3434", 0 },
 	{ "INT3435", 0 },
 	{ "80860F0A", 0 },
+	{ "8086228A", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, dw8250_acpi_match);
-- 
2.1.0

