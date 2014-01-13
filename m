Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaAMQvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:51:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaAMQCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 062/208] serial: 8250_dw: add new ACPI IDs
Date: Mon, 13 Jan 2014 15:58:23 +0000
Message-Id: <1389628849-1614-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit d24c195f90cb1adb178d26d84c722d4b9e551e05 upstream.

Newer Intel PCHs with LPSS have the same Designware controllers than
Haswell but ACPI IDs are different. Add these IDs to the driver list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/8250/8250_dw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 76a8daa..b8cacb8 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -399,6 +399,8 @@ MODULE_DEVICE_TABLE(of, dw8250_of_match);
 static const struct acpi_device_id dw8250_acpi_match[] = {
 	{ "INT33C4", 0 },
 	{ "INT33C5", 0 },
+	{ "INT3434", 0 },
+	{ "INT3435", 0 },
 	{ "80860F0A", 0 },
 	{ },
 };
-- 
1.8.3.2

