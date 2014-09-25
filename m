Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaIYGck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:32:40 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:42161 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaIYGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:32:38 -0400
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mfd: tps65217: add compatible string for subdevices
Date: Thu, 25 Sep 2014 08:31:42 +0200
Message-ID: <3292130.zy6yLkolne@lenovobook>
User-Agent: KMail/4.14 (Linux/3.16.3-1-ARCH; KDE/4.14.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds of_compatible strings to mfd_cells for sub devices of the tps65217.

Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
---
 drivers/mfd/tps65217.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 3cc4c70..77708f9 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -33,9 +33,11 @@
 static const struct mfd_cell tps65217s[] = {
 	{
 		.name = "tps65217-pmic",
+		.of_compatible = "ti,tps65217-pmic",
 	},
 	{
 		.name = "tps65217-bl",
+		.of_compatible = "ti,tps65217-bl",
 	},
 };
 
-- 
2.1.0
