Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab3GRLSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:18:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17918 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186Ab3GRLR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:17:59 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-a1-51e7cee565ff
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/3 v6] cpufreq: Add 'load_table' debugfs file to show colleced
 CPUs load
Date: Thu, 18 Jul 2013 20:17:52 +0900
Message-id: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkWPfpueeBBjun61o8bfrBbnH9y3NW
	i7NNb9gtLu+aw2bxufcIo8XtxhVsFv0Le5ksNn71cODwuHNtD5tH35ZVjB6PFrcwenzeJBfA
	EsVlk5Kak1mWWqRvl8CV8eL2D+aCVfoVt459Z2pgPKzQxcjJISFgItH1dT87hC0mceHeerYu
	Ri4OIYGljBJXjmxigSm6c38zC0RiEaPEsVOHwRJCAo1MEq/OVoHYbAJaEvtf3GADsUUE3CTW
	XvvECNLALDCFUaL52CagBAeHsEC0RP99TZAaFgFViTff+llBbF4BF4nHOxqgrpCT+LDnEZTd
	zC7x5jEjRL2AxLfJh1hAxkgIyEpsOsAMUSIpcXDFDZYJjIILGBlWMYqmFiQXFCelF5noFSfm
	Fpfmpesl5+duYgSG7Ol/zybsYLx3wPoQYzLQuInMUqLJ+cCQzyuJNzQ2M7IwNTE1NjK3NCNN
	WEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY6gB0+mPkRYh16YcuFn2MfvOiSRT
	f/HU0LvVrd2Bae4cNnp8i6IPno5/x5e46FKveGhq24P4JZNehN523v3/W/7Lks//n4tZisw8
	c/GqfeHpsNfJ6RwT5iSv33BRdhJ3Ifskwz0bzleufvpvhczdjsP6OVtr9Ndc0HB7riJQW9XD
	eFTUSOLTMSWW4oxEQy3mouJEALcEZe5vAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd2n554HGjxfqGLxtOkHu8X1L89Z
	Lc42vWG3uLxrDpvF594jjBa3G1ewWfQv7GWy2PjVw4HD4861PWwefVtWMXo8WtzC6PF5k1wA
	S1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowXt38wF6zSr7h17DtTA+Nh
	hS5GTg4JAROJO/c3s0DYYhIX7q1n62Lk4hASWMQocezUYbCEkEAjk8Srs1UgNpuAlsT+FzfY
	QGwRATeJtdc+MYI0MAtMYZRoPrYJKMHBISwQLdF/XxOkhkVAVeLNt35WEJtXwEXi8Y4Gdohl
	chIf9jxin8DIvYCRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEw8k9rBuLLB4hCjAAej
	Eg/vDZ7ngUKsiWXFlbmHGCU4mJVEeL/tAwrxpiRWVqUW5ccXleakFh9iTAbaPpFZSjQ5Hxiv
	eSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAaLbWMOyNugLv
	lf8TtzhniWj4S8TqZ373/qTI/fVPYMlNE60XO/feaOb3vNArrxy07PMWs+QN0g91jM2/ZekI
	alVNn8XNNO1KQ0mWyfo/q/+yTwvom8dvc9h6nytTc/Xjuwu62J5uV0wUbai+8eLZXLkfHTHx
	pfvKJy09uaems7PPaE5sxEYLJZbijERDLeai4kQARRQUkc0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add 'load_table' debugfs file to provide collected CPUs data.
The load_table debugfs file gives below CPU datas.
- measured time
- old CPU frequency
- new CPU frequency
- Per-CPU load

These data will mean the change of CPU frequency according to CPUs load at
specific measured time. Also, the user can determine the storage size of colleced
CPUs data. The range is from 10 to 1000. The patch3 explain the detailed
description of load_table debugfs file.

Changes since v5:
[patch1/3]
- Refactoring patch v4
- Create again symbolic link of debugfs directory when first CPU dev is removed
  (In this case, many CPUs share only one cpufreq policy)

[patch2/3]
- Determine index value of policy->cpu_debugfs[] according to
  cpumask_weight(policy->cpus) value
- Bug fix, store 'policy->cpu' to 'freq->cpu' before notify
  CPUFREQ_LOADCHECK notification

[patch3/3]
- Add description of test case

Changes since v4:
[patch2/3]
- Reset the data of CPUs load when cpufreq governor is changed
- Move code about creating debugfs directory to below first patch
	: [PATCH 1/2] cpufreq: Add debugfs directory for cpufreq

