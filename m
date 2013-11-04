Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3KDJcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:32:42 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33156 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752209Ab3KDJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:32:41 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: chris@zankel.net, jcmvbkbc@gmail.com
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] xtensa: remove unused XTENSA_ISS_NETWORK Kconfig parameter
Date: Mon,  4 Nov 2013 10:32:33 +0100
Message-Id: <1383557553-4762-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the XTENSA_ISS_NETWORK Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/xtensa/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 8d24dcb7cdac..148bca34dfbc 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -150,9 +150,6 @@ config XTENSA_CALIBRATE_CCOUNT
 config SERIAL_CONSOLE
 	def_bool n
 
-config XTENSA_ISS_NETWORK
-	def_bool n
-
 menu "Bus options"
 
 config PCI
@@ -179,7 +176,6 @@ config XTENSA_PLATFORM_ISS
 	depends on TTY
 	select XTENSA_CALIBRATE_CCOUNT
 	select SERIAL_CONSOLE
-	select XTENSA_ISS_NETWORK
 	help
 	  ISS is an acronym for Tensilica's Instruction Set Simulator.
 
-- 
1.8.1.2

