Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaCKMpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:45:52 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34596 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaCKMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:45:48 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3/3] MAINTAINERS: add xtfpga platform section
Date: Tue, 11 Mar 2014 16:44:51 +0400
Message-Id: <1394541891-26469-4-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
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

