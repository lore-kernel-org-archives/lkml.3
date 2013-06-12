Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3FLIVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:21:10 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33520 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3FLIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:21:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Viresh Kumar <viresh.kumar@linaro.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 07/11] cpufreq: powerpc: CBE_RAS: select CPU_FREQ_TABLE
Date: Wed, 12 Jun 2013 13:45:14 +0530
Message-Id: <601f678e73c3a5fbcc392ac480a2d12b155d0485.1371022830.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq driver of this platform uses APIs from freq_table.c and so must select
CPU_FREQ_TABLE.

Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig.powerpc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig.powerpc b/drivers/cpufreq/Kconfig.powerpc
index 9c926ca..68c1abc 100644
--- a/drivers/cpufreq/Kconfig.powerpc
+++ b/drivers/cpufreq/Kconfig.powerpc
@@ -1,6 +1,7 @@
 config CPU_FREQ_CBE
 	tristate "CBE frequency scaling"
 	depends on CBE_RAS && PPC_CELL
+	select CPU_FREQ_TABLE
 	default m
 	help
 	  This adds the cpufreq driver for Cell BE processors.
-- 
1.7.12.rc2.18.g61b472e

