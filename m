Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaGVPNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:13:43 -0400
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:43589
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaGVPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:13:42 -0400
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH] Documentation/arm64/memory.txt: fix typo
Date: Tue, 22 Jul 2014 16:14:42 +0100
Message-Id: <1406042082-1519-1-git-send-email-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no swapper_pgd_dir, it meant swapper_pg_dir.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 Documentation/arm64/memory.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index d50fa61..dd724c8 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -17,7 +17,7 @@ User addresses have bits 63:39 set to 0 while the kernel addresses have
 the same bits set to 1. TTBRx selection is given by bit 63 of the
 virtual address. The swapper_pg_dir contains only kernel (global)
 mappings while the user pgd contains only user (non-global) mappings.
-The swapper_pgd_dir address is written to TTBR1 and never written to
+The swapper_pg_dir address is written to TTBR1 and never written to
 TTBR0.
 
 
-- 
2.0.2

