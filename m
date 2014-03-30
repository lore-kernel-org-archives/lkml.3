Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaC3Xmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:42:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbaC3Xmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Matthew Garrett" <matthew.garrett@nebula.com>,
        "=?UTF-8?Q?=C3=89ric=20?=Piel" <eric.piel@tremplin-utc.net>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.439629868@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 048/200] hp_accel: Add a new PnP ID HPQ6007 for new HP
 laptops
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b0ad4ff35d479a46a3b995a299db9aeb097acfce upstream.

The DriveGuard chips on the new HP laptops are with a new PnP ID
"HPQ6007".  It should be compatible with older chips.

Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/hp_accel.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -77,6 +77,7 @@ static inline void delayed_sysfs_set(str
 static struct acpi_device_id lis3lv02d_device_ids[] = {
 	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
 	{"HPQ6000", 0}, /* HP Mobile Data Protection System PNP */
+	{"HPQ6007", 0}, /* HP Mobile Data Protection System PNP */
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);

