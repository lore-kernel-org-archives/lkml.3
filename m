Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaEHT5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:57:50 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43810 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaEHT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:57:48 -0400
X-Google-Original-From: dirk.j.brandewie@intel.com
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, dirk.brandewie@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 5/5] intel_pstate: Add CPU IDs for Broadwell processors
Date: Thu,  8 May 2014 12:57:27 -0700
Message-Id: <1399579047-5792-6-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Add support the Broadwell processors.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 4c26faf..6ef6f7f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -663,10 +663,13 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x37, byt_params),
 	ICPU(0x3a, core_params),
 	ICPU(0x3c, core_params),
+	ICPU(0x3d, core_params),
 	ICPU(0x3e, core_params),
 	ICPU(0x3f, core_params),
 	ICPU(0x45, core_params),
 	ICPU(0x46, core_params),
+	ICPU(0x4f, core_params),
+	ICPU(0x56, core_params),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
1.9.0

