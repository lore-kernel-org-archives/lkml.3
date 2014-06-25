Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbaFYRLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:11:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55604 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713AbaFYRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:11:46 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Javi Merino <javi.merino@arm.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH TRIVIAL] thermal: cpu_cooling: fix typo highjack -> hijack
Date: Wed, 25 Jun 2014 18:11:17 +0100
Message-Id: <1403716277-1351-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 25 Jun 2014 17:11:32.0859 (UTC) FILETIME=[8341CCB0:01CF9098]
X-MC-Unique: 114062518114403101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s5PHBtGr010247

Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 drivers/thermal/cpu_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 84a75f89bf74..1ab0018271c5 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -305,7 +305,7 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
  * @event: value showing cpufreq event for which this function invoked.
  * @data: callback-specific data
  *
- * Callback to highjack the notification on cpufreq policy transition.
+ * Callback to hijack the notification on cpufreq policy transition.
  * Every time there is a change in policy, we will intercept and
  * update the cpufreq policy with thermal constraints.
  *
-- 
1.9.1


