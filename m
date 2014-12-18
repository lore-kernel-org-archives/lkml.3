Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaLRByY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:54:24 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49996 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaLRByX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:54:23 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: arnd@arndb.de
Cc: gregkh@linuxfoundation.org, michael.hennerich@analog.com,
        linux-kernel@vger.kernel.org,
        Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Subject: [PATCH] ad525x_dpot-spi: Added Blank lines after declarations
Date: Thu, 18 Dec 2014 07:24:11 +0530
Message-Id: <1418867651-5511-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves the blank line warning of checkpatch.pl

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 drivers/misc/ad525x_dpot-spi.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
index 9da04ed..f4c82ea 100644
--- a/drivers/misc/ad525x_dpot-spi.c
+++ b/drivers/misc/ad525x_dpot-spi.c
@@ -15,18 +15,21 @@
 static int write8(void *client, u8 val)
 {
 	u8 data = val;
+
 	return spi_write(client, &data, 1);
 }
 
 static int write16(void *client, u8 reg, u8 val)
 {
 	u8 data[2] = {reg, val};
+
 	return spi_write(client, data, 2);
 }
 
 static int write24(void *client, u8 reg, u16 val)
 {
 	u8 data[3] = {reg, val >> 8, val};
+
 	return spi_write(client, data, 3);
 }
 
@@ -34,6 +37,7 @@ static int read8(void *client)
 {
 	int ret;
 	u8 data;
+
 	ret = spi_read(client, &data, 1);
 	if (ret < 0)
 		return ret;
-- 
1.7.9.5

