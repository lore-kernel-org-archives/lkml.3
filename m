Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaHNEpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:45:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:24764 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaHNEpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:45:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,860,1400050800"; 
   d="scan'208";a="558348302"
Date: Thu, 14 Aug 2014 12:47:25 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>, lkp@01.org
Subject: [LKP] [writeback] 952648324b9: -24.9% blogbench.write_score
Message-ID: <20140814044725.GD11210@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we applied your patches and noticed the below changes on

commit 952648324b969f3fc22d3a2a78f4715c0bf43d7f ("writeback: Per-sb dirty tracking")

test case: lkp-sb02/blogbench/1HDD-ext4

df3be46bdbab23e  952648324b969f3fc22d3a2a7 
---------------  ------------------------- 
       834 ± 3%     -24.9%        627 ± 3%  TOTAL blogbench.write_score
      6043 ± 3%     -74.0%       1571 ± 2%  TOTAL slabinfo.jbd2_journal_head.active_objs
       174 ± 3%     -66.9%         57 ± 3%  TOTAL slabinfo.jbd2_journal_head.num_slabs
       174 ± 3%     -66.9%         57 ± 3%  TOTAL slabinfo.jbd2_journal_head.active_slabs
      6293 ± 3%     -66.8%       2091 ± 2%  TOTAL slabinfo.jbd2_journal_head.num_objs
    171025 ±32%     +78.6%     305412 ±28%  TOTAL cpuidle.C1-SNB.time
   1013700 ±36%     +80.6%    1830682 ±17%  TOTAL cpuidle.C1E-SNB.time
      0.11 ±27%     +71.7%       0.18 ±16%  TOTAL turbostat.%c1
   1129386 ± 9%     +35.6%    1531413 ± 4%  TOTAL meminfo.MemFree
   1128767 ± 9%     +35.5%    1529806 ± 4%  TOTAL vmstat.memory.free
    282835 ± 9%     +35.3%     382773 ± 4%  TOTAL proc-vmstat.nr_free_pages
       740 ±12%     +46.3%       1083 ±13%  TOTAL cpuidle.C1E-SNB.usage
    891706 ± 8%     -24.9%     669997 ± 1%  TOTAL proc-vmstat.pgactivate
      1528 ± 6%     -24.7%       1151 ± 1%  TOTAL proc-vmstat.nr_writeback
       327 ±16%     +33.5%        437 ±10%  TOTAL cpuidle.C1-SNB.usage
      6074 ± 8%     -24.6%       4581 ± 2%  TOTAL meminfo.Writeback
     13104 ± 4%     -17.6%      10794 ± 3%  TOTAL slabinfo.buffer_head.num_slabs
     13104 ± 4%     -17.6%      10794 ± 3%  TOTAL slabinfo.buffer_head.active_slabs
    511069 ± 4%     -17.6%     421003 ± 3%  TOTAL slabinfo.buffer_head.num_objs
    510881 ± 4%     -17.6%     421000 ± 3%  TOTAL slabinfo.buffer_head.active_objs
   3500553 ± 2%     -20.3%    2788421 ± 3%  TOTAL proc-vmstat.pgpgout
   1722412 ± 3%     -16.4%    1439377 ± 3%  TOTAL meminfo.Active(file)
   1752356 ± 3%     -16.2%    1468171 ± 3%  TOTAL meminfo.Active
    430248 ± 3%     -16.3%     359905 ± 3%  TOTAL proc-vmstat.nr_active_file
    767908 ± 2%     -19.2%     620130 ± 1%  TOTAL proc-vmstat.nr_written
     97504 ± 4%     -15.5%      82412 ± 3%  TOTAL slabinfo.ext4_inode_cache.active_objs
     97544 ± 4%     -15.5%      82457 ± 3%  TOTAL slabinfo.ext4_inode_cache.num_objs
      6096 ± 4%     -15.5%       5153 ± 3%  TOTAL slabinfo.ext4_inode_cache.num_slabs
      6096 ± 4%     -15.5%       5153 ± 3%  TOTAL slabinfo.ext4_inode_cache.active_slabs
       963 ± 4%     -15.2%        816 ± 3%  TOTAL slabinfo.ext4_extent_status.num_slabs
       963 ± 4%     -15.2%        816 ± 3%  TOTAL slabinfo.ext4_extent_status.active_slabs
     98282 ± 4%     -15.2%      83303 ± 3%  TOTAL slabinfo.ext4_extent_status.num_objs
    100050 ± 4%     -14.8%      85198 ± 3%  TOTAL slabinfo.shared_policy_node.active_objs
    100058 ± 4%     -14.8%      85218 ± 3%  TOTAL slabinfo.shared_policy_node.num_objs
   2435104 ± 3%     -14.7%    2077577 ± 2%  TOTAL meminfo.Cached
      1176 ± 4%     -14.8%       1002 ± 3%  TOTAL slabinfo.shared_policy_node.active_slabs
      1176 ± 4%     -14.8%       1002 ± 3%  TOTAL slabinfo.shared_policy_node.num_slabs
   2435823 ± 3%     -14.6%    2079169 ± 2%  TOTAL vmstat.memory.cache
    616019 ± 3%     -14.6%     526020 ± 2%  TOTAL proc-vmstat.nr_file_pages
      3342 ± 4%     -14.7%       2852 ± 3%  TOTAL slabinfo.radix_tree_node.active_slabs
      3342 ± 4%     -14.7%       2852 ± 3%  TOTAL slabinfo.radix_tree_node.num_slabs
     93612 ± 4%     -14.7%      79877 ± 3%  TOTAL slabinfo.radix_tree_node.num_objs
     93574 ± 4%     -14.7%      79836 ± 3%  TOTAL slabinfo.radix_tree_node.active_objs
     30729 ± 4%     -14.9%      26163 ± 3%  TOTAL meminfo.Buffers
    253276 ± 3%     -14.5%     216563 ± 3%  TOTAL meminfo.SReclaimable
     30737 ± 4%     -14.8%      26187 ± 3%  TOTAL vmstat.memory.buff
     97430 ± 3%     -14.5%      83280 ± 3%  TOTAL slabinfo.ext4_extent_status.active_objs
     63268 ± 3%     -14.4%      54149 ± 3%  TOTAL proc-vmstat.nr_slab_reclaimable
    287129 ± 3%     -13.6%     248074 ± 2%  TOTAL meminfo.Slab
    141193 ± 3%     -12.2%     124025 ± 2%  TOTAL slabinfo.dentry.num_objs
      6723 ± 3%     -12.2%       5905 ± 2%  TOTAL slabinfo.dentry.active_slabs
      6723 ± 3%     -12.2%       5905 ± 2%  TOTAL slabinfo.dentry.num_slabs
    141096 ± 3%     -12.2%     123952 ± 2%  TOTAL slabinfo.dentry.active_objs
    129818 ± 3%     -11.6%     114766 ± 2%  TOTAL slabinfo.Acpi-State.num_objs
      2544 ± 3%     -11.6%       2249 ± 2%  TOTAL slabinfo.Acpi-State.active_slabs
      2544 ± 3%     -11.6%       2249 ± 2%  TOTAL slabinfo.Acpi-State.num_slabs
    129753 ± 3%     -11.6%     114696 ± 2%  TOTAL slabinfo.Acpi-State.active_objs
    969880 ± 1%     -14.1%     832982 ± 1%  TOTAL proc-vmstat.nr_dirtied
     37692 ± 1%     +13.3%      42704 ± 1%  TOTAL softirqs.BLOCK
    726033 ± 3%      -9.0%     660369 ± 3%  TOTAL meminfo.Inactive(file)
    729347 ± 3%      -9.0%     663672 ± 3%  TOTAL meminfo.Inactive
    181422 ± 3%      -9.0%     165116 ± 3%  TOTAL proc-vmstat.nr_inactive_file
     11481 ± 2%     -20.6%       9116 ± 2%  TOTAL iostat.sda.wkB/s
     11499 ± 2%     -20.6%       9128 ± 3%  TOTAL vmstat.io.bo
   7626315 ± 1%     -17.3%    6309955 ± 1%  TOTAL time.file_system_outputs
       232 ± 1%     +13.7%        264 ± 1%  TOTAL iostat.sda.w/s
       652 ± 1%      -9.7%        589 ± 1%  TOTAL iostat.sda.wrqm/s
     31532 ± 2%      -9.5%      28546 ± 1%  TOTAL time.voluntary_context_switches
       562 ± 3%      -8.1%        516 ± 2%  TOTAL iostat.sda.await
       562 ± 3%      -8.1%        516 ± 2%  TOTAL iostat.sda.w_await



Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
mkfs -t ext4 -q /dev/sda2
mount -t ext4 /dev/sda2 /fs/sda2
./blogbench -d /fs/sda2

--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--IDYEmSnFhs3mNXr+--
