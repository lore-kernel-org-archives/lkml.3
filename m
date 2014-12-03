Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaLCHGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:06:40 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61146 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaLCHGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:06:37 -0500
From: gyungoh@gmail.com
X-Google-Original-From: jack.yoo@skyworksinc.com
To: sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, jg1.han@samsung.com, cooloney@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        trivial@kernel.org
Cc: akpm@linux-foundation.org, jic23@kernel.org,
        thomas.petazzoni@free-electrons.com, ktsai@capellamicro.com,
        hs@denx.de, stwiss.opensource@diasemi.com, matti.vaittinen@nsn.com,
        broonie@kernel.org, jason@lakedaemon.net, heiko@sntech.de,
        shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch,
        antonynpavlov@gmail.com, hytszk@gmail.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, jack.yoo@skyworksinc.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v10 5/6] devicetree: Add vendor prefix for Skyworks Solutions, Inc.
Date: Wed,  3 Dec 2014 16:05:31 +0900
Message-Id: <1417590332-4912-6-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417590332-4912-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1417590332-4912-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
Changes v10:
Nothing

Changes v9:
Nothing

Changes v8:
Nothing

Changes v7:
Nothing

Changes v6:
Nothing

Changes v5:
Nothing

Changes v4:
Nothing

Changes v3:
Nothing

Changes v2:
Added vendor prefix for Skyworks Solutions, Inc.

 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index a344ec2..68143f0 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -140,6 +140,7 @@ sii	Seiko Instruments, Inc.
 silergy	Silergy Corp.
 sirf	SiRF Technology, Inc.
 sitronix	Sitronix Technology Corporation
+skyworks	Skyworks Solutions, Inc.
 smsc	Standard Microsystems Corporation
 snps	Synopsys, Inc.
 solidrun	SolidRun
-- 
1.9.1

