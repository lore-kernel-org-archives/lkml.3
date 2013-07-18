Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab3GRKT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:19:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44423 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758489Ab3GRKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:19:54 -0400
From: Oleksandr Kravchenko <x0199363@ti.com>
To: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <jic23@cam.ac.uk>, <pmeerw@pmeerw.net>, <holler@ahsoftware.de>,
        <srinivas.pandruvada@intel.com>, <devicetree-discuss@lists.ozlabs.org>,
        <grygorii.strashko@ti.com>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: [PATCH 2/3] of: Add Avago Technologies vendor prefix
Date: Thu, 18 Jul 2013 13:19:25 +0300
Message-ID: <1374142766-29736-2-git-send-email-x0199363@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374142766-29736-1-git-send-email-x0199363@ti.com>
References: <1374142766-29736-1-git-send-email-x0199363@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>

This commit adds a device tree vendor prefix for Avago Technologies.

Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index d5a79ca..8aab9c6 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -11,6 +11,7 @@ amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
 apm	Applied Micro Circuits Corporation (APM)
 arm	ARM Ltd.
 atmel	Atmel Corporation
+avago	Avago Technologies
 bosch	Bosch Sensortec GmbH
 brcm	Broadcom Corporation
 cavium	Cavium, Inc.
-- 
1.7.9.5