--
I sent only one patch before v4
and then I divided one patch in 3 patches after v4.

Changes since v3:
- Extend a range of accumulated data (10 ~ 1000)
- Add unit information of time/freq and align 'Time' field as left for readability
- Use CONFIG_CPU_FREQ_STAT depdendency instead of CONFIG_CPU_FREQ_STAT_DETATILS
- Initialize load of offline CPUx as zero(0)
- Create/remove debugfs root directory on cpufreq_stats_init/exit() because
  debugfs root is used on all CPUs.

Changes since v2:
- Code clean according to Viresh Kumar's comment
- Show both old frequency and new frequency on 'load_table' debugfs file
- Change debufs file patch as below
  old: /sys/kernel/debugfs/cpufreq/load_table
  new: /sys/kernel/debugfs/cpufreq/cpuX/load_table

Changes since v1:
- Set maximum storage size to save CPUs load on Kconfig
- Use spinlock to synchronize read/write operation for CPUs load
- Use local variable instead of global variable(struct cpufreq_freqs *freqs)
- Use pointer of data structure to get correct size of data structure
  in sizeof() macro instead of structure name
  : sizeof(struct cpufreq_freqs) -> sizeof(*stat->load_table)
- Change time unit from nanosecond to microsecond
- Remove unnecessary memory copy

Thanks,
Chanwoo Choi

[Test Result]
- condition : Samsung SoC Exynos4412 (all CPUs share one voltage/frequency)

1. [ONDEMAND governor, the number of online CPU is 4]
-sh-4.1# ls -al /sys/kernel/debug/cpufreq/
total 0
drwxr-xr-x  3 root root 0 Jan  1 09:00 .
drwx------ 28 root root 0 Jan  1 09:00 ..
drwxr-xr-x  2 root root 0 Jan  1 09:00 cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu1 -> ./cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu2 -> ./cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu3 -> ./cpu0

-sh-4.1# cat /sys/kernel/debug/cpufreq/cpu0/load_table
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
135720     400000       400000       56   52   53   91
135820     400000       400000       67   65   83   64
135920     400000       400000       67   66   77   67
136020     400000       1100000      40   41   98   37
136120     1100000      600000       21   24   43   32
136220     600000       600000       29   36   25   87
136320     600000       600000       83   45   44   44
136420     600000       300000       38   27   37   45
136520     300000       1100000      48   45   49   97
136620     1100000      900000       28   38   26   74

2. [ONDEMAND governor, the number of online CPU is 3]
-sh-4.1# ls -al /sys/kernel/debug/cpufreq/
total 0
drwxr-xr-x  3 root root 0 Jan  1 09:02 .
drwx------ 28 root root 0 Jan  1 09:00 ..
drwxr-xr-x  2 root root 0 Jan  1 09:00 cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu1 -> ./cpu0
lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu3 -> ./cpu0

-sh-4.1# cat /sys/kernel/debug/cpufreq/cpu0/load_table
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU3
156720     200000       200000       60   60   60
156820     200000       200000       61   58   60
156930     200000       200000       61   61   59
157020     200000       200000       61   67   61
157120     200000       200000       63   66   63
157230     200000       200000       61   61   60
157320     200000       200000       60   63   61
157420     200000       200000       61   61   60
157520     200000       200000       69   69   69
157620     200000       200000       93   95   94
<s/devices/system/cpu/cpu0/cpufreq/scaling_governor

3. [PERFORMANCE governor, the number of online CPU is 3]
-sh-4.1# echo performance > /sys/kernel/debug/cpufreq/cpu0/cpufreq/scaling_governor
-sh-4.1# cat /sys/kernel/debug/cpufreq/cpu0/load_table
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU3
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0
0          0            0            0    0    0

Chanwoo Choi (3):
  cpufreq: Add debugfs directory for cpufreq
  cpufreq: stats: Add 'load_table' debugfs file to show accumulated data of CPUs
  Documentation: cpufreq: load_table: Update load_table debugfs file documentation

 Documentation/cpu-freq/cpufreq-stats.txt |  40 ++++-
 drivers/cpufreq/Kconfig                  |   6 +
 drivers/cpufreq/cpufreq.c                | 181 ++++++++++++++++++++++
 drivers/cpufreq/cpufreq_governor.c       |  14 ++
 drivers/cpufreq/cpufreq_stats.c          | 258 ++++++++++++++++++++++++++++---
 include/linux/cpufreq.h                  |   7 +
 6 files changed, 478 insertions(+), 28 deletions(-)

-- 
1.8.0

