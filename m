Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946803Ab3BHRY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:24:27 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:37294 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946749Ab3BHRYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:24:25 -0500
Message-ID: <511534C2.3020103@semaphore.gr>
Date: Fri, 08 Feb 2013 19:24:18 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cpufreq: ondemand: Fix typos in comments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos in comments.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_ondemand.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 09b27ae..f3eb26c 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -26,7 +26,7 @@
 
 #include "cpufreq_governor.h"
 
-/* On-demand governor macors */
+/* On-demand governor macros */
 #define DEF_FREQUENCY_DOWN_DIFFERENTIAL		(10)
 #define DEF_FREQUENCY_UP_THRESHOLD		(80)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
@@ -66,7 +66,7 @@ static void ondemand_powersave_bias_init_cpu(int cpu)
  * efficient idling at a higher frequency/voltage is.
  * Pavel Machek says this is not so for various generations of AMD and old
  * Intel systems.
- * Mike Chan (androidlcom) calis this is also not true for ARM.
+ * Mike Chan (android.com) claims this is also not true for ARM.
  * Because of this, whitelist specific known (series) of CPUs by default, and
  * leave all others up to the user.
  */
@@ -74,7 +74,7 @@ static int should_io_be_busy(void)
 {
 #if defined(CONFIG_X86)
 	/*
-	 * For Intel, Core 2 (model 15) andl later have an efficient idle.
+	 * For Intel, Core 2 (model 15) and later have an efficient idle.
 	 */
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 			boot_cpu_data.x86 == 6 &&
@@ -159,8 +159,8 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 
 /*
  * Every sampling_rate, we check, if current idle time is less than 20%
- * (default), then we try to increase frequency Every sampling_rate, we look for
- * a the lowest frequency which can sustain the load while keeping idle time
+ * (default), then we try to increase frequency. Every sampling_rate, we look
+ * for the lowest frequency which can sustain the load while keeping idle time
  * over 30%. If such a frequency exist, we try to decrease to this frequency.
  *
  * Any frequency increase takes it to the maximum frequency. Frequency reduction
@@ -267,7 +267,7 @@ static ssize_t show_sampling_rate_min(struct kobject *kobj,
  * update_sampling_rate - update sampling rate effective immediately if needed.
  * @new_rate: new sampling rate
  *
- * If new rate is smaller than the old, simply updaing
+ * If new rate is smaller than the old, simply updating
  * dbs_tuners_int.sampling_rate might not be appropriate. For example, if the
  * original sampling_rate was 1 second and the requested new sampling rate is 10
  * ms because the user needs immediate reaction from ondemand governor, but not
-- 
1.8.1.2

