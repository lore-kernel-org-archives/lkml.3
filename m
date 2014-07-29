Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaG2Rot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:44:49 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:64180 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaG2Ros (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:44:48 -0400
From: fernando.apesteguia@gmail.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fernando Apesteguia <fernando.apesteguia@gmail.com>
Subject: [PATCH] staging: vt6655: Fix device table definition.
Date: Tue, 29 Jul 2014 19:44:24 +0200
Message-Id: <1406655864-8694-1-git-send-email-fernando.apesteguia@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Apesteguia <fernando.apesteguia@gmail.com>

Add static to the definition of the pci device table.

Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
---
 drivers/staging/vt6655/device_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1d3908d..99a1f97 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -260,7 +260,7 @@ static CHIP_INFO chip_info_table[] = {
 	{0, NULL}
 };
 
-const struct pci_device_id vt6655_pci_id_table[] = {
+static const struct pci_device_id vt6655_pci_id_table[] = {
 	{ PCI_VDEVICE(VIA, 0x3253), (kernel_ulong_t)chip_info_table},
 	{ 0, }
 };
-- 
1.7.9.5

