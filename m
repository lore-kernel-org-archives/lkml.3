Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3LQQZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:25:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3LQQZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:25:10 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 02/10] arm: select ARCH_MIGHT_HAVE_PC_SERIO
Date: Tue, 17 Dec 2013 10:48:45 -0500
Message-Id: <1387295333-24684-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1387295333-24684-1-git-send-email-msalter@redhat.com>
References: <1387295333-24684-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-footbridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index 0f2111a..d0fb921 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -85,6 +85,7 @@ config FOOTBRIDGE
 # Footbridge in host mode
 config FOOTBRIDGE_HOST
 	bool
+        select ARCH_MIGHT_HAVE_PC_SERIO
 
 # Footbridge in addin mode
 config FOOTBRIDGE_ADDIN
-- 
1.8.3.1

