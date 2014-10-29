Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbaJ2XT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:19:58 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:46344 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856AbaJ2XTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:19:54 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 1/4] of: Add vendor prefix for MIPS Technologies, Inc.
Date: Wed, 29 Oct 2014 16:19:47 -0700
Message-Id: <1414624790-15690-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414624790-15690-1-git-send-email-abrestic@chromium.org>
References: <1414624790-15690-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the vendor prefix "mti" for MIPS Technologies, Inc.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
I'll update the users of the "mips" prefix to use "mti" instead once
this lands.

No changes from v2/v3.
New for v2.
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 0979393..0221b49 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -98,6 +98,7 @@ mitsubishi	Mitsubishi Electric Corporation
 mosaixtech	Mosaix Technologies, Inc.
 moxa	Moxa
 mpl	MPL AG
+mti	MIPS Technologies, Inc.
 mundoreader	Mundo Reader S.L.
 murata	Murata Manufacturing Co., Ltd.
 mxicy	Macronix International Co., Ltd.
-- 
2.1.0.rc2.206.gedb03e5

