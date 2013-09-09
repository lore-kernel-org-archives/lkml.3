Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3IIPys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:54:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab3IIPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:09 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 1/2] DT: add a vendor prefix for Dialog Semiconductor
Date: Mon,  9 Sep 2013 17:51:59 +0200
Message-Id: <1378741920-11085-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378741920-11085-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378741920-11085-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:RMtoS4dPlSqwRHPSx2PWE2dhDBHixdqKBmwwCvKyrZG
 sNOumtWB/dU2Ciqz9yHDO3CokkZSzZ6+uDwJxbNSmdnTuBUohJ
 4W5d+93VFoxYP9HyNoUi3/flpujitOb8r25IAFwoYEV7us/gZb
 sUnrhuMda4nJAYu8W8QlOUWojWk7YswZekAoZjp9W5iwU2zZKZ
 /W83BXwA4WFX6wFmH88yDLcOqo2TUiMmTbsBKhqc1x8dzBVf7a
 Z+s+4i1+qmLu5gdPctVNsrSb9gdUWJNAv/P4F9fCDHqIx7z0Xn
 Jf4g/8vA8roiRQpbRXUJza0+FPC97O2BCVGIc1NU4d0kbVZG9Y
 qRY6x71v4dAVIjhc+1wZs0rauah+DoOqZGWzOUwZTfxvcZ7YaU
 JiGGaalhRKF3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a commonly used "diasemi" prefix for Dialog Semiconductor PLC.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2956800..f8d5a75 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -22,6 +22,7 @@ cortina	Cortina Systems, Inc.
 dallas	Maxim Integrated Products (formerly Dallas Semiconductor)
 davicom	DAVICOM Semiconductor, Inc.
 denx	Denx Software Engineering
+diasemi	Dialog Semiconductor
 emmicro	EM Microelectronic
 epson	Seiko Epson Corp.
 est	ESTeem Wireless Modems
-- 
1.7.2.5

