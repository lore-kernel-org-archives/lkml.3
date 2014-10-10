Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaJJJNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:13:23 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46409 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaJJJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:13:20 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Honeyman <stevenhoneyman@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] i8k: Add support for Dell Latitude E6440
Date: Fri, 10 Oct 2014 11:12:47 +0200
Message-Id: <1412932368-24082-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dell Latitude E6440 needs same settings as E6540.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 34174d0..471f985 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -711,6 +711,14 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
 	},
 	{
+		.ident = "Dell Latitude E6440",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6440"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_E6540],
+	},
+	{
 		.ident = "Dell Latitude E6540",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-- 
1.7.9.5

