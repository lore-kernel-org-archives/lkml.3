Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaKQTzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:55:32 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:60730 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKQTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:55:31 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Enable cgroups
Date: Mon, 17 Nov 2014 11:55:07 -0800
Message-Id: <1416254107-29326-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.3.1.ge241007
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows booting the kernel with systemd-based root file systems.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi,

I don't know whether I'm the only one, but I use a initramfs with
systemd as init, which requires cgroup support in the kernel to fully
boot.

	Thanks,
	Sören
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 3487046d8a78..2dd723e63c35 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -3,6 +3,7 @@ CONFIG_FHANDLE=y
 CONFIG_IRQ_DOMAIN_DEBUG=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_CGROUPS=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EMBEDDED=y
 CONFIG_PERF_EVENTS=y
-- 
2.1.3.1.ge241007

