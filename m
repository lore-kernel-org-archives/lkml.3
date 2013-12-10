Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3LJK5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:57:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:2235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3LJK52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:57:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,864,1378882800"; 
   d="scan'208";a="422226632"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] serial: 8250_dw: add new ACPI IDs
Date: Tue, 10 Dec 2013 12:56:59 +0200
Message-Id: <1386673019-27719-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Intel PCHs with LPSS have the same Designware controllers than
Haswell but ACPI IDs are different. Add these IDs to the driver list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 4658e3e0ec42..8cf39ad01667 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -455,6 +455,8 @@ MODULE_DEVICE_TABLE(of, dw8250_of_match);
 static const struct acpi_device_id dw8250_acpi_match[] = {
 	{ "INT33C4", 0 },
 	{ "INT33C5", 0 },
+	{ "INT3434", 0 },
+	{ "INT3435", 0 },
 	{ "80860F0A", 0 },
 	{ },
 };
-- 
1.8.5.1

