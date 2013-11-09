Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab3KIHVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:21:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3KIGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.11 10/94] cpufreq: s3c64xx: Rename index to driver_data
Date: Fri,  8 Nov 2013 22:51:16 -0800
Message-Id: <20131109065204.986122069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 0e8244322b7fc45fd11a1c45f70b6bacddf4986f upstream.

The index field of cpufreq_frequency_table has been renamed to
driver_data by commit 5070158 (cpufreq: rename index as driver_data
in cpufreq_frequency_table).

This patch updates the s3c64xx driver to match.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/s3c64xx-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -166,7 +166,7 @@ static void __init s3c64xx_cpufreq_confi
 		if (freq->frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
 
-		dvfs = &s3c64xx_dvfs_table[freq->index];
+		dvfs = &s3c64xx_dvfs_table[freq->driver_data];
 		found = 0;
 
 		for (i = 0; i < count; i++) {


