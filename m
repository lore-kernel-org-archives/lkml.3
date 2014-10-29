Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbaJ2U27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:28:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46423 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaJ2U24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:28:56 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 2/4] ARM: keystone: defconfig: add options to enable PCI controller
Date: Wed, 29 Oct 2014 16:28:15 -0400
Message-ID: <1414614497-4798-3-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414614497-4798-1-git-send-email-m-karicheri2@ti.com>
References: <yes>
 <1414614497-4798-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables PCI controller driver for Keystone SoCs by
default.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 v2 - Added a description in the commit log per comment
 v1 - fixed email ID for Santosh
 arch/arm/configs/keystone_defconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index 932ae40..40d3e9d 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -20,6 +20,9 @@ CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_ARCH_KEYSTONE=y
 CONFIG_ARM_LPAE=y
+CONFIG_PCI=y
+CONFIG_PCI_MSI=y
+CONFIG_PCI_KEYSTONE=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
-- 
1.7.9.5

