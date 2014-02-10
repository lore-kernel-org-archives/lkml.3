Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaBJT7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:59:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35014 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaBJTqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:43 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Matthew Garrett <matthew.garrett@nebula.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 080/124] hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
Date: Mon, 10 Feb 2014 11:40:20 -0800
Message-Id: <1392061264-28124-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b0ad4ff35d479a46a3b995a299db9aeb097acfce upstream.

The DriveGuard chips on the new HP laptops are with a new PnP ID
"HPQ6007".  It should be compatible with older chips.

Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/platform/x86/hp_accel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 1c43168..99724b0 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -77,6 +77,7 @@ static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
 static struct acpi_device_id lis3lv02d_device_ids[] = {
 	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
 	{"HPQ6000", 0}, /* HP Mobile Data Protection System PNP */
+	{"HPQ6007", 0}, /* HP Mobile Data Protection System PNP */
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
-- 
1.8.3.2

