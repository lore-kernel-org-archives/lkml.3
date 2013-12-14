Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3LNRAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:00:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab3LNRAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:00:00 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 03/10] ia64: select ARCH_MIGHT_HAVE_PC_SERIO
Date: Sat, 14 Dec 2013 11:59:29 -0500
Message-Id: <1387040376-26906-4-git-send-email-msalter@redhat.com>
In-Reply-To: <1387040376-26906-1-git-send-email-msalter@redhat.com>
References: <1387040376-26906-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
CC: linux-ia64@vger.kernel.org
---
 arch/ia64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 4e4119b..f7337aa 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -7,6 +7,7 @@ menu "Processor type and features"
 config IA64
 	bool
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_MIGHT_HAVE_PC_SERIO
 	select PCI if (!IA64_HP_SIM)
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
-- 
1.8.3.1

