Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaCKKEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:04:37 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:60111 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaCKKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:04:35 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] PM: Add missing "freeze" state
Date: Tue, 11 Mar 2014 11:04:30 +0100
Message-Id: <1394532270-4101-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 Documentation/ABI/testing/sysfs-power |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
index 205a73878441..64c9276e9421 100644
--- a/Documentation/ABI/testing/sysfs-power
+++ b/Documentation/ABI/testing/sysfs-power
@@ -12,8 +12,9 @@ Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
 		The /sys/power/state file controls the system power state.
 		Reading from this file returns what states are supported,
-		which is hard-coded to 'standby' (Power-On Suspend), 'mem'
-		(Suspend-to-RAM), and 'disk' (Suspend-to-Disk).
+		which is hard-coded to 'freeze' (Low-Power Idle), 'standby'
+		(Power-On Suspend), 'mem' (Suspend-to-RAM), and 'disk'
+		(Suspend-to-Disk).
 
 		Writing to this file one of these strings causes the system to
 		transition into that state. Please see the file
-- 
1.7.9.5

