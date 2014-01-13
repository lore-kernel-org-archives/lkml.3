Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaAMO0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:26:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51201 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaAMOZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Len Brown <len.brown@intel.com>, Vinson Lee <vlee@twopensource.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 12/96] intel_idle: enable IVB Xeon support
Date: Mon, 13 Jan 2014 14:23:35 +0000
Message-Id: <1389623099-18783-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

commit 23795e580cad5d6b73d47d51b9074ce3e58bf334 upstream.

IVB Xeon currently shares the same parameters IVB client.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/idle/intel_idle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 377ec9a..674e352 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -399,6 +399,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x2a, idle_cpu_snb),
 	ICPU(0x2d, idle_cpu_snb),
 	ICPU(0x3a, idle_cpu_ivb),
+	ICPU(0x3e, idle_cpu_ivb),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
-- 
1.8.3.2

