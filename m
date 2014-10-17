Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJQWSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 18:18:05 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47492 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaJQWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 18:18:03 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Honeyman <stevenhoneyman@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] i8k: Add MODULE_DEVICE_TABLE macro
Date: Sat, 18 Oct 2014 00:17:49 +0200
Message-Id: <1413584269-19014-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MODULE_DEVICE_TABLE macro so i8k.ko module can be automatically
loaded based on dmi system alias.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 471f985..7272b08 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -796,6 +796,8 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 	{ }
 };
 
+MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
+
 /*
  * Probe for the presence of a supported laptop.
  */
-- 
1.7.9.5

