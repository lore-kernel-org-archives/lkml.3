Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaFTTm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:42:57 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57239 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbaFTTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:42:54 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 4/4] thunderbolt: Make tb_eeprom_get_drom_offset static
Date: Fri, 20 Jun 2014 21:42:25 +0200
Message-Id: <1403293345-20772-4-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403293345-20772-1-git-send-email-andreas.noever@gmail.com>
References: <1403293345-20772-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tb_eeprom_get_drom_offset is local to this file.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 71f719b..0dde34e 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -233,7 +233,7 @@ struct tb_drom_entry_port {
 /**
  * tb_eeprom_get_drom_offset - get drom offset within eeprom
  */
-int tb_eeprom_get_drom_offset(struct tb_switch *sw, u16 *offset)
+static int tb_eeprom_get_drom_offset(struct tb_switch *sw, u16 *offset)
 {
 	struct tb_cap_plug_events cap;
 	int res;
-- 
2.0.0

