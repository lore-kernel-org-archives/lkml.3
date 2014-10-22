Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaJVGJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:09:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57955 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaJVGH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:07:59 -0400
From: Mike Turquette <mturquette@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Mike Turquette <mturquette@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH RFC 4/7] cpufreq: add per-governor private data
Date: Tue, 21 Oct 2014 23:07:28 -0700
Message-Id: <1413958051-7103-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 include/linux/cpufreq.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 138336b..91d173c 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -115,6 +115,9 @@ struct cpufreq_policy {
 
 	/* For cpufreq driver's internal use */
 	void			*driver_data;
+
+	/* For cpufreq governor's internal use */
+	void			*gov_data;
 };
 
 /* Only for ACPI */
-- 
1.8.3.2

