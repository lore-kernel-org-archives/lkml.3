Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3GYMUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:20:16 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:58070 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3GYMUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:20:14 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] ARC: add .gitignore files
Date: Thu, 25 Jul 2013 14:20:09 +0200
Message-Id: <1374754809-27486-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore the following files:
 * devicetree .dtb, .dtb.S files
 * vmlinux.lds

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/boot/dts/.gitignore |    2 ++
 arch/arc/kernel/.gitignore   |    1 +
 2 files changed, 3 insertions(+)
 create mode 100644 arch/arc/boot/dts/.gitignore
 create mode 100644 arch/arc/kernel/.gitignore

diff --git a/arch/arc/boot/dts/.gitignore b/arch/arc/boot/dts/.gitignore
new file mode 100644
index 0000000..1b37180
--- /dev/null
+++ b/arch/arc/boot/dts/.gitignore
@@ -0,0 +1,2 @@
+*.dtb
+*.dtb.S
diff --git a/arch/arc/kernel/.gitignore b/arch/arc/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/arc/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
-- 
1.7.9.5

