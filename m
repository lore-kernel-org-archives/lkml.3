Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaCDCQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:16:01 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42374 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbaCDCP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:15:58 -0500
From: Graeme Gregory <graeme.gregory@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, grant.likely@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org,
        rjw@rjwysocki.net, Graeme Gregory <graeme.gregory@linaro.org>
Subject: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
Date: Tue,  4 Mar 2014 10:15:45 +0800
Message-Id: <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add maintainers for the arm-core file for arm64 ACPI support

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6d0e93..c770d3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -259,6 +259,13 @@ F:	drivers/pci/*/*acpi*
 F:	drivers/pci/*/*/*acpi*
 F:	tools/power/acpi
 
+ACPI ARM64
+M:	Hanjun Guo <hanjun.guo@linaro.org>
+M:	Graeme Gregory <graeme.gregory@linaro.org>
+S:	Supported
+L:	linux-acpi@vger.kernel.org
+F:	drivers/acpi/plat/arm-core.c
+
 ACPI COMPONENT ARCHITECTURE (ACPICA)
 M:	Robert Moore <robert.moore@intel.com>
 M:	Lv Zheng <lv.zheng@intel.com>
-- 
1.9.0

