Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbbAUHdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:33:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:42647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbbAUHdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:33:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,440,1418112000"; 
   d="yaml'?scan'208";a="654130107"
Message-ID: <1421825564.6126.29.camel@intel.com>
Subject: [LKP] [rcu] 00f5159aeb6: +55.3%
 will-it-scale.time.involuntary_context_switches
From: Huang Ying <ying.huang@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Wed, 21 Jan 2015 15:32:44 +0800
Content-Type: multipart/mixed; boundary="=-s0G9Q6qUBU2JwHhiN/sI"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s0G9Q6qUBU2JwHhiN/sI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git stall.2015.01.06a
commit 00f5159aeb68f08ce29597be86be87d6db0c1ba1 ("rcu: Run grace-period kthreads at real-time priority")


testbox/testcase/testparams: lkp-a03/will-it-scale/performance-lock1

e3663b1024d1f946  00f5159aeb68f08ce29597be86  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
     11321 ±  5%     +55.3%      17582 ± 14%  will-it-scale.time.involuntary_context_switches
     28999 ± 44%    +109.3%      60700 ± 25%  sched_debug.cpu#1.ttwu_count
     58384 ± 44%    +103.6%     118851 ± 24%  sched_debug.cpu#1.nr_switches
     26144 ± 48%     +90.3%      49762 ± 26%  sched_debug.cpu#1.sched_goidle
       827 ± 34%     -57.3%        353 ± 21%  cpuidle.C2-ATM.usage
     58976 ± 43%    +103.0%     119712 ± 24%  sched_debug.cpu#1.sched_count
       503 ± 29%     -56.5%        219 ± 27%  cpuidle.C4-ATM.usage
     11321 ±  5%     +55.3%      17582 ± 14%  time.involuntary_context_switches
       156 ± 14%     -29.6%        110 ± 19%  cpuidle.POLL.usage
     50583 ±  2%     -21.7%      39630 ±  4%  cpuidle.C6-ATM.usage
  51597156 ±  2%     +23.7%   63848564 ±  3%  cpuidle.C1E-ATM.time
     39349 ±  2%     -12.0%      34622 ±  2%  softirqs.SCHED
    758790 ±  8%     -15.3%     642336 ± 12%  sched_debug.cpu#2.sched_count
    378981 ±  8%     -15.6%     319776 ± 12%  sched_debug.cpu#2.ttwu_count
    374440 ±  8%     -15.5%     316513 ± 12%  sched_debug.cpu#2.ttwu_local
      5307 ±  0%      -1.0%       5255 ±  0%  vmstat.system.in

testbox/testcase/testparams: wsm/will-it-scale/performance-open2

