Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbaGYGqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:46:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:27386 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbaGYGqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:46:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="567041120"
Message-ID: <53D1FD0E.4080406@intel.com>
Date: Fri, 25 Jul 2014 14:45:34 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [LKP] [rcu] c0f489d2c6f: -1.5% netperf.Throughput_tps
References: <53d1f486.t70cWJ/Ilm6Y3o5/%fengguang.wu@intel.com>
In-Reply-To: <53d1f486.t70cWJ/Ilm6Y3o5/%fengguang.wu@intel.com>
X-Forwarded-Message-Id: <53d1f486.t70cWJ/Ilm6Y3o5/%fengguang.wu@intel.com>
Content-Type: multipart/mixed;
 boundary="------------010704050606040500050300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010704050606040500050300
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit c0f489d2c6fec8994c642c2ec925eb858727dc7b ("rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs")

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     12654 ~ 0%      -1.5%      12470 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
     12654 ~ 0%      -1.5%      12470 ~ 0%  TOTAL netperf.Throughput_tps

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      1050 ~ 4%     -91.4%         90 ~23%  ivb43/netperf/300s-25%-TCP_CRR
      1050 ~ 4%     -91.4%         90 ~23%  TOTAL cpuidle.POLL.usage

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
  53785432 ~ 4%     -77.8%   11927078 ~26%  ivb43/netperf/300s-25%-TCP_CRR
  53785432 ~ 4%     -77.8%   11927078 ~26%  TOTAL cpuidle.C1E-IVT.time

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      5674 ~30%   +1060.9%      65880 ~ 3%  ivb43/netperf/300s-25%-TCP_CRR
      5674 ~30%   +1060.9%      65880 ~ 3%  TOTAL numa-vmstat.node0.numa_other

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
    851366 ~ 8%     -74.4%     218296 ~24%  ivb43/netperf/300s-25%-TCP_CRR
    851366 ~ 8%     -74.4%     218296 ~24%  TOTAL cpuidle.C1E-IVT.usage

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
   8045967 ~28%     -81.9%    1454789 ~14%  lkp-sb02/pigz/25%-128K
   6021385 ~41%     -70.5%    1773953 ~18%  lkp-sb02/pigz/25%-512K
  14067352 ~34%     -77.0%    3228743 ~16%  TOTAL cpuidle.C1-SNB.time

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     78355 ~ 2%     -77.0%      18022 ~11%  ivb43/netperf/300s-25%-TCP_CRR
     78355 ~ 2%     -77.0%      18022 ~11%  TOTAL numa-vmstat.node1.numa_other

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      0.16 ~11%     -72.5%       0.04 ~11%  ivb43/netperf/300s-25%-TCP_CRR
      0.16 ~11%     -72.5%       0.04 ~11%  TOTAL turbostat.%c3

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       237 ~ 9%    +169.4%        640 ~ 2%  lkp-sb02/pigz/25%-128K
       197 ~11%    +177.3%        546 ~ 4%  lkp-sb02/pigz/25%-512K
       435 ~10%    +173.0%       1187 ~ 3%  TOTAL cpuidle.C3-SNB.usage

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
  32364085 ~ 6%     -62.3%   12189943 ~16%  ivb43/netperf/300s-25%-TCP_CRR
  32364085 ~ 6%     -62.3%   12189943 ~16%  TOTAL cpuidle.C3-IVT.time

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
  10134346 ~ 1%     -55.0%    4563107 ~10%  ivb43/netperf/300s-25%-TCP_CRR
  10134346 ~ 1%     -55.0%    4563107 ~10%  TOTAL cpuidle.C6-IVT.usage

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     82079 ~ 6%    +176.9%     227278 ~23%  lkp-sb02/pigz/25%-128K
     82079 ~ 6%    +176.9%     227278 ~23%  TOTAL cpuidle.C3-SNB.time

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
    659858 ~ 5%     -49.7%     332152 ~19%  ivb43/netperf/300s-25%-TCP_CRR
    659858 ~ 5%     -49.7%     332152 ~19%  TOTAL cpuidle.C3-IVT.usage

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      8031 ~20%     +67.1%      13418 ~ 2%  lkp-sb02/pigz/25%-128K
      7254 ~ 7%     +83.8%      13331 ~ 1%  lkp-sb02/pigz/25%-512K
     15285 ~14%     +75.0%      26750 ~ 1%  TOTAL softirqs.RCU

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     37.34 ~ 1%     -32.6%      25.17 ~ 3%  ivb43/netperf/300s-25%-TCP_CRR
      1.04 ~17%     -51.2%       0.51 ~ 4%  lkp-sb02/pigz/25%-128K
      0.74 ~27%     -48.8%       0.38 ~ 6%  lkp-sb02/pigz/25%-512K
     39.12 ~ 1%     -33.4%      26.06 ~ 3%  TOTAL turbostat.%c1

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       512 ~11%     -32.5%        345 ~18%  ivb43/netperf/300s-25%-TCP_CRR
       512 ~11%     -32.5%        345 ~18%  TOTAL slabinfo.kmem_cache.num_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       512 ~11%     -32.5%        345 ~18%  ivb43/netperf/300s-25%-TCP_CRR
       512 ~11%     -32.5%        345 ~18%  TOTAL slabinfo.kmem_cache.active_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      8107 ~ 2%     -28.5%       5798 ~ 9%  ivb43/netperf/300s-25%-TCP_CRR
      8107 ~ 2%     -28.5%       5798 ~ 9%  TOTAL proc-vmstat.numa_hint_faults_local

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       622 ~ 9%     -26.8%        455 ~14%  ivb43/netperf/300s-25%-TCP_CRR
       622 ~ 9%     -26.8%        455 ~14%  TOTAL slabinfo.kmem_cache_node.active_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      8610 ~ 2%     -28.2%       6180 ~12%  ivb43/netperf/300s-25%-TCP_CRR
      8610 ~ 2%     -28.2%       6180 ~12%  TOTAL proc-vmstat.numa_hint_faults

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       640 ~ 8%     -26.0%        473 ~13%  ivb43/netperf/300s-25%-TCP_CRR
       640 ~ 8%     -26.0%        473 ~13%  TOTAL slabinfo.kmem_cache_node.num_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      8876 ~ 2%     -27.2%       6465 ~11%  ivb43/netperf/300s-25%-TCP_CRR
      8876 ~ 2%     -27.2%       6465 ~11%  TOTAL proc-vmstat.numa_pte_updates

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     29.02 ~ 1%     +40.6%      40.81 ~ 2%  ivb43/netperf/300s-25%-TCP_CRR
     29.02 ~ 1%     +40.6%      40.81 ~ 2%  TOTAL turbostat.%c6

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
   1223070 ~11%     -25.6%     909702 ~ 5%  lkp-sb02/pigz/25%-512K
   1223070 ~11%     -25.6%     909702 ~ 5%  TOTAL cpuidle.C1E-SNB.time

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      1278 ~ 6%     +38.0%       1764 ~ 4%  lkp-sb02/pigz/25%-128K
      1257 ~ 5%     +30.6%       1641 ~ 4%  lkp-sb02/pigz/25%-512K
      2535 ~ 6%     +34.3%       3406 ~ 4%  TOTAL cpuidle.C1E-SNB.usage

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      2944 ~12%     -21.2%       2319 ~13%  lkp-sb02/pigz/25%-512K
      2944 ~12%     -21.2%       2319 ~13%  TOTAL slabinfo.anon_vma.active_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       440 ~ 9%     +18.5%        521 ~10%  ivb43/netperf/300s-25%-TCP_CRR
       440 ~ 9%     +18.5%        521 ~10%  TOTAL numa-vmstat.node1.nr_page_table_pages

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      1751 ~ 9%     +18.6%       2076 ~10%  ivb43/netperf/300s-25%-TCP_CRR
      1751 ~ 9%     +18.6%       2076 ~10%  TOTAL numa-meminfo.node1.PageTables

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
 2.828e+09 ~ 0%     -14.9%  2.407e+09 ~ 1%  ivb43/netperf/300s-25%-TCP_CRR
 2.828e+09 ~ 0%     -14.9%  2.407e+09 ~ 1%  TOTAL cpuidle.C1-IVT.time

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       966 ~ 2%     -13.0%        840 ~ 3%  lkp-sb02/pigz/25%-128K
       949 ~ 2%     -10.6%        848 ~ 1%  lkp-sb02/pigz/25%-512K
      1915 ~ 2%     -11.8%       1688 ~ 2%  TOTAL slabinfo.kmalloc-96.active_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       966 ~ 2%     -13.0%        840 ~ 3%  lkp-sb02/pigz/25%-128K
       949 ~ 2%     -10.6%        848 ~ 1%  lkp-sb02/pigz/25%-512K
      1915 ~ 2%     -11.8%       1688 ~ 2%  TOTAL slabinfo.kmalloc-96.num_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     41345 ~ 1%     +12.5%      46521 ~ 0%  lkp-sb02/pigz/25%-512K
     41345 ~ 1%     +12.5%      46521 ~ 0%  TOTAL cpuidle.C6-SNB.usage

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     13053 ~ 1%     +12.0%      14613 ~ 4%  ivb43/netperf/300s-25%-TCP_CRR
     13053 ~ 1%     +12.0%      14613 ~ 4%  TOTAL slabinfo.kmalloc-192.active_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     13053 ~ 1%     +12.1%      14629 ~ 4%  ivb43/netperf/300s-25%-TCP_CRR
     13053 ~ 1%     +12.1%      14629 ~ 4%  TOTAL slabinfo.kmalloc-192.num_objs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      2.02 ~ 3%      -8.6%       1.85 ~ 5%  ivb43/netperf/300s-25%-TCP_CRR
      2.02 ~ 3%      -8.6%       1.85 ~ 5%  TOTAL perf-profile.cpu-cycles.intel_idle.cpuidle_enter_state.cpuidle_enter.cpu_idle_loop.cpu_startup_entry

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
      8226 ~ 2%     -88.4%        957 ~22%  lkp-sb02/pigz/25%-128K
      8291 ~ 1%     -91.1%        736 ~24%  lkp-sb02/pigz/25%-512K
     16518 ~ 2%     -89.7%       1694 ~23%  TOTAL time.involuntary_context_switches

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
    766220 ~ 1%      -7.3%     709976 ~ 2%  ivb43/netperf/300s-25%-TCP_CRR
    766220 ~ 1%      -7.3%     709976 ~ 2%  TOTAL vmstat.system.cs

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       122 ~ 0%      -4.4%        117 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
       122 ~ 0%      -4.4%        117 ~ 0%  TOTAL turbostat.Cor_W

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
       153 ~ 0%      -3.5%        148 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
       153 ~ 0%      -3.5%        148 ~ 0%  TOTAL turbostat.Pkg_W

abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
---------------  -------------------------  
     33.48 ~ 0%      +1.5%      33.97 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
     33.48 ~ 0%      +1.5%      33.97 ~ 0%  TOTAL turbostat.%c0


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                         time.involuntary_context_switches

  9000 ++--------------*----------------------------------------------------+
       |.*..*.*.*.. .*  +  .*.*.*..*.*.*..*.*.    .*.*.*..*.*.*..*.*.*.*..*.*
  8000 *+          *     *.                   *.*.                          |
  7000 ++                                                                   |
       |                                                                    |
  6000 ++                                                                   |
  5000 ++                                                                   |
       |                                                                    |
  4000 ++                                                                   |
  3000 ++                                                                   |
       |                                                                    |
  2000 ++                                                                   |
  1000 ++            O O                               O                    |
       O O  O O O  O     O  O O O  O O O      O O  O O    O O O  O O O      |
     0 ++---------------------------------O-O-------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Aaron

--------------010704050606040500050300
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="reproduce"

ZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTAvY3B1ZnJl
cS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2RldmljZXMvc3lz
dGVtL2NwdS9jcHUxL2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgplY2hvIHBlcmZvcm1hbmNl
ID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1Mi9jcHVmcmVxL3NjYWxpbmdfZ292ZXJu
b3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTMvY3B1
ZnJlcS9zY2FsaW5nX2dvdmVybm9yCgo=
--------------010704050606040500050300--
