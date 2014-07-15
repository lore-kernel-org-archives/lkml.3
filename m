Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbaGORIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:08:34 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58662 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaGORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:19 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Helge Deller <deller@gmx.de>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 84/94] parisc: add serial ports of C8000/1GHz machine to hardware database
Date: Tue, 15 Jul 2014 20:01:39 +0300
Message-Id: <1405443709-15288-84-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helge Deller <deller@gmx.de>

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 3.13+
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/parisc/kernel/hardware.c |    3 ++-
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
1.7.10.4

