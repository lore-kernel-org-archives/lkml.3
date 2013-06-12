Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3FLITm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:19:42 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55284 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3FLITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:19:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-cris-kernel@axis.com
Subject: [PATCH 02/11] cpufreq: cris: select CPU_FREQ_TABLE
Date: Wed, 12 Jun 2013 13:45:09 +0530
Message-Id: <e0ea7cd2cbc88fa7bf009a3e864cabe2ce26d49e.1371022830.git.viresh.kumar@linaro.org>
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

Cc: linux-cris-kernel@axis.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/cris/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 8769a90..5f7530c 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -134,11 +134,13 @@ config SVINTO_SIM
 
 config ETRAXFS
 	bool "ETRAX-FS-V32"
+	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Support CRIS V32.
 
 config CRIS_MACH_ARTPEC3
         bool "ARTPEC-3"
+	select CPU_FREQ_TABLE if CPU_FREQ
         help
           Support Axis ARTPEC-3.
 
-- 
1.7.12.rc2.18.g61b472e

