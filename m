Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaKXP6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:58:48 -0500
Received: from hosting.pavoucek.net ([46.28.107.168]:60865 "EHLO
	hosting.pavoucek.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaKXP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:58:44 -0500
From: Tomas Novotny <tomas@novotny.cz>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Novotny <tomas@novotny.cz>
Subject: [PATCH 2/4] of: add vendor prefix for Pericom Technology
Date: Mon, 24 Nov 2014 16:49:22 +0100
Message-Id: <1416844164-16782-3-git-send-email-tomas@novotny.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
References: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index a344ec2..8ebd82f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -112,6 +112,7 @@ nxp	NXP Semiconductors
 onnn	ON Semiconductor Corp.
 opencores	OpenCores.org
 panasonic	Panasonic Corporation
+pericom	Pericom Technology Inc.
 phytec	PHYTEC Messtechnik GmbH
 picochip	Picochip Ltd
 plathome	Plat'Home Co., Ltd.
-- 
2.1.2

