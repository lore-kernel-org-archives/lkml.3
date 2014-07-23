Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbaGWVUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:20:17 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:38150 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932921AbaGWVUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:20:14 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH 1/6] openrisc: add Kconfig for l.lwa and l.swa atomic instructions
Date: Thu, 24 Jul 2014 00:18:11 +0300
Message-Id: <1406150296-13308-2-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all OpenRISC cpus have support for the l.lwa and l.swa,
this adds a config knob to opt them in and out.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/Kconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 848bf96..e8065a3 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -103,6 +103,13 @@ config OPENRISC_HAVE_INST_DIV
 	default y
 	help
 	  Select this if your implementation has a hardware divide instruction
+
+config OPENRISC_HAVE_INST_LWA_SWA
+	bool "Have instruction l.lwa and l.swa"
+	help
+	  Select this if your implementation have l.lwa and l.swa atomic
+	  instructions.
+
 endmenu
 
 
-- 
1.8.3.2

