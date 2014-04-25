Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaDYPLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:11:37 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42270 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaDYPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:11:31 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] gpio: Add missing device-managed documentation
Date: Fri, 25 Apr 2014 17:10:05 +0200
Message-Id: <1398438606-19718-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Add the GPIO-related device-managed functions to the list of functions
in Documentation/driver-model/devres.txt.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/driver-model/devres.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index a3477c3d69a2..7b7d1c4d06bf 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -310,3 +310,8 @@ SLAVE DMA ENGINE
 
 SPI
   devm_spi_register_master()
+
+GPIO
+  devm_gpiod_get()
+  devm_gpiod_get_index()
+  devm_gpiod_put()
-- 
1.9.2

