Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaAMQ1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:27:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaAMQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Hung <alex.hung@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 139/208] dell-wmi: Add KEY_MICMUTE to bios_to_linux_keycode
Date: Mon, 13 Jan 2014 15:59:40 +0000
Message-Id: <1389628849-1614-140-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

commit cfb743bf6173063b57ef5a8185ea87f130209d4d upstream.

Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/x86/dell-wmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index fa9a217..60e0900 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -130,7 +130,8 @@ static const u16 bios_to_linux_keycode[256] __initconst = {
 	KEY_BRIGHTNESSUP,	KEY_UNKNOWN,	KEY_KBDILLUMTOGGLE,
 	KEY_UNKNOWN,	KEY_SWITCHVIDEOMODE,	KEY_UNKNOWN, KEY_UNKNOWN,
 	KEY_SWITCHVIDEOMODE,	KEY_UNKNOWN,	KEY_UNKNOWN, KEY_PROG2,
-	KEY_UNKNOWN, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	KEY_UNKNOWN,	KEY_UNKNOWN,	KEY_UNKNOWN,	KEY_UNKNOWN,
+	KEY_UNKNOWN,	KEY_UNKNOWN,	KEY_UNKNOWN,	KEY_MICMUTE,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
@@ -139,8 +140,8 @@ static const u16 bios_to_linux_keycode[256] __initconst = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	KEY_PROG3
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, KEY_PROG3
 };
 
 static struct input_dev *dell_wmi_input_dev;
-- 
1.8.3.2

