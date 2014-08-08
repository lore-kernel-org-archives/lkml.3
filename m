Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaHHSUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:20:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58518 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaHHSUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:20:46 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
        <gregkh@linuxfoundation.org>, <galak@codeaurora.org>, <olof@lixom.net>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>, <arnd@arndb.de>,
        <sandeep_n@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [Patch v3 6/6] MAINTAINERS: Add Keystone Multicore Navigator drivers entry
Date: Fri, 8 Aug 2014 14:19:45 -0400
Message-ID: <1407521985-22574-7-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407521985-22574-1-git-send-email-santosh.shilimkar@ti.com>
References: <1407521985-22574-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2066f4..e5b1179 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9051,6 +9051,15 @@ F:	drivers/misc/tifm*
 F:	drivers/mmc/host/tifm_sd.c
 F:	include/linux/tifm.h
 
+TI KEYSTONE MULTICORE NAVIGATOR DRIVERS
+M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+L:	linux-kernel@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/soc/ti/*
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
+
+
 TI LM49xxx FAMILY ASoC CODEC DRIVERS
 M:	M R Swami Reddy <mr.swami.reddy@ti.com>
 M:	Vishwas A Deshpande <vishwas.a.deshpande@ti.com>
-- 
1.7.9.5

