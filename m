Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbbAIAAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:00:19 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64171 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbbAIAAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:00:05 -0500
From: Moritz Fischer <moritz.fischer@ettus.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moritz Fischer <moritz.fischer@ettus.com>
Subject: [PATCH v3 3/3] Update MAINTAINERS file with e3x0-button info.
Date: Fri,  9 Jan 2015 00:59:31 +0100
Message-Id: <1420761571-22903-4-git-send-email-moritz.fischer@ettus.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420761571-22903-1-git-send-email-moritz.fischer@ettus.com>
References: <1420761571-22903-1-git-send-email-moritz.fischer@ettus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Moritz Fischer <moritz.fischer@ettus.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..65358d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3466,6 +3466,14 @@ M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/tty/serial/dz.*
 
+E3X0 POWER BUTTON DRIVER
+M:	Moritz Fischer <moritz.fischer@ettus.com>
+L:	usrp-users@lists.ettus.com
+W:	http://www.ettus.com
+S:	Supported
+F:	drivers/input/misc/e3x0-button.c
+F:	Documentation/devicetree/bindings/input/e3x0-button.txt
+
 E4000 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-- 
1.9.3

