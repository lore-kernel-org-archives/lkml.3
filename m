Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161941Ab3BONBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:01:43 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:40355 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761700Ab3BOM6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:08 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/35] mfd: ab8500: Remove unnecessary 'struct device' declaration
Date: Fri, 15 Feb 2013 12:56:55 +0000
Message-Id: <1360933026-30325-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch saw the device.h include being removed from some other
include files and replaced with a 'struct device' declaration instead.
However, neither the include nor the declaration is actually required.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/abx500.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index bd480b2..cb3288b 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -13,8 +13,6 @@
 
 #include <linux/regulator/machine.h>
 
-struct device;
-
 #ifndef MFD_ABX500_H
 #define MFD_ABX500_H
 
-- 
1.7.10.4

