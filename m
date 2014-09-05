Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaIEOT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:19:56 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:63211 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaIEOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:19:52 -0400
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: m.chehab@samsung.com, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, mark.rutland@arm.com,
        lars@metafoo.de,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH 2/2] adv7604: Add DT parsing support
Date: Fri,  5 Sep 2014 16:19:33 +0200
Message-Id: <1409926773-30696-2-git-send-email-jean-michel.hautbois@vodalys.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409926773-30696-1-git-send-email-jean-michel.hautbois@vodalys.com>
References: <1409926773-30696-1-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows specifying I²C secodnary addresses different from default ones.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 8336c02..75613a4 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2705,6 +2705,7 @@ MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
 
 static struct of_device_id adv7604_of_id[] __maybe_unused = {
 	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
+	{ .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, adv7604_of_id);
-- 
2.0.4

