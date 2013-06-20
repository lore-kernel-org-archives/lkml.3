Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3FTI7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:59:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab3FTI7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:59:02 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Rob Landley <rob@landley.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH] Documentation / cpu hotplug: remove outdated description for MADT entries
Date: Thu, 20 Jun 2013 16:54:42 +0800
Message-Id: <1371718482-452-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More than 256 entries in ACPI MADT is supported from ACPI 3.0 Specification,
So the outdated description for MADT entries should be removed.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 Documentation/cpu-hotplug.txt |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 9f40135..2e36e40 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -370,9 +370,6 @@ A: There is no clear spec defined way from ACPI that can give us that
    CPUs in MADT as hotpluggable CPUS.  In the case there are no disabled CPUS
    we assume 1/2 the number of CPUs currently present can be hotplugged.
 
-   Caveat: Today's ACPI MADT can only provide 256 entries since the apicid field
-   in MADT is only 8 bits.
-
 User Space Notification
 
 Hotplug support for devices is common in Linux today. Its being used today to
-- 
1.7.9.5

