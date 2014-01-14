Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaANKG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:06:58 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56012 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaANKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:06:56 -0500
From: Unai Uribarri <unaiur@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Unai Uribarri <unaiur@gmail.com>
Subject: [PATCH] toshiba_acpi: Support RFKILL hotkey scancode
Date: Tue, 14 Jan 2014 11:06:47 +0100
Message-Id: <1389694007-8342-1-git-send-email-unaiur@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This scancode is used in new 2013 models like Satellite P75-A7200.

Signed-off-by: Unai Uribarri <unaiur@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 7fce391..5d23ca2 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -151,6 +151,7 @@ static const struct acpi_device_id toshiba_device_ids[] = {
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
 
 static const struct key_entry toshiba_acpi_keymap[] = {
+	{ KE_KEY, 0x9e, { KEY_RFKILL } },
 	{ KE_KEY, 0x101, { KEY_MUTE } },
 	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
 	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
-- 
1.7.9.5

