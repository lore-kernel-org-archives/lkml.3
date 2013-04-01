Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3DAM6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:58:24 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:61492 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab3DAM6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:58:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/9] cpufreq: Documentation: Fix cpufreq_frequency_table name
Date: Mon,  1 Apr 2013 18:27:42 +0530
Message-Id: <314fe583405b207f3ce66273a8496e23e51b150c.1364820620.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
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
index 72f70b1..7c7721d 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -184,10 +184,10 @@ the reference implementation in drivers/cpufreq/longrun.c
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