e3663b1024d1f946  00f5159aeb68f08ce29597be86  
----------------  --------------------------  
     22128 ±  3%    +120.2%      48719 ±  8%  will-it-scale.time.involuntary_context_switches
      5577 ± 45%   +1492.2%      88802 ± 33%  sched_debug.cpu#6.sched_count
      5457 ± 46%   +1526.2%      88751 ± 33%  sched_debug.cpu#6.nr_switches
      0.45 ± 43%     -73.3%       0.12 ± 15%  turbostat.%c3
        10 ± 24%     -55.8%          4 ± 40%  sched_debug.cpu#9.nr_uninterruptible
       147 ± 11%     -58.5%         61 ± 32%  sched_debug.cpu#11.load
       147 ± 11%     -58.5%         61 ± 32%  sched_debug.cfs_rq[11]:/.load
  10821106 ± 39%     -59.8%    4347430 ± 20%  cpuidle.C3-NHM.time
       356 ± 41%     +76.6%        629 ±  3%  sched_debug.cfs_rq[6]:/.blocked_load_avg
     22128 ±  3%    +120.2%      48719 ±  8%  time.involuntary_context_switches
       145 ± 36%     -35.9%         93 ± 30%  sched_debug.cpu#5.load
       469 ± 29%     +55.9%        732 ±  4%  sched_debug.cfs_rq[6]:/.tg_load_contrib
       145 ± 36%     -34.0%         95 ± 29%  sched_debug.cfs_rq[5]:/.load
        99 ±  8%     -27.8%         72 ± 24%  sched_debug.cpu#9.load
        99 ±  8%     -27.8%         72 ± 24%  sched_debug.cfs_rq[9]:/.load
    219871 ±  6%     -33.3%     146545 ± 19%  sched_debug.cpu#3.ttwu_local
    224610 ±  6%     -31.3%     154342 ± 18%  sched_debug.cpu#3.sched_goidle
    451877 ±  6%     -31.1%     311378 ± 18%  sched_debug.cpu#3.sched_count
    451737 ±  6%     -31.1%     311279 ± 18%  sched_debug.cpu#3.nr_switches
    225208 ±  6%     -31.3%     154688 ± 18%  sched_debug.cpu#3.ttwu_count
      4122 ±  7%     -23.6%       3148 ± 17%  cpuidle.C3-NHM.usage
        84 ± 11%     -27.4%         61 ±  5%  sched_debug.cpu#7.cpu_load[0]
    154565 ±  2%     -29.6%     108768 ±  9%  cpuidle.C6-NHM.usage
    124949 ± 25%     +41.4%     176670 ± 15%  sched_debug.cpu#2.sched_goidle
     74177 ±  2%     -23.6%      56653 ±  4%  sched_debug.cpu#3.nr_load_updates
        79 ±  6%     -23.1%         60 ±  5%  sched_debug.cpu#7.cpu_load[1]
     50107 ±  6%     -20.9%      39621 ±  7%  sched_debug.cfs_rq[3]:/.exec_clock
        76 ±  4%     -20.6%         60 ±  6%  sched_debug.cpu#7.cpu_load[2]
    385983 ±  9%     -20.4%     307347 ± 12%  sched_debug.cfs_rq[3]:/.min_vruntime
        74 ±  2%     -18.5%         60 ±  6%  sched_debug.cpu#7.cpu_load[3]
      1.50 ±  6%     -10.0%       1.35 ±  9%  perf-profile.cpu-cycles.selinux_file_free_security.security_file_free.__fput.____fput.task_work_run
     46086 ±  1%     -25.7%      34260 ±  5%  softirqs.SCHED
        72 ±  1%     -15.9%         60 ±  7%  sched_debug.cpu#7.cpu_load[4]
        74 ± 13%     -17.7%         61 ±  2%  sched_debug.cfs_rq[7]:/.runnable_load_avg
        65 ±  2%     +16.9%         76 ±  4%  sched_debug.cpu#1.cpu_load[3]
      1.94 ±  5%      -9.9%       1.74 ±  6%  perf-profile.cpu-cycles.security_file_free.__fput.____fput.task_work_run.do_notify_resume
     58851 ±  1%     +20.5%      70942 ±  9%  sched_debug.cfs_rq[1]:/.exec_clock
     69880 ±  1%     -16.9%      58047 ± 11%  sched_debug.cpu#7.nr_load_updates
        60 ±  5%      +9.5%         66 ±  3%  sched_debug.cpu#9.cpu_load[4]
     12064 ±  7%     +12.4%      13561 ±  5%  slabinfo.kmalloc-64.num_objs
        67 ±  4%     +14.9%         77 ±  4%  sched_debug.cpu#1.cpu_load[2]
     53070 ±  7%     +18.3%      62803 ±  5%  sched_debug.cfs_rq[9]:/.exec_clock
        64 ±  1%     +16.3%         74 ±  4%  sched_debug.cpu#1.cpu_load[4]
     11895 ±  7%     +12.9%      13429 ±  5%  slabinfo.kmalloc-64.active_objs
     67415 ±  1%     -16.4%      56345 ± 11%  sched_debug.cfs_rq[7]:/.exec_clock
     58403 ±  4%     +12.0%      65434 ±  6%  sched_debug.cpu#9.nr_load_updates
    428535 ±  8%     +18.3%     507136 ±  6%  sched_debug.cfs_rq[9]:/.min_vruntime
    505551 ±  1%     +16.3%     588207 ±  8%  sched_debug.cfs_rq[1]:/.min_vruntime
      1818 ±  5%      -8.4%       1665 ±  3%  slabinfo.proc_inode_cache.active_objs
      1818 ±  5%      -8.4%       1665 ±  3%  slabinfo.proc_inode_cache.num_objs
       616 ±  0%     +11.4%        686 ±  4%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
      2259 ± 14%     +23.5%       2790 ±  5%  sched_debug.cpu#3.curr->pid
     28336 ±  0%     +11.2%      31517 ±  4%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
    576795 ±  1%     -14.6%     492717 ± 10%  sched_debug.cfs_rq[7]:/.min_vruntime
      7176 ±  0%      +2.1%       7323 ±  0%  vmstat.system.cs
     10798 ±  0%      -1.1%      10675 ±  0%  vmstat.system.in

