Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaHMBSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 21:18:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:57739 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaHMBRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 21:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,853,1400050800"; 
   d="scan'208";a="587312790"
Date: Wed, 13 Aug 2014 09:19:00 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [net] 8f61059a96c: +26.4% netperf.Throughput_Mbps
Message-ID: <20140813011900.GC11210@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we are glad to inform you that we noticed the below good changes on

commit 8f61059a96c2a29c1cc5a39dfe23d06ef5b4b065 ("net: sctp: improve timer slack calculation for transport HBs")

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     %stddev        %change               %stddev
            \          |                 /
      2586 ± 0%     +11.1%       2873 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1349 ± 2%     +55.7%       2101 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      3936 ± 0%     +26.4%       4974 ± 0%  TOTAL netperf.Throughput_Mbps

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
    170805 ±12%    +398.9%     852164 ±14%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
    170805 ±12%    +398.9%     852164 ±14%  TOTAL cpuidle.C1-NHM.usage

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      4.18 ± 5%    -100.0%       0.00 ± 0%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      4.18 ± 5%    -100.0%       0.00 ± 0%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irqsave.mod_timer.sctp_transport_reset_timers.sctp_outq_flush.sctp_outq_uncork

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      3.06 ± 2%     -98.4%       0.05 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      3.06 ± 2%     -98.4%       0.05 ± 0%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irqsave.lock_timer_base.mod_timer.sctp_transport_reset_timers.sctp_outq_flush

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      4.31 ± 2%     -99.3%       0.03 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
     10.60 ± 2%     -99.7%       0.03 ±14%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
     14.92 ± 2%     -99.6%       0.06 ± 7%  TOTAL perf-profile.cpu-cycles.sctp_transport_timeout.sctp_transport_reset_timers.sctp_outq_flush.sctp_outq_uncork.sctp_cmd_interpreter

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      4.42 ± 2%     -99.5%       0.02 ±18%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      4.42 ± 2%     -99.5%       0.02 ±18%  TOTAL perf-profile.cpu-cycles.lock_timer_base.isra.34.mod_timer.sctp_transport_reset_timers.sctp_outq_flush.sctp_outq_uncork

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      1.77 ± 4%     -78.8%       0.38 ± 4%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1.77 ± 4%     -78.8%       0.38 ± 4%  TOTAL perf-profile.cpu-cycles.sctp_outq_flush.sctp_outq_uncork.sctp_cmd_interpreter.sctp_do_sm.sctp_assoc_bh_rcv

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
    131114 ± 5%     -71.1%      37873 ± 3%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
    131114 ± 5%     -71.1%      37873 ± 3%  TOTAL cpuidle.C1E-SNB.usage

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
  14540720 ±17%    +162.1%   38114453 ±15%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
  14540720 ±17%    +162.1%   38114453 ±15%  TOTAL cpuidle.C1-NHM.time

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      4.37 ± 1%     +36.5%       5.96 ± 1%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      3.42 ±11%    +196.0%      10.11 ± 5%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      7.78 ± 5%    +106.5%      16.07 ± 4%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.free_one_page.__free_pages_ok.__free_pages.__free_kmem_pages

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      4.04 ± 1%     +32.3%       5.35 ± 1%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      3.52 ±10%    +174.1%       9.64 ± 6%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      7.56 ± 6%     +98.3%      14.99 ± 4%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irqsave.get_page_from_freelist.__alloc_pages_nodemask.alloc_kmem_pages_node.kmalloc_large_node

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
     26132 ± 1%     +45.8%      38103 ±25%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
     26132 ± 1%     +45.8%      38103 ±25%  TOTAL numa-vmstat.node2.nr_file_pages

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
    104532 ± 1%     +45.8%     152358 ±25%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
    104532 ± 1%     +45.8%     152358 ±25%  TOTAL numa-meminfo.node2.FilePages

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
    643556 ± 9%     +56.2%    1005209 ± 5%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
    643556 ± 9%     +56.2%    1005209 ± 5%  TOTAL cpuidle.C1-SNB.usage

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      2894 ±32%     +98.4%       5742 ±31%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      2894 ±32%     +98.4%       5742 ±31%  TOTAL cpuidle.C6-SNB.time

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
  18604327 ± 7%     -43.0%   10606401 ±12%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
  18604327 ± 7%     -43.0%   10606401 ±12%  TOTAL cpuidle.C1E-NHM.time

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.253e+08 ± 2%     +55.0%  1.942e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.253e+08 ± 2%     +55.0%  1.942e+08 ± 1%  TOTAL numa-vmstat.node3.numa_local

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.253e+08 ± 2%     +55.0%  1.942e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.253e+08 ± 2%     +55.0%  1.942e+08 ± 1%  TOTAL numa-vmstat.node3.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 2.554e+08 ± 2%     +53.1%   3.91e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.554e+08 ± 2%     +53.1%   3.91e+08 ± 1%  TOTAL numa-numastat.node3.local_node

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 2.554e+08 ± 2%     +53.1%   3.91e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.554e+08 ± 2%     +53.1%   3.91e+08 ± 1%  TOTAL numa-numastat.node3.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 4.133e+08 ± 0%     +13.6%  4.695e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.094e+08 ± 4%     +70.5%  1.866e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 5.228e+08 ± 1%     +25.5%  6.561e+08 ± 0%  TOTAL proc-vmstat.pgalloc_dma32

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      0.17 ±10%     +52.9%       0.27 ±21%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      0.17 ±10%     +52.9%       0.27 ±21%  TOTAL turbostat.%c1

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.981e+08 ± 0%     +14.0%  2.259e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.267e+08 ± 2%     +63.0%  2.066e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 3.248e+08 ± 1%     +33.1%  4.325e+08 ± 0%  TOTAL numa-vmstat.node0.numa_local

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.981e+08 ± 0%     +14.0%  2.259e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.267e+08 ± 2%     +63.0%  2.066e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 3.249e+08 ± 1%     +33.1%  4.325e+08 ± 0%  TOTAL numa-vmstat.node0.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 3.989e+08 ± 0%     +13.1%   4.51e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.582e+08 ± 2%     +60.9%  4.155e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 6.571e+08 ± 1%     +31.9%  8.665e+08 ± 0%  TOTAL numa-numastat.node0.local_node

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 3.989e+08 ± 0%     +13.1%   4.51e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.582e+08 ± 2%     +60.9%  4.155e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 6.571e+08 ± 1%     +31.9%  8.665e+08 ± 0%  TOTAL numa-numastat.node0.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.905e+08 ± 1%     +13.0%  2.153e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.256e+08 ± 1%     +55.7%  1.956e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 3.161e+08 ± 1%     +30.0%  4.109e+08 ± 0%  TOTAL numa-vmstat.node1.numa_local

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.905e+08 ± 1%     +13.0%  2.153e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.257e+08 ± 1%     +55.7%  1.957e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 3.162e+08 ± 1%     +30.0%   4.11e+08 ± 0%  TOTAL numa-vmstat.node1.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 3.836e+08 ± 1%     +12.4%  4.314e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.561e+08 ± 1%     +53.9%  3.942e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 6.397e+08 ± 1%     +29.0%  8.256e+08 ± 0%  TOTAL numa-numastat.node1.local_node

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 3.836e+08 ± 1%     +12.4%  4.314e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.561e+08 ± 1%     +53.9%  3.942e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 6.397e+08 ± 1%     +29.0%  8.256e+08 ± 0%  TOTAL numa-numastat.node1.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.952e+08 ± 1%     +10.0%  2.148e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.251e+08 ± 2%     +56.3%  1.955e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 3.202e+08 ± 1%     +28.1%  4.102e+08 ± 0%  TOTAL numa-vmstat.node2.numa_local

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 1.952e+08 ± 1%     +10.0%  2.148e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.251e+08 ± 2%     +56.3%  1.955e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 3.203e+08 ± 1%     +28.1%  4.103e+08 ± 0%  TOTAL numa-vmstat.node2.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 8.277e+09 ± 0%     +11.1%  9.194e+09 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
   5.4e+09 ± 2%     +55.7%  8.406e+09 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.368e+10 ± 1%     +28.7%   1.76e+10 ± 0%  TOTAL proc-vmstat.pgfree

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 2.853e+08 ± 0%     +11.1%  3.169e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.861e+08 ± 2%     +55.7%  2.897e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 4.713e+08 ± 1%     +28.7%  6.065e+08 ± 0%  TOTAL softirqs.NET_RX

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
  1.57e+09 ± 0%     +11.1%  1.744e+09 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.024e+09 ± 2%     +55.6%  1.594e+09 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.594e+09 ± 1%     +28.7%  3.338e+09 ± 0%  TOTAL proc-vmstat.numa_local

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
  1.57e+09 ± 0%     +11.1%  1.744e+09 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.024e+09 ± 2%     +55.6%  1.594e+09 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.594e+09 ± 1%     +28.7%  3.338e+09 ± 0%  TOTAL proc-vmstat.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 7.864e+09 ± 0%     +11.0%  8.725e+09 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
  5.29e+09 ± 2%     +55.4%   8.22e+09 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 1.315e+10 ± 1%     +28.8%  1.694e+10 ± 0%  TOTAL proc-vmstat.pgalloc_normal

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 3.927e+08 ± 1%      +9.6%  4.305e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.547e+08 ± 2%     +54.5%  3.936e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 6.474e+08 ± 1%     +27.3%   8.24e+08 ± 0%  TOTAL numa-numastat.node2.local_node

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
 3.927e+08 ± 1%      +9.6%  4.305e+08 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
 2.547e+08 ± 2%     +54.5%  3.936e+08 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
 6.474e+08 ± 1%     +27.3%   8.24e+08 ± 0%  TOTAL numa-numastat.node2.numa_hit

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      1294 ± 4%     -17.2%       1071 ±11%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1294 ± 4%     -17.2%       1071 ±11%  TOTAL numa-vmstat.node0.nr_page_table_pages

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      5176 ± 4%     -17.2%       4288 ±11%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      5176 ± 4%     -17.2%       4288 ±11%  TOTAL numa-meminfo.node0.PageTables

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      1.58 ± 3%     +20.3%       1.90 ± 0%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1.58 ± 3%     +20.3%       1.90 ± 0%  TOTAL perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_kmem_pages_node.kmalloc_large_node.__kmalloc_node_track_caller

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      3.29 ± 1%      +9.8%       3.62 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      2.60 ± 1%     +16.3%       3.02 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      5.89 ± 1%     +12.6%       6.63 ± 1%  TOTAL perf-profile.cpu-cycles.memcpy.sctp_packet_transmit_chunk.sctp_outq_flush.sctp_outq_uncork.sctp_cmd_interpreter

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      1400 ± 7%     +11.9%       1566 ± 4%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1400 ± 7%     +11.9%       1566 ± 4%  TOTAL slabinfo.nfs_read_data.active_objs

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      1400 ± 7%     +11.9%       1566 ± 4%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1400 ± 7%     +11.9%       1566 ± 4%  TOTAL slabinfo.nfs_read_data.num_objs

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      6.49 ± 0%     +12.8%       7.32 ± 2%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      6.49 ± 0%     +12.8%       7.32 ± 2%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.skb_copy_datagram_iovec.sctp_recvmsg.sock_common_recvmsg.sock_recvmsg

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
     11700 ± 4%     +18.7%      13891 ± 7%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
     11700 ± 4%     +18.7%      13891 ± 7%  TOTAL proc-vmstat.pgmigrate_success

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
     11700 ± 4%     +18.7%      13891 ± 7%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
     11700 ± 4%     +18.7%      13891 ± 7%  TOTAL proc-vmstat.numa_pages_migrated

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
    139702 ± 1%     +16.3%     162521 ± 5%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
    139702 ± 1%     +16.3%     162521 ± 5%  TOTAL proc-vmstat.numa_hint_faults

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
       977 ± 2%     +16.0%       1133 ± 8%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
       977 ± 2%     +16.0%       1133 ± 8%  TOTAL proc-vmstat.pgmigrate_fail

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      7.74 ± 0%     +10.4%       8.54 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      6.81 ± 0%     +12.2%       7.64 ± 2%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
     14.55 ± 0%     +11.2%      16.18 ± 1%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.sctp_user_addto_chunk.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      4.98 ± 0%     +11.8%       5.57 ± 2%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      4.98 ± 0%     +11.8%       5.57 ± 2%  TOTAL perf-profile.cpu-cycles.memcpy.sctp_outq_flush.sctp_outq_uncork.sctp_cmd_interpreter.sctp_do_sm

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
    160357 ± 1%     +14.2%     183117 ± 4%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
    160357 ± 1%     +14.2%     183117 ± 4%  TOTAL proc-vmstat.numa_pte_updates

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
      1653 ± 3%      -8.5%       1512 ± 4%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
      1653 ± 3%      -8.5%       1512 ± 4%  TOTAL numa-vmstat.node0.nr_alloc_batch

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
    474850 ± 0%     +11.3%     528286 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
    310335 ± 2%     +55.9%     483905 ± 1%  lkp-wsx02/netperf/300s-200%-10K-SCTP_STREAM_MANY
    785185 ± 1%     +28.9%    1012192 ± 0%  TOTAL vmstat.system.cs

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
       354 ± 0%      +3.2%        366 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
       354 ± 0%      +3.2%        366 ± 0%  TOTAL turbostat.Cor_W

eb1ac820c61d0d8  8f61059a96c2a29c1cc5a39df  
---------------  -------------------------  
       410 ± 0%      +2.8%        422 ± 0%  lkp-sbx04/netperf/300s-200%-10K-SCTP_STREAM_MANY
       410 ± 0%      +2.8%        422 ± 0%  TOTAL turbostat.Pkg_W




	[*] bisect-good sample
	[O] bisect-bad  sample


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu56/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu57/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu58/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu59/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu60/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu61/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu62/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu63/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
netserver
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K
netperf -t SCTP_STREAM_MANY -c -C -l 300 -- -m 10K

--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--JgQwtEuHJzHdouWu--
