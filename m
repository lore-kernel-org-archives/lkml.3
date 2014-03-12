Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaCLR4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:56:47 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:47814 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbaCLRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:55:48 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v3 3/3] MAINTAINERS: add xtfpga platform section
Date: Wed, 12 Mar 2014 21:55:26 +0400
Message-Id: <1394646926-30496-4-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394646926-30496-1-git-send-email-jcmvbkbc@gmail.com>
References: <1394646926-30496-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This section will list xtfpga platform-specific drivers.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6d0e93..9f75849 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9768,6 +9768,12 @@ L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/tty/serial/uartlite.c
 
+XTENSA XTFPGA PLATFORM SUPPORT
+M:	Max Filippov <jcmvbkbc@gmail.com>
+L:	linux-xtensa@linux-xtensa.org
+S:	Maintained
+F:	drivers/spi/spi-xtensa-xtfpga.c
+
 YAM DRIVER FOR AX.25
 M:	Jean-Paul Roubelat <jpr@f6fbb.org>
 L:	linux-hams@vger.kernel.org
-- 
1.8.1.4

