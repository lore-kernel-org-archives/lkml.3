Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3JWN2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:28:41 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:40723 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3JWN2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:28:40 -0400
From: Doug Anderson <dianders@chromium.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Don't send to devicetree list for "arch/*/boot/dts"
Date: Wed, 23 Oct 2013 06:22:00 -0700
Message-Id: <1382534520-15688-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in the ARM kernel summit, people on the devicetree list
would no longer like to receive emails about all dts changes.  Remove
from MAINTAINERS.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ebaf8bd..0166e8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5987,7 +5987,6 @@ OMAP DEVICE TREE SUPPORT
 M:	Benoît Cousson <bcousson@baylibre.com>
 M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
-L:	devicetree@vger.kernel.org
 S:	Maintained
 F:	arch/arm/boot/dts/*omap*
 F:	arch/arm/boot/dts/*am3*
@@ -6167,7 +6166,6 @@ M:	Ian Campbell <ijc+devicetree@hellion.org.uk>
 L:	devicetree@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/
-F:	arch/*/boot/dts/
 F:	include/dt-bindings/
 
 OPENRISC ARCHITECTURE
-- 
1.8.4

