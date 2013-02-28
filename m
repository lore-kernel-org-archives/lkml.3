Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab3B1OrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab3B1OrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 032/139] ACPI: Add DMI entry for Sony VGN-FW41E_H
Date: Thu, 28 Feb 2013 14:43:02 +0000
Message-Id: <1362062689-2567-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@canonical.com>

commit 66f2fda93b67fa744d406e6dcf443f67bac204b6 upstream.

This patch adds a quirk to allow the Sony VGN-FW41E_H to suspend/resume
properly.

References: http://bugs.launchpad.net/bugs/1113547
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/sleep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index b89f683..e3d5125 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -185,6 +185,14 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	},
 	{
 	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-FW41E_H",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW41E_H"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VGN-FW21E",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-- 
1.8.1.2