lkp-a03: Atom
Memory: 8G

wsm: Westmere
Memory: 6G




                   will-it-scale.time.involuntary_context_switches

  70000 ++------------------------------------------------------------------+
        |                                                                   |
  60000 ++                                                         O        |
        O        O    O                  O    O   O    O    O   O      O    |
  50000 ++   O O    O        O                           O    O           O O
        | O                    O  O        O    O                    O      |
  40000 ++              O  O        O O              O                      |
        |                                                                   |
  30000 ++                                                                  |
        |     .*.                       .*.*..                      .*      |
  20000 *+*..*   *..*.*    *.*.*..*.*.*.      *.*.*..*.*.*..*.*.*..*        |
        |              :  :                                                 |
  10000 ++             :  :                                                 |
        |               ::                                                  |
      0 ++--------------*---------------------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample

To reproduce:

	apt-get install ruby ruby-oj
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
	cd lkp-tests
	bin/setup-local job.yaml # the job file attached in this email
	bin/run-local   job.yaml


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Huang, Ying



--=-s0G9Q6qUBU2JwHhiN/sI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: will-it-scale
default-monitors:
  wait: pre-test
  uptime: 
  iostat: 
  vmstat: 
  numa-numastat: 
  numa-vmstat: 
  numa-meminfo: 
  proc-vmstat: 
  proc-stat: 
  meminfo: 
  slabinfo: 
  interrupts: 
  lock_stat: 
  latency_stats: 
  softirqs: 
  bdi_dev_mapping: 
  diskstats: 
  cpuidle: 
  cpufreq: 
  turbostat: 
  sched_debug:
    interval: 10
  pmeter: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: 634b0bd490b7ebd7a054cea4f7e0d25748bde678
model: Westmere
memory: 6G
nr_hdd_partitions: 1
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
netconsole_port: 6667
perf-profile:
  freq: 800
will-it-scale:
  test:
  - open2
testbox: wsm
tbox_group: wsm
kconfig: x86_64-rhel
enqueue_time: 2015-01-16 17:43:47.976990621 +08:00
head_commit: 634b0bd490b7ebd7a054cea4f7e0d25748bde678
base_commit: eaa27f34e91a14cdceed26ed6c6793ec1d186115
branch: next/master
kernel: "/kernel/x86_64-rhel/634b0bd490b7ebd7a054cea4f7e0d25748bde678/vmlinuz-3.19.0-rc4-next-20150116-g634b0bd"
user: lkp
queue: cyclic
rootfs: debian-x86_64-2015-01-13.cgz
result_root: "/result/wsm/will-it-scale/performance-open2/debian-x86_64-2015-01-13.cgz/x86_64-rhel/634b0bd490b7ebd7a054cea4f7e0d25748bde678/0"
job_file: "/lkp/scheduled/wsm/cyclic_will-it-scale-performance-open2-x86_64-rhel-HEAD-634b0bd490b7ebd7a054cea4f7e0d25748bde678-0.yaml"
dequeue_time: 2015-01-16 23:50:07.247065623 +08:00
nr_cpu: "$(nproc)"
job_state: finished
loadavg: 8.12 4.97 2.06 1/146 6693
start_time: '1421423439'
end_time: '1421423743'
version: "/lkp/lkp/.src-20150116-113525"

--=-s0G9Q6qUBU2JwHhiN/sI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

./runtest.py open2 32 1 6 9 12

--=-s0G9Q6qUBU2JwHhiN/sI
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-s0G9Q6qUBU2JwHhiN/sI--

