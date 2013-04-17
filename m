Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966989Ab3DQWnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:43:02 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:39291 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966905Ab3DQWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:42:37 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 1/2] intel_idle: additional Haswell CPU-id
Date: Wed, 17 Apr 2013 18:42:16 -0400
Message-Id: <0b15841b0bbbde75134a777c543dc51fe6187108.1366238380.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.2.1.422.gdcd8c09
In-Reply-To: <1366238537-14443-1-git-send-email-lenb@kernel.org>
References: <1366238537-14443-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

There is an additional HSW CPU-id, 0x46,
which has C-states exactly like CPU-id 0x45.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d66750..1a38dd7 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -465,6 +465,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x3c, idle_cpu_hsw),
 	ICPU(0x3f, idle_cpu_hsw),
 	ICPU(0x45, idle_cpu_hsw),
+	ICPU(0x46, idle_cpu_hsw),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
-- 
1.8.2.1.422.gdcd8c09

