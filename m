Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaEGOcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:32:39 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54478 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaEGOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:32:37 -0400
From: Luis Ortega <luiorpe1@gmail.com>
To: pe1dnn@amsat.org
Cc: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        josh@joshtriplett.org, archanakumari959@gmail.com,
        paulmck@linux.vnet.ibm.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Luis Ortega <luiorpe1@gmail.com>
Subject: [PATCH] staging: wlags49_h2: fix sparse warning "should it be static"
Date: Wed,  7 May 2014 18:31:48 +0200
Message-Id: <1399480308-15869-1-git-send-email-luiorpe1@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following warning:
drivers/staging/wlags49_h2/sta_h2.c:4471:10: warning: symbol 'fw_image' was not declared. Should it be static?

Signed-off-by: Luis Ortega <luiorpe1@gmail.com>
---
 drivers/staging/wlags49_h2/sta_h2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/sta_h2.c b/drivers/staging/wlags49_h2/sta_h2.c
index 0ba8def..2838faa 100644
--- a/drivers/staging/wlags49_h2/sta_h2.c
+++ b/drivers/staging/wlags49_h2/sta_h2.c
@@ -4468,7 +4468,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
 	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }	/* endsentinel */
 };

-memimage fw_image = {
+static memimage fw_image = {
 	"FUPU7D37dhfwci\001C",			/* signature, <format number>, C/Bin type */
 	(CFG_PROG_STRCT *) fw_image_code,
 	0x000F368E,
--
1.9.2

