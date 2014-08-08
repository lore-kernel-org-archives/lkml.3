Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbaHHUy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:54:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41431 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbaHHUyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 103/259] parisc: add serial ports of C8000/1GHz machine to hardware database
Date: Fri,  8 Aug 2014 13:38:46 -0700
Message-Id: <1407530482-4483-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit eadcc7208a2237016be7bdff4551ba7614da85c8 upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/parisc/kernel/hardware.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/hardware.c b/arch/parisc/kernel/hardware.c
index 608716f..af3bc35 100644
--- a/arch/parisc/kernel/hardware.c
+++ b/arch/parisc/kernel/hardware.c
@@ -1210,7 +1210,8 @@ static struct hp_hardware hp_hardware_list[] = {
 	{HPHW_FIO, 0x004, 0x00320, 0x0, "Metheus Frame Buffer"}, 
 	{HPHW_FIO, 0x004, 0x00340, 0x0, "BARCO CX4500 VME Grphx Cnsl"}, 
 	{HPHW_FIO, 0x004, 0x00360, 0x0, "Hughes TOG VME FDDI"}, 
-	{HPHW_FIO, 0x076, 0x000AD, 0x00, "Crestone Peak RS-232"},
+	{HPHW_FIO, 0x076, 0x000AD, 0x0, "Crestone Peak Core RS-232"},
+	{HPHW_FIO, 0x077, 0x000AD, 0x0, "Crestone Peak Fast? Core RS-232"},
 	{HPHW_IOA, 0x185, 0x0000B, 0x00, "Java BC Summit Port"}, 
 	{HPHW_IOA, 0x1FF, 0x0000B, 0x00, "Hitachi Ghostview Summit Port"}, 
 	{HPHW_IOA, 0x580, 0x0000B, 0x10, "U2-IOA BC Runway Port"}, 
-- 
1.9.1

