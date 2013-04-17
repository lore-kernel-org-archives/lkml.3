Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966250Ab3DQRWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:22:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53751 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461Ab3DQRWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:22:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/30] MAINTAINERS: update thermal entry by adding file cpu_cooling.h
Date: Wed, 17 Apr 2013 13:12:21 -0400
Message-ID: <1366218743-20841-29-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpu_cooling.h to thermal entry in MAINTAINERS.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05dd187..3e075dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8011,6 +8011,7 @@ T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
 S:      Supported
 F:      drivers/thermal/
 F:      include/linux/thermal.h
+F:      include/linux/cpu_cooling.h
 
 THINGM BLINK(1) USB RGB LED DRIVER
 M:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
-- 
1.8.2.1.342.gfa7285d

