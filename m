Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3C3Ldy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 07:33:54 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:47659 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3C3Ldw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 07:33:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Documentation: Fix cpufreq_frequency_table name
Date: Sat, 30 Mar 2013 17:03:42 +0530
Message-Id: <31fdc77dace301ffe3f71a258a8e0f1b013fb5df.1364643195.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At few places in documentation cpufreq_frequency_table is written as
cpufreq_freq_table. Fix these.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpu-freq/cpu-drivers.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index c94383f..a3585ea 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -185,10 +185,10 @@ the reference implementation in drivers/cpufreq/longrun.c
 As most cpufreq processors only allow for being set to a few specific
 frequencies, a "frequency table" with some functions might assist in
 some work of the processor driver. Such a "frequency table" consists
-of an array of struct cpufreq_freq_table entries, with any value in
+of an array of struct cpufreq_frequency_table entries, with any value in
 "index" you want to use, and the corresponding frequency in
 "frequency". At the end of the table, you need to add a
-cpufreq_freq_table entry with frequency set to CPUFREQ_TABLE_END. And
+cpufreq_frequency_table entry with frequency set to CPUFREQ_TABLE_END. And
 if you want to skip one entry in the table, set the frequency to 
 CPUFREQ_ENTRY_INVALID. The entries don't need to be in ascending
 order.
-- 
1.7.12.rc2.18.g61b472e

