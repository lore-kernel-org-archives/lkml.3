Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3CTMLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:11:00 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48239 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044Ab3CTMKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:10:52 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: santosh.shilimkar@ti.com, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 09/10] gpio: gpio-timberdale.c: fix checkpatch error
Date: Wed, 20 Mar 2013 13:16:03 +0100
Message-Id: <1363781764-17330-10-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
References: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix :
 gpio/gpio-timberdale.c:171: ERROR: else should follow close brace '}'

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpio/gpio-timberdale.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index 702cca9..4377405 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -167,8 +167,7 @@ static int timbgpio_irq_type(struct irq_data *d, unsigned trigger)
 		if (ver < 3) {
 			ret = -EINVAL;
 			goto out;
-		}
-		else {
+		} else {
 			flr |= 1 << offset;
 			bflr |= 1 << offset;
 		}
-- 
1.7.10.4

