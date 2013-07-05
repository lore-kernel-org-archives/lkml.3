Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3GEIrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:47:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50509 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab3GEIq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:46:56 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-dd-51d687fe9647
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Subject: [PATCH 6/6] Documentation: cpufreq: load_table: Update load_table
 debugfs file documentation
Date: Fri, 05 Jul 2013 17:46:41 +0900
Message-id: <1373014001-17746-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkSPdf+7VAgzUvBS2eNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	ieKySUnNySxLLdK3S+DKePlhMWvBROWKbbOPszQwrpfuYuTkkBAwkWj8uJ8VwhaTuHBvPVsX
	IxeHkMBSRon3/+exwxR9/z0BKrGIUeL83b3sEM5/RokHB2ezgVSxCWhJ7H9xA8wWEXCTWHvt
	EyNIEbNAM6PE4U9TgRwODmGBdIkJVxVBalgEVCV6Vz8AW80r4Crx6PxPRohtchIf9jxiBynn
	BJqzZWIxSFgIqOTXnQksICMlBOaxSzx8+YAdYo6AxLfJh1hA6iUEZCU2HWCGGCMpcXDFDZYJ
	jMILGBlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgQG+el/z3p3MN4+YH2IMRlo3ERmKdHk
	fGCU5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	0XZhaKzffkmucjmVpgZVJa6MuXEvTiStOGlRHP/8qA7PqrPPe4UVsyJ/qbDzX3QIN/i16VKe
	iHiTRcIDlQkvi96UfhU4vONo94S0vp73Kbrl+VIed7dGGR9Zq5xWMLF3kVDZ7Wj2Oz7ZK+qt
	vKR1bPV+u2kzPvYLrW/Z6NmrIzm56vXVQCUlluKMREMt5qLiRAB3qPlQiAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd1/7dcCDR6f4bR42vSD3eL6l+es
	Fmeb3rBbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaPvi2rGD0eLW5h9Pi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bLD4tZCyYqV2ybfZylgXG9
	dBcjJ4eEgInE998T2CBsMYkL99YD2VwcQgKLGCXO393LDuH8Z5R4cHA2WBWbgJbE/hc3wGwR
	ATeJtdc+MYIUMQs0M0oc/jQVyOHgEBZIl5hwVRGkhkVAVaJ39QNWEJtXwFXi0fmfjBDb5CQ+
	7HnEDlLOCTRny8RikLAQUMmvOxNYJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HEPPpHYwrmywOMQowMGoxMNr0XQ1UIg1say4MvcQowQHs5IIr33CtUAh3pTEyqrUovz4otKc
	1OJDjMlAR01klhJNzgfGd15JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1KzU1MLUotg
	tjBxcEo1MO5e8NKs1+DSqlmzlO/xpK4s2G07e63fPg9rVb84x34epuwD366I99f4rw01qeZR
	3aK4xfzf8+oFH4un984u7ll3z1Vos6Sq9RL+wBPm9p937Z9zaaLrabsm11XH2yqSrtUrcm09
	rHZT1lOWcaLnXv21ucctzXIXLbivJbR22yQ+UeeF88/+klRiKc5INNRiLipOBADKyRVN5QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the detailed description of 'load_table' debugfs file to show
collected CPUs load and the change of CPU frequency.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 Documentation/cpu-freq/cpufreq-stats.txt | 39 ++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/Documentation/cpu-freq/cpufreq-stats.txt b/Documentation/cpu-freq/cpufreq-stats.txt
index fc64749..8c2e4f2 100644
--- a/Documentation/cpu-freq/cpufreq-stats.txt
+++ b/Documentation/cpu-freq/cpufreq-stats.txt
@@ -18,10 +18,12 @@ Contents
 1. Introduction
 
 cpufreq-stats is a driver that provides CPU frequency statistics for each CPU.
-These statistics are provided in /sysfs as a bunch of read_only interfaces. This
-interface (when configured) will appear in a separate directory under cpufreq
-in /sysfs (<sysfs root>/devices/system/cpu/cpuX/cpufreq/stats/) for each CPU.
-Various statistics will form read_only files under this directory.
+These statistics are provided in /sysfs and /debugfs as a bunch of read_only
+interfaces. This interface (when configured) will appear in a separate directory
+under cpufreq in below directory list for each CPU. Various statistics will form
+read_only files under this directory.
+- /sysfs (<sysfs root>/devices/system/cpu/cpuX/cpufreq/stats/)
+- /debugfs (<sysfs root>/kernel/debug/cpufreq/cpuX/)
 
 This driver is designed to be independent of any particular cpufreq_driver
 that may be running on your CPU. So, it will work with any cpufreq_driver.
@@ -33,6 +35,7 @@ cpufreq stats provides following statistics (explained in detail below).
 -  time_in_state
 -  total_trans
 -  trans_table
+-  load_table
 
 All the statistics will be from the time the stats driver has been inserted 
 to the time when a read of a particular statistic is done. Obviously, stats 
@@ -95,6 +98,28 @@ contains the actual freq values for each row and column for better readability.
   2800000:         0         0         0         2         0 
 --------------------------------------------------------------------------------
 
+-  load_table
+This gives the collected CPUs data which include measured time, old CPU
+frequency, new CPU frequency and each CPU load. The cat output will have
+"<measured time> <old CPU frequency> <new CPU frequency> <CPUs load> ..." pair
+in each line, which will mean the change of CPU frequency according to CPUs load
+at <measured time>.
+
+--------------------------------------------------------------------------------
+<mysystem>:/sys/kernel/debug/cpufreq/cpu0 # cat load_table
+Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
+23820      500000       500000       53   86   2    73
+23920      500000       400000       66   40   0    42
+24020      400000       400000       71   71   10   52
+24120      400000       300000       33   27   45   65
+24220      300000       300000       4    37   71   34
+24320      300000       300000       1    85   38   16
+24420      300000       200000       6    41   15   51
+24520      200000       200000       12   62   1    51
+24620      200000       200000       9    51   0    58
+24720      200000       200000       32   32   11   27
+--------------------------------------------------------------------------------
+
 
 3. Configuring cpufreq-stats
 
@@ -104,6 +129,7 @@ Config Main Menu
 		CPU Frequency scaling  --->
 			[*] CPU Frequency scaling
 			<*>   CPU frequency translation statistics 
+			(10)    Maximum storage size to save CPU load (10-1000)
 			[*]     CPU frequency translation statistics details
 
 
@@ -113,6 +139,11 @@ cpufreq-stats.
 "CPU frequency translation statistics" (CONFIG_CPU_FREQ_STAT) provides the
 basic statistics which includes time_in_state and total_trans.
 
+"Maximum storage size to save CPU load (10-1000)" (depends on CONFIG_CPU_FREQ_
+STAT) indicates the total number of load_table data and provides collected data
+which include old cpu frequency, new cpu frequency and CPUs load. The user can
+determine the storage size of collected CPUs data. The range is from 10 to 1000.
+
 "CPU frequency translation statistics details" (CONFIG_CPU_FREQ_STAT_DETAILS)
 provides fine grained cpufreq stats by trans_table. The reason for having a
 separate config option for trans_table is:
-- 
1.8.0

