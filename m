Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3GEIqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:46:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50486 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3GEIqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:46:49 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-78-51d687f73286
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Subject: [PATCH 0/6] cpufreq: Add 'load_table' debugfs file to show colleced
 CPUs load
Date: Fri, 05 Jul 2013 17:46:35 +0900
Message-id: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkSPd7+7VAg8sTrC2eNv1gt7j+5Tmr
	xdmmN+wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h82jb8sqRo9Hi1sYPT5vkgtg
	ieKySUnNySxLLdK3S+DK6Pg3laXgjGrFk+kXWRoYZ4p3MXJySAiYSGzu2csKYYtJXLi3nq2L
	kYtDSGApo8Tui4vZuxg5wIperuABqRESWMQo8WOzF0TNf0aJc/s/MIIk2AS0JPa/uMEGYosI
	uEmsvfaJEaSIWaCZUeLwp6lADjuHsECExNcIkBIWAVWJ989OMYPYvAKuEp9PzmOCuEFO4sOe
	R+wgrRIC7ewSvxb2sUE0CEh8m3yIBeIeWYlNB5gh6iUlDq64wTKBUXABI8MqRtHUguSC4qT0
	IkO94sTc4tK8dL3k/NxNjMCAPf3vWe8OxtsHrA8xJgONm8gsJZqcDwz4vJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwrjQQ15iftYZ5VudFh0MO
	Jw3Pq70vnT25/PdUwUmby3LN1dbzaayfmJ+cY38x4pFGwe/J+ok1y56euvTk5v/0zz3cH6XX
	xuscFDtoKnV2aZGp9P3o5adVrsb9yF9z/2vCgr0pSxbKqGv557t3/7v/qrvdXrI8oWa9xUxZ
	6ZdCm85IT2oMlQsLV2Ipzkg01GIuKk4EAK0aaStuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd3v7dcCDb6/NbR42vSD3eL6l+es
	Fmeb3rBbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaPvi2rGD0eLW5h9Pi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bHv6ksBWdUK55Mv8jSwDhT
	vIuRg0NCwETi5QqeLkZOIFNM4sK99WwgtpDAIkaJH5u9uhi5gOz/jBLn9n9gBEmwCWhJ7H9x
	A6xIRMBNYu21T4wgRcwCzYwShz9NBXLYOYQFIiS+RoCUsAioSrx/dooZxOYVcJX4fHIeE8Qu
	OYkPex6xT2DkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOB6eSe1gXNlgcYhRgINR
	iYfXoulqoBBrYllxZe4hRgkOZiURXvuEa4FCvCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgfG
	al5JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MF4Mb50RdvCX
	e8HC1I3BfxJzDVS27HgxLZTtxsnJa8s5Z8WzFOS/+CufJFC+U1j9VEvqnqILUodFBctmld7b
	FR81z+nVyiPbg7p92D+fkltkctHF48CsL2tP7Uh8HGZw83mLdsmsvtmn4oTCvzgu4qi4/y0q
	7Lm//cKPzUefcylPnt/McHX+WyUlluKMREMt5qLiRABAmVGbywIAAA==
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
- each CPU load

These data will mean the change of CPU frequency according to CPUs load at
specific measured time. Also, the user can determine the storage size of colleced
CPUs data. The range is from 10 to 1000.

Second, previous performance/powersave governor haven't calculated CPUs load
becuase these governor didn't change CPU frequency according to CPUs load. But,
load_table debugfs file always should indicate the collected CPUs data regardless
of the kind of cpufreq governor. So, the patch3/4/5 implement that performance/
powersave governor will check periodically CPUs load by calling dbs_check_cpu()
with timer.

Finally, the patch 6 explain the detailed description of load_table debugfs file.

Thanks,
Chanwoo Choi

[Test Result]
- the kind of SoC : Samsung EXYNOS4412
- a range of frequency : 200 ~ 1400MHz

- Ondemand governor and the number of online CPU is 4
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3
23820      500000       500000       53   86   2    73   
23920      500000       400000       66   40   0    42   
24020      400000       400000       71   71   10   52   
24120      400000       300000       33   27   45   65   
24220      300000       300000       4    37   71   34   
24320      300000       300000       1    85   38   16   
24420      300000       200000       6    41   15   51   
24520      200000       200000       12   62   1    51   
24620      200000       200000       9    51   0    58   
24720      200000       200000       32   32   11   27 

- Performance governor and the number of online CPU is 4
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3 
3425930    1400000      1400000      0    0    0    0    
3425945    1400000      1400000      0    0    0    0    
3425960    1400000      1400000      0    0    0    0    
3427105    1400000      1400000      0    0    0    0    
3427109    1400000      1400000      0    0    33   100  
3428135    1400000      1400000      0    0    0    0    
3428425    1400000      1400000      0    0    0    0    
3429385    1400000      1400000      0    0    0    0    
3429400    1400000      1400000      0    0    0    0    
3429415    1400000      1400000      0    0    0    0

- Powersave governor and the number of online CPU is 4
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU1 CPU2 CPU3 
3451945    200000       200000       3    0    0    2    
3453930    200000       200000       0    1    0    1    
3453945    200000       200000       2    2    0    0    
3453960    200000       200000       1    0    1    0    
3455065    200000       200000       0    0    0    0    
3455075    200000       200000       1    5    1    0    
3455570    200000       200000       0    0    0    0    
3455605    200000       200000       0    0    0    3    
3456350    200000       200000       0    0    0    0    
3456360    200000       200000       41   2    39   43   

- Powersave governor and the number of online CPU is 2 (CPU[1-2] is offline)
Time(ms)   Old Freq(Hz) New Freq(Hz) CPU0 CPU3 
3501930    200000       200000       0    0    
3502040    200000       200000       0    0    
3502100    200000       200000       75   16   
3502575    200000       200000       0    0    
3503025    200000       200000       11   2    
3503100    200000       200000       62   14   
3503455    200000       200000       1    0    
3503930    200000       200000       3    9    
3504000    200000       200000       65   15   
3504440    200000       200000       1    0    

Chanwoo Choi (6):
  cpufreq: Add debugfs directory for cpufreq
  cpufreq: stats: Add 'load_table' debugfs file to show accumulated data of CPUs
  cpufreq: Update governor core to support all governors
  cpufreq: performance: Add support to collect CPUs load periodically
  cpufreq: powersave: Add support to collect CPUs load periodically
  Documentation: cpufreq: load_table: Update load_table debugfs file documentation

 Documentation/cpu-freq/cpufreq-stats.txt |  39 ++++-
 drivers/cpufreq/Kconfig                  |   6 +
 drivers/cpufreq/cpufreq.c                |  61 ++++++++
 drivers/cpufreq/cpufreq_governor.c       |  37 ++++-
 drivers/cpufreq/cpufreq_governor.h       |  11 ++
 drivers/cpufreq/cpufreq_performance.c    | 156 ++++++++++++++++++-
 drivers/cpufreq/cpufreq_powersave.c      | 158 ++++++++++++++++++-
 drivers/cpufreq/cpufreq_stats.c          | 256 ++++++++++++++++++++++++++++---
 include/linux/cpufreq.h                  |   7 +
 9 files changed, 692 insertions(+), 39 deletions(-)

-- 
1.8.0

