Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaBJQXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:23:34 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38621 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaBJQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:23:30 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH] ACPI, APEI: Remove X86 redundant dependency for APEI Generic Hardware Error Source.
Date: Mon, 10 Feb 2014 17:23:36 +0100
Message-Id: <1392049416-31240-1-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI_APEI is already dependent on X86, hence, there is no need to
define such dependency for ACPI_APEI_GHES again.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/apei/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 786294b..1d7ca6e 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -13,7 +13,7 @@ config ACPI_APEI
 
 config ACPI_APEI_GHES
 	bool "APEI Generic Hardware Error Source"
-	depends on ACPI_APEI && X86
+	depends on ACPI_APEI
 	select ACPI_HED
 	select IRQ_WORK
 	select GENERIC_ALLOCATOR
-- 
1.7.9.5

