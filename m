Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3GWIjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:39:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51998 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab3GWIjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:39:46 -0400
From: Oleksandr Kravchenko <x0199363@ti.com>
To: <jic23@cam.ac.uk>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: [PATCH] Documentation: devres: add IIO device alloc/free functions to list
Date: Tue, 23 Jul 2013 11:39:35 +0300
Message-ID: <1374568775-15491-1-git-send-email-x0199363@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>

Add devm_iio_device_alloc() and devm_iio_device_free() functions
to list of supported calls.

Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
---
 Documentation/driver-model/devres.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index b467145..1d32332 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -237,6 +237,10 @@ MEM
   devm_kzalloc()
   devm_kfree()
 
+IIO
+  devm_iio_device_alloc()
+  devm_iio_device_free()
+
 IO region
   devm_request_region()
   devm_request_mem_region()
-- 
1.7.9.5

