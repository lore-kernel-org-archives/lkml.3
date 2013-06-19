Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888Ab3FSVi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:38:28 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45356 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935063Ab3FSVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:37:38 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v2 4/4] MIPS: Update cavium_octeon_defconfig
Date: Wed, 19 Jun 2013 14:37:29 -0700
Message-Id: <1371677849-23912-5-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371677849-23912-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371677849-23912-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The serial port changes make it advisable to enable the proper UART
drivers.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/configs/cavium_octeon_defconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/mips/configs/cavium_octeon_defconfig b/arch/mips/configs/cavium_octeon_defconfig
index 1888e5f..dace582 100644
--- a/arch/mips/configs/cavium_octeon_defconfig
+++ b/arch/mips/configs/cavium_octeon_defconfig
@@ -1,13 +1,11 @@
 CONFIG_CAVIUM_OCTEON_SOC=y
 CONFIG_CAVIUM_CN63XXP1=y
 CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE=2
-CONFIG_SPARSEMEM_MANUAL=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=32
 CONFIG_HZ_100=y
 CONFIG_PREEMPT=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -50,7 +48,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 # CONFIG_MTD_OF_PARTS is not set
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
@@ -114,6 +111,7 @@ CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_NR_UARTS=2
 CONFIG_SERIAL_8250_RUNTIME_UARTS=2
+CONFIG_SERIAL_8250_DW=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_I2C=y
 CONFIG_I2C_OCTEON=y
-- 
1.7.11.7

