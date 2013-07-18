Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab3GRLSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:18:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54729 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab3GRLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:18:07 -0400
X-AuditID: cbfee68f-b7f436d000000f81-df-51e7ceed1e64
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/3 v6] Documentation: cpufreq: load_table: Update load_table
 debugfs file documentation
Date: Thu, 18 Jul 2013 20:17:55 +0900
Message-id: <1374146275-5758-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkUPfdueeBBi3PWCyeNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	ieKySUnNySxLLdK3S+DKmHbkHUtBs0rF56WpDYydMl2MnBwSAiYS28++YoSwxSQu3FvPBmIL
	CSxllLj4Qhum5ujGd+xdjFxA8UWMEg2dh1ghnEYmiYNvJjKDVLEJaEnsf3EDrFtEwE1i7bVP
	jCBFzAJTGCWaj20CSwgLZEnMO9gH1M3BwSKgKrFnqwBImFfAReJK8ydWiG1yEh/2PGIHsTkF
	XCU2fTkAdZGLxIVT/WwgMyUEprNLrNvSA7aYRUBA4tvkQywgMyUEZCU2HWCGmCMpcXDFDZYJ
	jMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgSG+Ol/z/p3MN49YH2IMRlo3ERmKdHk
	fGCM5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	UeTmDcnnL1JNSprXZlkd6GRfd15yxTmmU3Lzd4usnN/XulUiW7Xoz+vaT+YvZni5fZ8iscBi
	y9+ZS6Ya7p6oVq8uoM+y1luj+GeF2p6zX7SX7mJVLljt7n7x5nz5/oyy2qmRtk+KXcREsvpW
	TY91n2sYtSpNRPjPvYjfoneesVbo2cj7XF/1S4mlOCPRUIu5qDgRAGjwzi2HAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd23554HGixcbGXxtOkHu8X1L89Z
	Lc42vWG3uLxrDpvF594jjBa3G1ewWfQv7GWy2PjVw4HD4861PWwefVtWMXo8WtzC6PF5k1wA
	S1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoxpR96xFDSrVHxemtrA2CnT
	xcjJISFgInF04zt2CFtM4sK99WxdjFwcQgKLGCUaOg+xQjiNTBIH30xkBqliE9CS2P/iBhuI
	LSLgJrH22idGkCJmgSmMEs3HNoElhAWyJOYd7APq5uBgEVCV2LNVACTMK+AicaX5EyvENjmJ
	D3segW3mFHCV2PTlAFirEFDNhVP9bBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CI6hZ9I7GFc1WBxiFOBgVOLhvcHzPFCINbGsuDL3EKMEB7OSCO+3fUAh3pTEyqrUovz4otKc
	1OJDjMlAR01klhJNzgfGd15JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotg
	tjBxcEo1MPbn/PsQE54/+fPLRP/Ouf1irVdul15697ftL1dczfW1+pOtvu5X2SwTGnxQf1Ek
	P2/eLK+zS247epc/nNHEsPlwtnwvR9nxc74z2K8q3D6yItHzuVXaw/6PynsYL2S5sdvta+Uy
	l5FZeCD6jXph3hQX0c9RHsd+FAoKhFTFLFKOs5fiLD41QYmlOCPRUIu5qDgRAEU3tv3lAgAA
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
Changes since v5:
- Add description of test case

 Documentation/cpu-freq/cpufreq-stats.txt | 40 ++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/Documentation/cpu-freq/cpufreq-stats.txt b/Documentation/cpu-freq/cpufreq-stats.txt
index fc64749..f1d97d03 100644
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
@@ -95,6 +98,29 @@ contains the actual freq values for each row and column for better readability.
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
+- In case that all CPUs share only one voltage/frequency.
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
 
@@ -104,6 +130,7 @@ Config Main Menu
 		CPU Frequency scaling  --->
 			[*] CPU Frequency scaling
 			<*>   CPU frequency translation statistics 
+			(10)    Maximum storage size to save CPU load (10-1000)
 			[*]     CPU frequency translation statistics details
 
 
@@ -113,6 +140,11 @@ cpufreq-stats.
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

