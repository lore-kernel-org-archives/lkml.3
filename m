Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbbAVBVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:21:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:32765 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbbAVBVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:21:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,445,1418112000"; 
   d="yaml'?scan'208";a="654581300"
Message-ID: <1421889689.6126.45.camel@intel.com>
Subject: [LKP] [block] 34b48db66e0: +3291.6% iostat.sde.wrqm/s
From: Huang Ying <ying.huang@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Date: Thu, 22 Jan 2015 09:21:29 +0800
Content-Type: multipart/mixed; boundary="=-5Gs+Ki84rWt/KNOyWXFn"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5Gs+Ki84rWt/KNOyWXFn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 34b48db66e08ca1c1bc07cf305d672ac940268dc ("block: remove artifical max_hw_sectors cap")

testbox/testcase/testparams: lkp-ws02/fileio/600s-100%-1HDD-btrfs-64G-1024f-seqrewr-sync

c2661b806092d8ea  34b48db66e08ca1c1bc07cf305  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
     47176 ±  2%     -67.3%      15406 ±  4%  softirqs.BLOCK
      1110 ± 44%     -51.0%        544 ± 35%  sched_debug.cpu#8.curr->pid
        22 ± 33%     -48.9%         11 ± 43%  sched_debug.cpu#1.cpu_load[0]
        91 ± 43%    +125.0%        204 ± 32%  sched_debug.cfs_rq[4]:/.blocked_load_avg
        17 ± 46%     -65.2%          6 ± 31%  sched_debug.cfs_rq[1]:/.runnable_load_avg
       105 ± 43%    +102.6%        213 ± 32%  sched_debug.cfs_rq[4]:/.tg_load_contrib
       163 ± 35%     +62.6%        265 ± 27%  sched_debug.cfs_rq[16]:/.blocked_load_avg
       183 ± 29%     +51.4%        277 ± 26%  sched_debug.cfs_rq[16]:/.tg_load_contrib
      1411 ± 31%     -42.5%        812 ± 32%  sched_debug.cpu#6.curr->pid
  57565068 ± 15%     +66.8%   96024066 ± 17%  cpuidle.C1E-NHM.time
     94625 ±  9%     -32.5%      63893 ±  4%  cpuidle.C3-NHM.usage
       200 ± 14%     -22.8%        155 ± 24%  sched_debug.cfs_rq[8]:/.tg_load_contrib
       244 ± 33%     -39.0%        149 ± 11%  sched_debug.cfs_rq[6]:/.blocked_load_avg
       265 ± 31%     -38.4%        163 ±  9%  sched_debug.cfs_rq[6]:/.tg_load_contrib
      4959 ±  9%     -18.2%       4058 ±  1%  slabinfo.kmalloc-128.active_objs
      4987 ±  9%     -18.6%       4058 ±  1%  slabinfo.kmalloc-128.num_objs
        19 ±  8%     -19.7%         15 ± 14%  sched_debug.cpu#0.cpu_load[1]
    662307 ±  7%     -12.6%     579108 ±  3%  cpuidle.C6-NHM.usage
      3028 ±  7%     -12.3%       2656 ±  1%  slabinfo.ext4_extent_status.num_objs
      3028 ±  7%     -12.3%       2656 ±  1%  slabinfo.ext4_extent_status.active_objs
      4.87 ±  0%   +3291.6%     165.07 ±  0%  iostat.sde.wrqm/s
      1006 ±  0%    +120.3%       2216 ±  0%  iostat.sde.avgrq-sz
       466 ±  0%    +115.9%       1007 ±  0%  iostat.sde.await
       466 ±  0%    +115.9%       1007 ±  0%  iostat.sde.w_await
       301 ±  0%     -52.7%        142 ±  0%  iostat.sde.w/s
      2230 ±  2%      -8.2%       2048 ±  2%  vmstat.system.in

testbox/testcase/testparams: snb-drag/iozone/performance-2HDD-ext4-cfq

c2661b806092d8ea  34b48db66e08ca1c1bc07cf305  
----------------  --------------------------  
    190033 ±  8%    +485.5%    1112554 ±  8%  iozone.time.voluntary_context_switches
   4016641 ± 13%    +107.0%    8315546 ± 19%  iozone.128KB_8reclen.fread
  14586734 ± 12%     -51.6%    7055577 ± 23%  iozone.256KB_128reclen.reread
   6277142 ± 16%     -45.3%    3431678 ± 32%  iozone.131072KB_2048reclen.record_rewrite
   2172125 ± 10%     +76.5%    3833705 ± 27%  iozone.64KB_32reclen.bkwd_read
   4122415 ±  9%     -46.9%    2188825 ± 18%  iozone.128KB_128reclen.frewrite
   4614021 ± 20%     +68.3%    7766650 ± 28%  iozone.128KB_128reclen.fread
   5218680 ± 25%     -35.9%    3344397 ± 22%  iozone.32768KB_2048reclen.record_rewrite
  13598531 ± 12%     -42.4%    7830813 ± 29%  iozone.128KB_32reclen.read
   1747191 ±  5%     +84.5%    3223043 ± 12%  iozone.128KB_8reclen.rewrite
  12146591 ±  6%     -49.1%    6185679 ±  5%  iozone.256KB_16reclen.read
   5801437 ±  1%     -44.3%    3234246 ±  8%  iozone.32768KB_4096reclen.read
   3407258 ± 19%     -30.3%    2374690 ± 33%  iozone.64KB_32reclen.fwrite
   4273739 ±  3%     +72.0%    7349316 ± 15%  iozone.4096KB_2048reclen.bkwd_read
   5653011 ±  1%     -35.6%    3641226 ± 27%  iozone.65536KB_4096reclen.bkwd_read
   6849239 ± 20%     +81.3%   12418997 ± 18%  iozone.256KB_32reclen.read
   9456112 ± 13%     -29.8%    6640684 ± 20%  iozone.512KB_4reclen.random_read
      1754 ±  7%     -30.5%       1219 ±  9%  iozone.time.involuntary_context_switches
  10305719 ± 15%     -30.5%    7160220 ± 35%  iozone.512KB_64reclen.bkwd_read
   4322216 ±  2%     -34.4%    2834349 ± 11%  iozone.262144KB_2048reclen.random_write
   8468758 ± 14%     -24.0%    6433265 ± 23%  iozone.65536KB_1024reclen.reread
   4076482 ±  2%     -30.8%    2820015 ± 24%  iozone.262144KB_2048reclen.rewrite
   9333621 ±  1%     -29.7%    6558928 ±  8%  iozone.65536KB_64reclen.reread
   8034518 ± 12%     +29.3%   10387452 ± 10%  iozone.4096KB_512reclen.random_read
   8948555 ±  3%     -37.8%    5562080 ± 34%  iozone.131072KB_2048reclen.freread
   2883286 ±  1%     -28.9%    2049844 ±  9%  iozone.131072KB_2048reclen.fwrite
   4530075 ± 16%     -21.4%    3559817 ±  6%  iozone.16384KB_16384reclen.bkwd_read
   9647639 ± 11%     -23.8%    7355867 ± 11%  iozone.1024KB_8reclen.bkwd_read
   8885460 ±  6%     -22.3%    6908005 ± 18%  iozone.32768KB_128reclen.read
   9120389 ± 12%     -18.9%    7395338 ±  7%  iozone.1024KB_512reclen.fread
   3487268 ±  0%     -23.6%    2663962 ± 17%  iozone.262144KB_4096reclen.random_write
   3525970 ± 21%     +38.2%    4872904 ±  3%  iozone.128KB_8reclen.record_rewrite
   9309792 ± 14%     +20.6%   11232047 ± 13%  iozone.512KB_4reclen.read
   9088515 ±  1%     -42.8%    5197158 ± 35%  iozone.262144KB_2048reclen.random_read
   4328487 ± 11%     -34.4%    2838483 ± 20%  iozone.256KB_16reclen.fwrite
   4292935 ± 21%     +61.9%    6951375 ± 13%  iozone.4096KB_4096reclen.reread
   5062737 ±  1%     -18.2%    4142609 ± 17%  iozone.131072KB_8192reclen.stride_read
   8193457 ±  2%     -15.4%    6931191 ± 27%  iozone.8192KB_2048reclen.freread
   6627823 ± 10%     +17.5%    7789683 ± 16%  iozone.8192KB_1024reclen.random_read
   3006133 ± 27%     +43.7%    4318375 ±  8%  iozone.256KB_32reclen.fwrite
   7274645 ± 17%     +21.7%    8850043 ± 13%  iozone.4096KB_1024reclen.random_read
   6636384 ±  2%     +31.1%    8701978 ±  3%  iozone.8192KB_128reclen.stride_read
   3501529 ± 13%     +24.9%    4373804 ±  9%  iozone.128KB_128reclen.random_write
  11315178 ± 10%     -15.7%    9537488 ± 16%  iozone.2048KB_8reclen.reread
   3473828 ±  8%     -19.6%    2793577 ± 14%  iozone.131072KB_8192reclen.record_rewrite
   4963222 ±  8%     -18.4%    4049269 ± 16%  iozone.524288KB_8192reclen.random_read
   3917486 ±  1%     -32.6%    2640873 ± 10%  iozone.32768KB_4096reclen.record_rewrite
   4097783 ± 12%     +27.5%    5225546 ±  3%  iozone.16384KB_8192reclen.reread
   8266620 ± 12%     -26.8%    6050991 ±  7%  iozone.131072KB_1024reclen.reread
   3002614 ± 12%     +25.2%    3760021 ±  5%  iozone.8192KB_1024reclen.fwrite
  11461219 ±  8%     -36.9%    7228334 ± 37%  iozone.256KB_4reclen.read
   4153052 ±  8%     -16.8%    3456496 ± 11%  iozone.131072KB_1024reclen.random_write
   3370193 ±  1%     -15.0%    2866094 ± 12%  iozone.131072KB_8192reclen.random_write
   7333520 ± 10%     +21.8%    8931293 ±  5%  iozone.4096KB_1024reclen.read
  11797836 ±  6%     -16.2%    9888848 ± 11%  iozone.1024KB_32reclen.read
   3669268 ±  5%     -24.6%    2764993 ±  8%  iozone.65536KB_4096reclen.record_rewrite
   4933341 ±  9%     -22.5%    3823691 ± 13%  iozone.262144KB_8192reclen.reread
   9146208 ±  3%     -20.3%    7287558 ± 15%  iozone.131072KB_64reclen.reread
  11070712 ± 16%     +21.3%   13425431 ±  7%  iozone.512KB_512reclen.reread
   3389460 ±  3%     -18.3%    2768805 ± 15%  iozone.131072KB_4096reclen.random_write
   6973136 ±  6%     -26.1%    5150644 ± 27%  iozone.128KB_128reclen.bkwd_read
   1648348 ±  7%     +10.5%    1820994 ±  2%  iozone.32768KB_8192reclen.write
   8946805 ±  3%     -22.7%    6917989 ± 18%  iozone.65536KB_128reclen.random_read
   9479095 ±  6%     -17.3%    7838757 ± 11%  iozone.2048KB_4reclen.reread
   7044170 ±  5%     +22.5%    8632284 ±  8%  iozone.4096KB_512reclen.bkwd_read
    425242 ±  4%     -13.7%     366809 ± 12%  iozone.131072KB_4096reclen
  10184282 ±  4%     -21.4%    8000632 ±  8%  iozone.1024KB_1024reclen.bkwd_read
    655333 ±  1%     -19.4%     528199 ± 10%  iozone.131072KB_2048reclen
   3509893 ± 15%     +37.1%    4813310 ± 16%  iozone.512KB_128reclen.frewrite
   3668357 ±  4%     +16.6%    4276349 ±  6%  iozone.2048KB_16reclen.frewrite
   7322643 ±  6%     +16.5%    8530304 ±  5%  iozone.4096KB_128reclen.read
   8914586 ±  3%     -10.9%    7938958 ±  7%  iozone.131072KB_128reclen.stride_read
   8450503 ±  4%     -16.6%    7048034 ± 13%  iozone.16384KB_32reclen.reread
   4454263 ±  7%     -28.3%    3193178 ± 26%  iozone.256KB_64reclen.random_write
   8491147 ±  5%     -13.5%    7348844 ±  9%  iozone.16384KB_512reclen.random_read
   3948585 ± 18%     -22.8%    3049001 ±  9%  iozone.512KB_64reclen.fwrite
  10112307 ±  9%     -23.2%    7769806 ± 18%  iozone.2048KB_256reclen.freread
   4876107 ±  2%     -19.6%    3920473 ±  7%  iozone.256KB_4reclen.record_rewrite
   8774968 ±  3%     -12.4%    7689767 ±  6%  iozone.131072KB_64reclen.stride_read
   2873532 ±  1%     -23.9%    2186794 ± 17%  iozone.262144KB_2048reclen.fwrite
   3196205 ±  6%     +14.6%    3661260 ±  6%  iozone.2048KB_2048reclen.rewrite
   3916092 ±  3%     -14.8%    3336988 ±  2%  iozone.65536KB_512reclen.fwrite
  12945364 ±  4%     -15.7%   10913159 ±  6%  iozone.1024KB_512reclen.random_read
   3694356 ±  3%     +11.6%    4122174 ±  6%  iozone.8192KB_16reclen.frewrite
   5205805 ±  1%     -20.2%    4152492 ± 14%  iozone.262144KB_8192reclen.stride_read
   7318041 ±  7%     +10.1%    8055512 ±  5%  iozone.8192KB_8reclen.freread
   3359536 ±  5%     -14.0%    2888377 ± 10%  iozone.131072KB_16384reclen.record_rewrite
   2217844 ±  5%      -9.2%    2013486 ±  2%  iozone.32768KB_2048reclen.fwrite
   3486864 ±  0%     -20.4%    2776651 ± 14%  iozone.131072KB_1024reclen.fwrite
   4104607 ±  9%     +11.5%    4574911 ±  4%  iozone.1024KB_64reclen.frewrite
   8351037 ±  3%     -11.6%    7379615 ±  6%  iozone.8192KB_32reclen.reread
   8472815 ±  8%     +12.1%    9496427 ±  2%  iozone.2048KB_8reclen.bkwd_read
   9274098 ±  0%     -21.7%    7263574 ±  8%  iozone.131072KB_128reclen.reread
   9198752 ±  2%     -11.7%    8122596 ±  1%  iozone.2048KB_4reclen.random_read
   9888579 ±  5%     +11.3%   11008403 ±  4%  iozone.2048KB_128reclen.freread
   4076419 ±  2%      +9.8%    4474927 ±  6%  iozone.4096KB_16reclen.random_write
   9014509 ±  3%     -19.4%    7262289 ± 18%  iozone.65536KB_1024reclen.random_read
   3797798 ±  6%      +8.1%    4106139 ±  2%  iozone.8192KB_64reclen.fwrite
   9054887 ±  1%     -34.3%    5953341 ± 43%  iozone.65536KB_2048reclen.random_read
   3272537 ±  3%      +9.9%    3596834 ±  5%  iozone.8192KB_4reclen.frewrite
   8755063 ±  4%      -9.3%    7941616 ±  4%  iozone.8192KB_512reclen.random_read
   2226548 ± 17%     +23.9%    2757960 ±  1%  iozone.131072KB_16384reclen.fwrite
   2091038 ±  3%      +4.7%    2190320 ±  2%  iozone.32768KB_512reclen.write
   4623937 ±  3%      -7.7%    4267770 ±  5%  iozone.2048KB_32reclen.fwrite
   9608922 ±  4%      +6.6%   10240058 ±  3%  iozone.2048KB_256reclen.read
   5484722 ±  3%     -18.5%    4470600 ± 26%  iozone.2048KB_1024reclen.record_rewrite
   8653006 ±  1%     -20.2%    6901968 ± 10%  iozone.32768KB_256reclen.random_read
   6595324 ±  2%     -22.6%    5106872 ± 29%  iozone.2048KB_128reclen.record_rewrite
    742878 ±  4%     -10.2%     667046 ±  4%  iozone.512KB_32reclen
   2569242 ±  0%     -13.9%    2211849 ±  9%  iozone.262144KB_8192reclen.fwrite
    593852 ±  2%      +4.5%     620773 ±  4%  iozone.4096KB_8reclen
   7731451 ±  1%     -11.9%    6814549 ±  9%  iozone.8192KB_8reclen.stride_read
   4030276 ±  4%     -11.8%    3555139 ±  4%  iozone.16384KB_8reclen.rewrite
    667670 ±  2%      -9.0%     607569 ±  3%  iozone.131072KB_1024reclen
   4555344 ±  2%      -7.0%    4238147 ±  5%  iozone.131072KB_256reclen.random_write
    663732 ±  1%     -12.2%     582516 ±  8%  iozone.262144KB_2048reclen
   4436723 ±  1%      -7.9%    4084226 ±  3%  iozone.65536KB_64reclen.random_write
   4436835 ±  6%     -11.1%    3943089 ±  5%  iozone.1024KB_32reclen.rewrite
    400045 ±  1%     -12.8%     348866 ±  8%  iozone.131072KB_8192reclen
      1284 ±  0%      -7.4%       1189 ±  0%  iozone.time.elapsed_time
      1284 ±  0%      -7.4%       1189 ±  0%  iozone.time.elapsed_time.max
  11829454 ± 19%     +19.3%   14115355 ±  3%  iozone.4096KB_256reclen.stride_read
    660750 ±  3%      +5.6%     698026 ±  2%  iozone.4096KB_512reclen
   8782251 ±  2%     -10.4%    7866927 ± 12%  iozone.131072KB_256reclen.fread
   4112943 ±  1%     -12.3%    3607095 ± 12%  iozone.262144KB_1024reclen.rewrite
    443953 ±  0%     -10.9%     395738 ±  3%  iozone.262144KB_4096reclen
   3628536 ±  2%      -4.3%    3472913 ±  3%  iozone.8192KB_4reclen.fwrite
    409787 ±  1%     -13.8%     353441 ± 10%  iozone.262144KB_8192reclen
   2180729 ±  0%      -1.7%    2143865 ±  0%  iozone.16384KB_1024reclen.write
   7134489 ± 13%     +19.7%    8538015 ±  1%  iozone.16384KB_128reclen.freread
   4331701 ±  1%      -7.9%    3991380 ±  3%  iozone.16384KB_32reclen.random_write
    672772 ±  2%      -6.1%     631908 ±  1%  iozone.131072KB_512reclen
   1684066 ±  6%     +10.3%    1857499 ±  1%  iozone.65536KB_16384reclen.write
   7560968 ±  0%      -6.5%    7066438 ±  3%  iozone.32768KB_64reclen.record_rewrite
   8637488 ±  0%     -17.2%    7149416 ± 15%  iozone.16384KB_256reclen.random_read
    409516 ±  2%      -9.0%     372768 ±  7%  iozone.262144KB_16384reclen
   2039098 ±  2%      +4.5%    2131410 ±  2%  iozone.131072KB_128reclen.write
   6820137 ±  1%      -4.8%    6489596 ±  2%  iozone.131072KB_512reclen.record_rewrite
   3368515 ± 17%     +16.6%    3928194 ±  4%  iozone.8192KB_8reclen.frewrite
    636959 ±  3%      +5.3%     670460 ±  2%  iozone.4096KB_1024reclen
   8959946 ±  2%     -16.9%    7444825 ± 27%  iozone.131072KB_2048reclen.random_read
   1730222 ±  3%      +5.8%    1831099 ±  1%  iozone.16384KB_16384reclen.write
    689573 ±  2%     -11.0%     613405 ±  7%  iozone.128KB_128reclen
   4529095 ±  2%      +6.8%    4838213 ±  1%  iozone.2048KB_16reclen.random_write
    673658 ±  1%      -6.9%     626975 ±  4%  iozone.65536KB_64reclen
   3988722 ±  2%      -5.1%    3785551 ±  3%  iozone.2048KB_4reclen.random_write
   4434507 ±  1%      -8.0%    4079221 ±  8%  iozone.131072KB_512reclen.random_write
   4209193 ±  1%      -9.8%    3796922 ±  9%  iozone.32768KB_512reclen.rewrite
   1636367 ±  1%      +5.6%    1728029 ±  2%  iozone.512KB_8reclen.write
   5399314 ±  2%     -13.9%    4649006 ± 14%  iozone.2048KB_4reclen.record_rewrite
   8991216 ±  1%     -18.2%    7358805 ± 31%  iozone.131072KB_2048reclen.stride_read
   2064325 ±  0%      -2.6%    2011460 ±  0%  iozone.16384KB_16reclen.write
    694293 ±  1%      -6.2%     651466 ±  0%  iozone.131072KB_128reclen
   3692595 ±  2%      +6.9%    3949182 ±  4%  iozone.16384KB_16reclen.fwrite
    703495 ±  0%      -8.0%     647314 ±  5%  iozone.262144KB_64reclen
    803189 ±  1%      -5.8%     756954 ±  2%  iozone.1024KB_512reclen
   3367144 ±  3%      -4.8%    3204188 ±  4%  iozone.16384KB_4reclen.random_write
   8821044 ±  3%      +4.9%    9250799 ±  1%  iozone.131072KB_128reclen.freread
   2141849 ±  2%      -2.9%    2079725 ±  2%  iozone.4096KB_64reclen.write
   9209523 ±  1%     -10.5%    8244271 ± 14%  iozone.262144KB_64reclen.fread
   8771739 ±  2%     -12.2%    7701390 ± 11%  iozone.16384KB_128reclen.read
 1.383e+08 ±  1%      -3.2%  1.338e+08 ±  1%  iozone.bkwd_read_KBps
   5161430 ±  0%     -23.4%    3952507 ± 25%  iozone.131072KB_8192reclen.fread
   7569441 ±  0%      -4.0%    7264835 ±  2%  iozone.65536KB_64reclen.record_rewrite
    735869 ±  1%      -4.7%     701571 ±  0%  iozone.2048KB_32reclen
    671317 ±  1%      -5.2%     636480 ±  4%  iozone.131072KB_256reclen
   9163246 ±  1%     -12.7%    7998765 ± 19%  iozone.65536KB_1024reclen.read
   6892685 ±  1%     -31.6%    4717232 ± 42%  iozone.8192KB_16reclen.record_rewrite
   2769563 ±  1%     -11.1%    2460867 ± 12%  iozone.131072KB_16384reclen.frewrite
   7538254 ±  1%      -4.1%    7232391 ±  1%  iozone.524288KB_64reclen.record_rewrite
   5078676 ±  1%      +2.7%    5216148 ±  1%  iozone.32768KB_8192reclen.bkwd_read
   5583111 ±  1%      +1.9%    5688340 ±  1%  iozone.524288KB_4096reclen.fread
   7632609 ± 18%     +21.8%    9298145 ±  0%  iozone.524288KB_128reclen.bkwd_read
   2103683 ±  1%      -4.3%    2012622 ±  2%  iozone.2048KB_128reclen.write
   8544794 ± 11%      +9.9%    9394465 ±  0%  iozone.524288KB_1024reclen.read
   7484883 ±  3%      -5.3%    7090201 ±  2%  iozone.131072KB_128reclen.record_rewrite
   3943490 ±  0%      -3.2%    3818389 ±  3%  iozone.16384KB_8reclen.random_write
    612882 ±  4%      +5.9%     649253 ±  1%  iozone.524288KB_1024reclen
 1.049e+08 ±  0%      -3.2%  1.016e+08 ±  1%  iozone.record_rewrite_KBps
   9068478 ±  0%     -12.2%    7966289 ± 20%  iozone.65536KB_1024reclen.stride_read
    687809 ±  1%      -4.1%     659293 ±  5%  iozone.65536KB_128reclen
   1956842 ±  0%      -2.5%    1908160 ±  1%  iozone.1024KB_16reclen.write
   5620548 ±  1%      +1.9%    5729397 ±  0%  iozone.131072KB_4096reclen.fread
  76075116 ±  1%      -2.8%   73925417 ±  0%  iozone.random_write_KBps
   2053740 ±  1%      +3.4%    2123938 ±  1%  iozone.262144KB_256reclen.write
   6013543 ±  1%     -13.0%    5232692 ± 22%  iozone.65536KB_4096reclen.stride_read
   8878850 ±  1%     -14.8%    7569198 ± 15%  iozone.131072KB_64reclen.random_read
  1.64e+08 ±  2%      -3.4%  1.584e+08 ±  1%  iozone.random_read_KBps
   5677438 ±  1%      -2.8%    5518952 ±  1%  iozone.16384KB_4reclen.record_rewrite
   9013379 ±  0%      +2.5%    9237733 ±  0%  iozone.524288KB_512reclen.read
   6834910 ±  0%      -5.1%    6486646 ±  5%  iozone.32768KB_1024reclen.record_rewrite
 1.629e+08 ±  0%      -2.4%   1.59e+08 ±  1%  iozone.read_KBps
   3339864 ±  0%     -10.4%    2991683 ± 10%  iozone.32768KB_16384reclen.random_write
   5962248 ±  0%      -1.8%    5855187 ±  0%  iozone.average_KBps
   5279487 ±  0%     -14.2%    4527825 ± 15%  iozone.262144KB_16384reclen.bkwd_read
   4931955 ± 19%     +13.1%    5576843 ±  0%  iozone.8192KB_8192reclen.read
 1.309e+08 ±  5%     -91.1%   11653700 ±  1%  cpuidle.C3-SNB.time
     24742 ±  4%     -78.8%       5252 ±  0%  cpuidle.C3-SNB.usage
    107687 ±  0%     -72.9%      29181 ±  2%  softirqs.BLOCK
         6 ± 47%    +152.0%         15 ± 38%  sched_debug.cpu#0.cpu_load[2]
      0.35 ± 29%    +151.1%       0.87 ± 25%  perf-profile.cpu-cycles.tick_nohz_idle_enter.cpu_startup_entry.start_secondary
     42787 ±  4%     -88.6%       4871 ± 11%  proc-vmstat.nr_dirty
    171140 ±  4%     -88.6%      19511 ± 11%  meminfo.Dirty
      0.37 ± 12%    +163.0%       0.96 ± 23%  perf-profile.cpu-cycles.wait_on_page_bit.filemap_fdatawait_range.filemap_write_and_wait_range.ext4_sync_file.do_fsync
      0.36 ± 10%    +172.6%       0.99 ± 25%  perf-profile.cpu-cycles.io_schedule.bit_wait_io.__wait_on_bit.wait_on_page_bit.filemap_fdatawait_range
     22.64 ±  1%      -9.4%      20.52 ±  2%  perf-profile.cpu-cycles.scsi_finish_command.scsi_softirq_done.blk_done_softirq.__do_softirq.irq_exit
      0.31 ± 30%    +169.6%       0.84 ± 24%  perf-profile.cpu-cycles.__tick_nohz_idle_enter.tick_nohz_idle_enter.cpu_startup_entry.start_secondary
      0.36 ± 17%    +165.5%       0.94 ± 23%  perf-profile.cpu-cycles.__wait_on_bit.wait_on_page_bit.filemap_fdatawait_range.filemap_write_and_wait_range.ext4_sync_file
    190033 ±  8%    +485.5%    1112554 ±  8%  time.voluntary_context_switches
       208 ± 32%     -54.4%         94 ± 21%  sched_debug.cpu#3.nr_uninterruptible
      0.33 ± 11%    +143.1%       0.79 ± 26%  perf-profile.cpu-cycles.__schedule.io_schedule.bit_wait_io.__wait_on_bit.wait_on_page_bit
     74462 ±  2%    +223.6%     240966 ±  5%  meminfo.Writeback
     18613 ±  2%    +223.7%      60247 ±  5%  proc-vmstat.nr_writeback
      0.61 ± 17%    +139.2%       1.46 ± 13%  perf-profile.cpu-cycles.filemap_fdatawait_range.filemap_write_and_wait_range.ext4_sync_file.do_fsync.sys_fsync
         5 ± 20%    +123.8%         11 ± 19%  sched_debug.cpu#2.cpu_load[3]
 1.171e+08 ±  4%    +193.7%  3.439e+08 ±  5%  cpuidle.C1-SNB.time
    199468 ±  9%    +254.2%     706600 ±  7%  sched_debug.cpu#0.ttwu_count
         6 ± 17%    +116.0%         13 ± 18%  sched_debug.cpu#2.cpu_load[2]
      3.12 ±  6%     -52.8%       1.47 ± 10%  perf-profile.cpu-cycles.__const_udelay.ata_dev_select.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd
      1754 ±  7%     -30.5%       1219 ±  9%  time.involuntary_context_switches
      1.59 ± 14%     -54.0%       0.73 ± 22%  perf-profile.cpu-cycles.iowrite8.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd
         9 ± 11%     +75.7%         16 ± 21%  sched_debug.cpu#2.cpu_load[1]
      2.45 ±  6%     -52.7%       1.16 ± 13%  perf-profile.cpu-cycles.delay_tsc.__const_udelay.ata_dev_select.ata_bmdma_qc_issue.ata_qc_issue
      1.00 ± 16%     -54.5%       0.46 ± 19%  perf-profile.cpu-cycles.native_read_tsc.delay_tsc.__const_udelay.ata_dev_select.ata_bmdma_qc_issue
      3.71 ±  2%     -50.2%       1.85 ± 11%  perf-profile.cpu-cycles.ata_dev_select.constprop.20.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd
         5 ± 31%    +105.0%         10 ± 19%  sched_debug.cpu#2.cpu_load[4]
        13 ± 22%     +56.6%         20 ± 21%  sched_debug.cfs_rq[1]:/.runnable_load_avg
      0.76 ± 25%    +102.6%       1.53 ± 17%  perf-profile.cpu-cycles.wake_bit_function.__wake_up_common.__wake_up.__wake_up_bit.end_page_writeback
      1.00 ± 31%     +68.2%       1.68 ± 20%  perf-profile.cpu-cycles.autoremove_wake_function.wake_bit_function.__wake_up_common.__wake_up.__wake_up_bit
      0.99 ± 32%     +65.0%       1.64 ± 21%  perf-profile.cpu-cycles.default_wake_function.autoremove_wake_function.wake_bit_function.__wake_up_common.__wake_up
      0.79 ± 24%     +93.7%       1.53 ± 17%  perf-profile.cpu-cycles.__wake_up_common.__wake_up.__wake_up_bit.end_page_writeback.ext4_finish_bio
      0.99 ± 31%     +62.5%       1.60 ± 22%  perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.wake_bit_function.__wake_up_common
        19 ± 20%     -27.8%         14 ± 27%  sched_debug.cpu#3.cpu_load[0]
    349094 ±  1%     -44.9%     192443 ±  0%  cpuidle.C6-SNB.usage
    326733 ±  2%     +60.7%     525033 ±  8%  sched_debug.cpu#1.sched_goidle
       603 ±  0%     +75.6%       1058 ±  1%  slabinfo.kmalloc-2048.num_objs
    661534 ±  2%     +60.0%    1058165 ±  8%  sched_debug.cpu#1.sched_count
    660896 ±  2%     +60.0%    1057116 ±  8%  sched_debug.cpu#1.nr_switches
       207 ± 19%     -39.0%        126 ±  9%  sched_debug.cpu#2.nr_uninterruptible
       569 ±  1%     +69.1%        962 ±  2%  slabinfo.kmalloc-2048.active_objs
      1.91 ± 10%     -39.4%       1.16 ± 11%  perf-profile.cpu-cycles.ata_sff_tf_load.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd
      1.68 ± 14%     -35.4%       1.09 ± 14%  perf-profile.cpu-cycles.__const_udelay.ata_sff_tf_load.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd
    246585 ±  6%     +56.9%     386981 ±  6%  cpuidle.C1-SNB.usage
       568 ± 13%     -26.0%        420 ±  6%  sched_debug.cfs_rq[3]:/.blocked_load_avg
      1.15 ± 19%     -27.8%       0.83 ± 17%  perf-profile.cpu-cycles.__ata_sff_port_intr.ata_bmdma_port_intr.ata_bmdma_interrupt.handle_irq_event_percpu.handle_irq_event
       596 ± 13%     -25.8%        442 ±  5%  sched_debug.cfs_rq[3]:/.tg_load_contrib
      9.03 ±  6%     -40.5%       5.37 ±  3%  perf-profile.cpu-cycles.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd.scsi_request_fn
      1.19 ± 18%     -29.8%       0.84 ± 20%  perf-profile.cpu-cycles.delay_tsc.__const_udelay.ata_sff_tf_load.ata_bmdma_qc_issue.ata_qc_issue
      1081 ±  0%     +39.3%       1506 ±  1%  slabinfo.kmalloc-256.active_objs
      1.77 ±  5%     -27.9%       1.28 ±  5%  perf-profile.cpu-cycles.intel_idle.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.rest_init
      1.89 ±  6%     -29.2%       1.34 ±  4%  perf-profile.cpu-cycles.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.rest_init.start_kernel
 1.328e+08 ±  3%     -31.6%   90791332 ±  2%  cpuidle.C1E-SNB.time
      1.92 ± 12%     -28.7%       1.37 ±  4%  perf-profile.cpu-cycles.handle_irq_event.handle_fasteoi_irq.handle_irq.do_IRQ.ret_from_intr
      0.88 ± 16%     +33.1%       1.17 ± 14%  perf-profile.cpu-cycles.ata_sff_qc_issue.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd
      1.45 ± 18%     -23.1%       1.11 ± 10%  perf-profile.cpu-cycles.ata_bmdma_port_intr.ata_bmdma_interrupt.handle_irq_event_percpu.handle_irq_event.handle_fasteoi_irq
    330931 ±  9%     +56.6%     518351 ±  2%  sched_debug.cpu#2.sched_goidle
    670807 ±  9%     +55.7%    1044452 ±  2%  sched_debug.cpu#2.sched_count
    670199 ±  9%     +55.7%    1043484 ±  2%  sched_debug.cpu#2.nr_switches
      1.87 ± 14%     -27.0%       1.37 ±  4%  perf-profile.cpu-cycles.handle_irq_event_percpu.handle_irq_event.handle_fasteoi_irq.handle_irq.do_IRQ
      1.95 ± 13%     -27.4%       1.42 ±  3%  perf-profile.cpu-cycles.handle_fasteoi_irq.handle_irq.do_IRQ.ret_from_intr.cpuidle_enter
      1.74 ± 17%     -25.1%       1.31 ±  6%  perf-profile.cpu-cycles.ata_bmdma_interrupt.handle_irq_event_percpu.handle_irq_event.handle_fasteoi_irq.handle_irq
      2.04 ± 13%     -26.9%       1.50 ±  6%  perf-profile.cpu-cycles.handle_irq.do_IRQ.ret_from_intr.cpuidle_enter.cpu_startup_entry
     60987 ±  3%     -18.6%      49666 ±  1%  sched_debug.cpu#0.nr_load_updates
      1271 ±  2%     +39.9%       1778 ±  1%  slabinfo.kmalloc-256.num_objs
     14.83 ±  4%     -16.4%      12.39 ±  1%  perf-profile.cpu-cycles.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd.scsi_request_fn.__blk_run_queue
      1.17 ± 10%     -18.9%       0.95 ±  6%  perf-profile.cpu-cycles.ext4_da_get_block_prep.__block_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      5.07 ±  8%     +23.9%       6.28 ±  5%  perf-profile.cpu-cycles.memcpy.swiotlb_map_sg_attrs.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd
      5.69 ±  4%     +21.8%       6.93 ±  5%  perf-profile.cpu-cycles.swiotlb_map_sg_attrs.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd.scsi_request_fn
        21 ± 11%     -25.9%         15 ± 11%  sched_debug.cfs_rq[3]:/.runnable_load_avg
    325081 ± 11%     -13.4%     281672 ± 10%  sched_debug.cpu#3.ttwu_count
     36465 ±  3%      -8.7%      33291 ±  1%  sched_debug.cfs_rq[1]:/.min_vruntime
    340518 ±  9%     +23.7%     421099 ±  8%  sched_debug.cpu#3.sched_goidle
    292710 ± 11%     -12.9%     254841 ± 13%  sched_debug.cpu#3.ttwu_local
    688474 ±  9%     +23.4%     849753 ±  8%  sched_debug.cpu#3.nr_switches
    688995 ±  9%     +23.4%     850473 ±  8%  sched_debug.cpu#3.sched_count
     16.46 ±  3%     -13.2%      14.30 ±  3%  perf-profile.cpu-cycles.scsi_run_queue.scsi_next_command.scsi_end_request.scsi_io_completion.scsi_finish_command
      4.00 ±  9%     +27.7%       5.11 ±  9%  perf-profile.cpu-cycles.start_secondary
      3.94 ±  9%     +27.9%       5.04 ±  9%  perf-profile.cpu-cycles.cpu_startup_entry.start_secondary
     16.55 ±  3%     -13.3%      14.35 ±  3%  perf-profile.cpu-cycles.scsi_next_command.scsi_end_request.scsi_io_completion.scsi_finish_command.scsi_softirq_done
     53676 ±  2%     -19.2%      43361 ±  5%  sched_debug.cpu#3.nr_load_updates
     16.42 ±  3%     -13.1%      14.27 ±  3%  perf-profile.cpu-cycles.__blk_run_queue.blk_run_queue.scsi_run_queue.scsi_next_command.scsi_end_request
     16.45 ±  3%     -13.2%      14.27 ±  3%  perf-profile.cpu-cycles.blk_run_queue.scsi_run_queue.scsi_next_command.scsi_end_request.scsi_io_completion
     16.41 ±  3%     -13.1%      14.26 ±  3%  perf-profile.cpu-cycles.scsi_request_fn.__blk_run_queue.blk_run_queue.scsi_run_queue.scsi_next_command
     15.54 ±  4%     -12.4%      13.61 ±  2%  perf-profile.cpu-cycles.scsi_dispatch_cmd.scsi_request_fn.__blk_run_queue.blk_run_queue.scsi_run_queue
      4203 ± 14%     -18.4%       3428 ± 11%  sched_debug.cpu#3.curr->pid
     15.52 ±  4%     -12.3%      13.61 ±  2%  perf-profile.cpu-cycles.ata_scsi_queuecmd.scsi_dispatch_cmd.scsi_request_fn.__blk_run_queue.blk_run_queue
     22925 ±  6%     -12.1%      20156 ±  3%  sched_debug.cfs_rq[3]:/.min_vruntime
     12237 ±  2%     -13.8%      10554 ±  1%  sched_debug.cfs_rq[3]:/.exec_clock
     27.55 ±  2%     -11.5%      24.39 ±  0%  perf-profile.cpu-cycles.cpuidle_enter.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations
     28.65 ±  1%     -11.9%      25.23 ±  0%  perf-profile.cpu-cycles.x86_64_start_kernel
     28.65 ±  1%     -11.9%      25.23 ±  0%  perf-profile.cpu-cycles.start_kernel.x86_64_start_reservations.x86_64_start_kernel
     28.65 ±  1%     -11.9%      25.23 ±  0%  perf-profile.cpu-cycles.x86_64_start_reservations.x86_64_start_kernel
     28.65 ±  1%     -11.9%      25.23 ±  0%  perf-profile.cpu-cycles.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
     28.56 ±  1%     -11.9%      25.17 ±  0%  perf-profile.cpu-cycles.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
     25.22 ±  2%     -10.3%      22.63 ±  0%  perf-profile.cpu-cycles.do_IRQ.ret_from_intr.cpuidle_enter.cpu_startup_entry.rest_init
     58292 ±  4%     -14.9%      49600 ±  3%  sched_debug.cpu#2.nr_load_updates
     25.22 ±  2%     -10.3%      22.63 ±  0%  perf-profile.cpu-cycles.ret_from_intr.cpuidle_enter.cpu_startup_entry.rest_init.start_kernel
     25700 ±  1%      -8.7%      23453 ±  0%  softirqs.SCHED
     62870 ±  0%     -10.4%      56344 ±  6%  sched_debug.cpu#1.nr_load_updates
      3.36 ±  4%      -8.7%       3.07 ±  5%  perf-profile.cpu-cycles.ext4_bio_write_page.mpage_submit_page.mpage_process_page_bufs.mpage_prepare_extent_to_map.ext4_writepages
     22.96 ±  2%      -8.6%      20.99 ±  0%  perf-profile.cpu-cycles.irq_exit.do_IRQ.ret_from_intr.cpuidle_enter.cpu_startup_entry
     22.78 ±  1%      -9.6%      20.61 ±  2%  perf-profile.cpu-cycles.__do_softirq.irq_exit.do_IRQ.ret_from_intr.cpuidle_enter
     22.85 ±  1%      -9.9%      20.58 ±  2%  perf-profile.cpu-cycles.blk_done_softirq.__do_softirq.irq_exit.do_IRQ.ret_from_intr
     22.68 ±  1%      -9.2%      20.58 ±  2%  perf-profile.cpu-cycles.scsi_softirq_done.blk_done_softirq.__do_softirq.irq_exit.do_IRQ
     22.62 ±  1%      -9.2%      20.54 ±  2%  perf-profile.cpu-cycles.scsi_io_completion.scsi_finish_command.scsi_softirq_done.blk_done_softirq.__do_softirq
     22.59 ±  1%      -9.2%      20.52 ±  2%  perf-profile.cpu-cycles.scsi_end_request.scsi_io_completion.scsi_finish_command.scsi_softirq_done.blk_done_softirq
      7.48 ±  4%     +10.2%       8.25 ±  1%  perf-profile.cpu-cycles.__fsync_nocancel
      8.71 ±  3%     +10.6%       9.63 ±  1%  perf-profile.cpu-cycles.ext4_da_write_end.generic_perform_write.__generic_file_write_iter.ext4_file_write_iter.new_sync_write
      2080 ±  2%     +76.2%       3667 ±  4%  vmstat.system.cs
     76575 ±  0%      +8.4%      82997 ±  0%  vmstat.io.bo


testbox/testcase/testparams: bay/dd-write/performance-1HDD-cfq-ext4-10dd

c2661b806092d8ea  34b48db66e08ca1c1bc07cf305  
----------------  --------------------------  
        10 ±  0%     -10.0%          9 ±  0%  vmstat.procs.b
     56496 ±  0%     -46.2%      30420 ±  1%  softirqs.BLOCK
         3 ±  0%     -33.3%          2 ±  0%  ftrace.writeback_single_inode.sda.age
     40537 ±  0%     -36.5%      25733 ±  2%  proc-vmstat.nr_dirty
    162242 ±  0%     -36.7%     102672 ±  2%  meminfo.Dirty
        41 ± 12%   +2052.1%        898 ± 22%  proc-vmstat.nr_vmscan_immediate_reclaim
         8 ±  5%     -66.7%          2 ± 15%  ftrace.global_dirty_state.unstable
     71545 ±  0%     +84.3%     131846 ±  0%  meminfo.Writeback
     17904 ±  0%     +83.7%      32884 ±  0%  proc-vmstat.nr_writeback
     15688 ± 31%     +59.6%      25033 ± 27%  proc-vmstat.compact_migrate_scanned
    489655 ± 26%     +39.6%     683333 ± 24%  proc-vmstat.compact_free_scanned
       258 ± 32%     +52.1%        392 ±  5%  slabinfo.xfs_buf.num_objs
      7859 ±  0%     -37.2%       4937 ±  2%  ftrace.writeback_single_inode.sda.wrote
       258 ± 32%     +48.6%        383 ±  6%  slabinfo.xfs_buf.active_objs
     17773 ±  0%     +84.8%      32842 ±  1%  ftrace.global_dirty_state.writeback
       516 ± 20%     +31.6%        679 ± 18%  sched_debug.cfs_rq[3]:/.blocked_load_avg
      0.95 ± 11%     -27.2%       0.69 ±  6%  perf-profile.cpu-cycles.shrink_active_list.shrink_lruvec.shrink_zone.kswapd_shrink_zone.kswapd
       626 ± 16%     +29.1%        808 ± 14%  sched_debug.cfs_rq[3]:/.tg_load_contrib
      1.25 ± 15%     +31.9%       1.64 ± 16%  perf-profile.cpu-cycles.__find_get_block.__getblk_gfp.__ext4_get_inode_loc.ext4_get_inode_loc.ext4_reserve_inode_write
     40510 ±  0%     -37.4%      25347 ±  0%  ftrace.global_dirty_state.dirty
       638 ±  6%     -17.4%        527 ± 15%  sched_debug.cfs_rq[1]:/.blocked_load_avg
      0.58 ± 33%     +62.2%       0.93 ± 11%  perf-profile.cpu-cycles.__ext4_journal_stop.ext4_dirty_inode.__mark_inode_dirty.generic_write_end.ext4_da_write_end
      1.22 ±  6%     -23.4%       0.93 ±  1%  perf-profile.cpu-cycles.security_file_permission.rw_verify_area.vfs_read.sys_read.system_call_fastpath
      1.62 ±  9%     +40.2%       2.28 ± 18%  perf-profile.cpu-cycles.default_idle.arch_cpu_idle.cpu_startup_entry.start_secondary
      1.64 ±  9%     +39.1%       2.29 ± 18%  perf-profile.cpu-cycles.arch_cpu_idle.cpu_startup_entry.start_secondary
       219 ±  4%     +35.2%        296 ± 13%  uptime.idle
        29 ± 15%     +38.8%         40 ± 11%  sched_debug.cpu#3.cpu_load[4]
        88 ±  9%     +28.2%        113 ± 15%  sched_debug.cpu#0.cpu_load[0]
     12913 ± 16%     +35.5%      17494 ±  8%  proc-vmstat.pgmigrate_success
      7.92 ±  8%     -16.7%       6.59 ±  8%  perf-profile.cpu-cycles.ret_from_fork
      7.92 ±  8%     -16.7%       6.59 ±  8%  perf-profile.cpu-cycles.kthread.ret_from_fork
     26598 ± 16%     +36.8%      36397 ±  9%  proc-vmstat.compact_isolated
        67 ±  5%     +21.0%         82 ± 11%  sched_debug.cpu#0.cpu_load[1]
       105 ±  5%     +17.6%        123 ±  8%  sched_debug.cfs_rq[3]:/.runnable_load_avg
     63729 ±  5%     +22.0%      77752 ±  9%  sched_debug.cfs_rq[1]:/.min_vruntime
        56 ±  6%     +23.7%         69 ±  5%  sched_debug.cpu#3.cpu_load[2]
        39 ± 10%     +30.8%         51 ±  4%  sched_debug.cpu#3.cpu_load[3]
        85 ±  4%     +20.0%        102 ± 10%  sched_debug.cpu#3.cpu_load[1]
     71456 ±  5%     +16.6%      83284 ± 11%  sched_debug.cfs_rq[3]:/.min_vruntime
    105703 ±  4%     +10.5%     116819 ±  5%  sched_debug.cpu#2.nr_load_updates
      5.45 ±  4%      -6.3%       5.10 ±  4%  perf-profile.cpu-cycles.pagecache_get_page.grab_cache_page_write_begin.ext4_da_write_begin.generic_perform_write.__generic_file_write_iter
      9662 ±  0%      +7.9%      10421 ±  3%  ftrace.balance_dirty_pages.sda.task_ratelimit
     61966 ±  2%      -9.2%      56254 ±  2%  softirqs.RCU
     94955 ±  0%      +8.6%     103140 ±  4%  ftrace.bdi_dirty_ratelimit.sda.dirty_rate
      8.71 ±  3%    +685.6%      68.42 ±  2%  iostat.sda.wrqm/s
       991 ±  0%    +120.1%       2182 ±  2%  iostat.sda.avgrq-sz
    187.72 ±  0%     -49.0%      95.64 ±  1%  iostat.sda.w/s
       760 ±  0%     +77.6%       1349 ±  0%  iostat.sda.w_await
       756 ±  0%     +77.8%       1345 ±  0%  iostat.sda.await
    141.80 ±  0%     -12.3%     124.40 ±  1%  iostat.sda.avgqu-sz
      5549 ±  0%      +2.0%       5659 ±  0%  vmstat.system.cs
   3489593 ±  0%      +1.8%    3553306 ±  0%  perf-stat.context-switches
  5.71e+08 ±  2%     +18.9%  6.787e+08 ±  4%  perf-stat.cache-misses
 3.054e+08 ±  3%     +16.5%  3.558e+08 ±  3%  perf-stat.LLC-load-misses
 1.561e+09 ±  0%      +5.9%  1.653e+09 ±  0%  perf-stat.branch-misses
  1.56e+09 ±  0%      +6.4%  1.661e+09 ±  0%  perf-stat.branch-load-misses
 1.409e+10 ±  0%      +3.7%  1.461e+10 ±  2%  perf-stat.L1-icache-load-misses
    151166 ±  0%      +6.7%     161244 ±  2%  perf-stat.cpu-migrations
 1.065e+12 ±  0%      +6.1%   1.13e+12 ±  0%  perf-stat.cpu-cycles
     93722 ±  0%      +1.4%      95034 ±  0%  vmstat.io.bo
 8.095e+11 ±  0%      +5.3%  8.528e+11 ±  1%  perf-stat.L1-icache-loads
     93726 ±  0%      +1.4%      95037 ±  0%  iostat.sda.wkB/s
 1.123e+12 ±  1%      +5.4%  1.184e+12 ±  0%  perf-stat.ref-cycles
 1.248e+11 ±  1%      +5.2%  1.312e+11 ±  0%  perf-stat.bus-cycles
 3.305e+10 ±  0%      +3.1%  3.408e+10 ±  1%  perf-stat.cache-references
 1.107e+08 ±  0%      +3.3%  1.144e+08 ±  0%  perf-stat.LLC-store-misses
 1.479e+11 ±  0%      +1.6%  1.502e+11 ±  1%  perf-stat.branch-loads
 7.971e+11 ±  0%      +1.8%  8.114e+11 ±  1%  perf-stat.instructions
 1.709e+11 ±  0%      +1.3%   1.73e+11 ±  1%  perf-stat.dTLB-stores
 2.877e+11 ±  0%      +1.5%  2.919e+11 ±  0%  perf-stat.L1-dcache-loads
 2.876e+11 ±  0%      +1.4%  2.917e+11 ±  0%  perf-stat.dTLB-loads
 1.482e+11 ±  0%      +1.3%  1.501e+11 ±  0%  perf-stat.branch-instructions


testbox/testcase/testparams: ivb44/fsmark/performance-1x-1t-1HDD-xfs-4M-60G-NoSync

c2661b806092d8ea  34b48db66e08ca1c1bc07cf305  
----------------  --------------------------  
           :4           25%           1:4     kmsg.usbhid#-#:#:can't_add_hid_device
     24990 ±  3%     +64.3%      41060 ±  0%  fsmark.time.voluntary_context_switches
       393 ±  0%      +3.4%        407 ±  0%  fsmark.time.elapsed_time.max
       393 ±  0%      +3.4%        407 ±  0%  fsmark.time.elapsed_time
     39.02 ±  0%      -3.3%      37.73 ±  0%  fsmark.files_per_sec
     11194 ±  0%   +1169.6%     142124 ±  0%  numa-vmstat.node0.nr_writeback
      7721 ±  0%   +1222.6%     102125 ±  0%  numa-vmstat.node1.nr_writeback
     30857 ±  0%   +1224.0%     408538 ±  0%  numa-meminfo.node1.Writeback
     44886 ±  0%   +1167.7%     569033 ±  0%  numa-meminfo.node0.Writeback
     54347 ±  0%     -86.5%       7312 ±  0%  softirqs.TASKLET
       143 ± 21%    +459.5%        800 ± 38%  sched_debug.cfs_rq[27]:/.exec_clock
     53525 ±  0%     -87.9%       6479 ±  0%  softirqs.BLOCK
      1195 ±  6%     -62.0%        454 ± 37%  cpuidle.C3-IVT.usage
      1133 ± 21%     -67.4%        370 ± 13%  cpuidle.C1E-IVT.usage
     24990 ±  3%     +64.3%      41060 ±  0%  time.voluntary_context_switches
       288 ± 29%    +113.6%        615 ± 43%  sched_debug.cfs_rq[22]:/.avg->runnable_avg_sum
       151 ± 26%    +102.0%        306 ± 41%  sched_debug.cfs_rq[36]:/.exec_clock
     75891 ±  0%   +1188.1%     977548 ±  0%  meminfo.Writeback
     18919 ±  0%   +1192.0%     244429 ±  0%  proc-vmstat.nr_writeback
      1131 ±  5%    +148.6%       2811 ±  1%  slabinfo.xfs_trans.num_objs
      1131 ±  5%    +139.0%       2704 ±  1%  slabinfo.xfs_trans.active_objs
     19072 ±  4%     -23.5%      14593 ±  5%  sched_debug.cpu#0.ttwu_count
       291 ± 11%     -59.2%        119 ±  8%  time.involuntary_context_switches
       450 ± 38%     -51.7%        217 ± 27%  sched_debug.cpu#36.curr->pid
       552 ± 38%     +69.8%        938 ± 17%  sched_debug.cpu#42.sched_goidle
       343 ± 16%     -56.4%        149 ± 49%  sched_debug.cpu#1.curr->pid
      2886 ± 30%    +101.3%       5808 ± 25%  sched_debug.cfs_rq[19]:/.min_vruntime
       957 ± 11%    +111.9%       2028 ±  3%  slabinfo.blkdev_ioc.num_objs
       957 ± 11%    +106.0%       1972 ±  4%  slabinfo.blkdev_ioc.active_objs
       166 ±  2%     +81.7%        302 ±  1%  slabinfo.kmalloc-2048.active_slabs
       166 ±  2%     +81.7%        302 ±  1%  slabinfo.kmalloc-2048.num_slabs
      1305 ± 31%     +59.8%       2085 ± 16%  sched_debug.cpu#42.nr_switches
       475 ± 11%     +74.9%        832 ± 21%  sched_debug.cpu#37.sched_goidle
       352 ± 28%     -34.5%        230 ± 29%  sched_debug.cfs_rq[40]:/.avg->runnable_avg_sum
      1081 ± 21%     -24.9%        812 ± 27%  sched_debug.cpu#28.ttwu_count
       472 ± 11%     +48.9%        704 ± 27%  sched_debug.cpu#41.sched_goidle
       567 ± 26%     +62.3%        921 ± 33%  sched_debug.cpu#38.sched_goidle
       671 ± 26%     +47.1%        987 ± 29%  sched_debug.cpu#34.ttwu_count
        42 ± 16%     +70.8%         73 ± 27%  sched_debug.cfs_rq[20]:/.blocked_load_avg
      2672 ±  2%     +81.5%       4850 ±  1%  slabinfo.kmalloc-2048.num_objs
       170 ± 25%     +59.2%        271 ±  4%  sched_debug.cfs_rq[46]:/.tg_load_contrib
      1044 ± 13%     +56.8%       1637 ± 19%  sched_debug.cpu#19.ttwu_local
      2599 ±  2%     +80.7%       4697 ±  1%  slabinfo.kmalloc-2048.active_objs
       167 ± 23%     +59.2%        267 ±  5%  sched_debug.cfs_rq[46]:/.blocked_load_avg
      1301 ± 24%     +56.4%       2035 ± 30%  sched_debug.cpu#38.nr_switches
       631 ± 24%     -33.6%        419 ± 10%  sched_debug.cpu#26.sched_goidle
      1156 ± 11%     +62.0%       1873 ± 17%  sched_debug.cpu#37.nr_switches
       249 ± 10%     -40.4%        148 ± 17%  sched_debug.cfs_rq[43]:/.tg_load_contrib
        46 ± 16%     +58.7%         73 ± 27%  sched_debug.cfs_rq[20]:/.tg_load_contrib
       124 ± 17%     +26.2%        156 ± 15%  sched_debug.cpu#34.ttwu_local
       247 ± 10%     -40.4%        147 ± 18%  sched_debug.cfs_rq[43]:/.blocked_load_avg
      1475 ± 21%     -30.8%       1020 ± 12%  sched_debug.cpu#26.sched_count
        28 ± 15%     -39.5%         17 ± 14%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
      1350 ± 15%     -37.7%        840 ± 12%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
      1445 ± 21%     -30.8%       1000 ± 13%  sched_debug.cpu#26.nr_switches
       811 ±  9%     +38.3%       1122 ± 18%  sched_debug.cpu#42.ttwu_count
      2167 ± 10%     +32.9%       2879 ±  6%  sched_debug.cpu#7.ttwu_local
      1861 ± 21%     +33.9%       2492 ± 17%  sched_debug.cpu#6.ttwu_local
     14320 ±  4%     -30.6%       9937 ±  4%  sched_debug.cpu#0.ttwu_local
      2292 ± 16%     -26.6%       1682 ± 19%  sched_debug.cfs_rq[5]:/.exec_clock
      1159 ± 11%     -21.7%        907 ± 15%  sched_debug.cpu#43.ttwu_count
      2522 ± 47%     -41.3%       1481 ± 11%  sched_debug.cfs_rq[43]:/.min_vruntime
      1496 ±  5%     +14.9%       1718 ±  5%  slabinfo.blkdev_requests.active_objs
      3648 ±  7%     +33.4%       4866 ±  8%  sched_debug.cpu#19.ttwu_count
      9094 ± 11%     +25.4%      11402 ±  7%  sched_debug.cpu#19.nr_switches
      1548 ±  5%     +15.6%       1791 ±  5%  slabinfo.blkdev_requests.num_objs
    331321 ±  1%     -21.7%     259303 ±  0%  cpuidle.C6-IVT.usage
 2.335e+08 ±  1%     +27.0%  2.965e+08 ± 12%  cpuidle.C1-IVT.time
     21863 ±  4%     -26.5%      16059 ±  7%  sched_debug.cpu#0.nr_load_updates
     14153 ±  7%     +13.7%      16095 ±  4%  slabinfo.kmalloc-256.num_objs
     16419 ±  5%     -25.2%      12289 ±  8%  sched_debug.cpu#0.sched_goidle
     10169 ±  5%     -13.8%       8767 ±  6%  sched_debug.cfs_rq[0]:/.exec_clock
     35366 ±  4%     -23.9%      26910 ±  7%  sched_debug.cpu#0.nr_switches
      2160 ± 16%     +39.6%       3015 ±  6%  sched_debug.cpu#1.ttwu_local
      9848 ±  2%     +20.6%      11876 ±  5%  slabinfo.kmalloc-512.num_objs
      9721 ±  2%     +20.8%      11741 ±  5%  slabinfo.kmalloc-512.active_objs
      5997 ± 11%     -25.0%       4499 ± 13%  sched_debug.cpu#3.ttwu_count
      4801 ± 17%     +26.5%       6075 ± 14%  sched_debug.cpu#11.sched_goidle
       116 ±  8%     +40.3%        163 ± 33%  sched_debug.cpu#33.ttwu_local
      7180 ±  6%     +12.0%       8038 ±  7%  sched_debug.cpu#19.nr_load_updates
      3654 ± 11%     -15.4%       3092 ±  4%  sched_debug.cpu#44.nr_load_updates
      6077 ±  7%     -19.2%       4913 ± 14%  sched_debug.cpu#2.ttwu_count
      3618 ±  6%     -13.5%       3128 ±  1%  sched_debug.cpu#35.nr_load_updates
      8399 ±  2%     +11.2%       9338 ±  5%  sched_debug.cfs_rq[11]:/.tg_load_avg
      7559 ±  2%     +12.7%       8523 ±  5%  sched_debug.cfs_rq[16]:/.tg_load_avg
      8529 ±  1%     +10.6%       9430 ±  5%  sched_debug.cfs_rq[10]:/.tg_load_avg
      3625 ±  3%     -12.1%       3188 ±  2%  sched_debug.cpu#32.nr_load_updates
      2761 ±  3%     +10.8%       3059 ±  5%  numa-meminfo.node1.KernelStack
      4672 ±  8%     +15.7%       5406 ± 11%  sched_debug.cpu#23.sched_goidle
      3873 ±  5%     -11.0%       3447 ±  3%  sched_debug.cpu#28.nr_load_updates
      8309 ±  3%     +11.1%       9232 ±  5%  sched_debug.cfs_rq[12]:/.tg_load_avg
      1075 ±  4%      -7.3%        996 ±  6%  slabinfo.RAW.num_objs
      1075 ±  4%      -7.3%        996 ±  6%  slabinfo.RAW.active_objs
     10971 ±  2%      -8.6%      10032 ±  7%  sched_debug.cpu#2.nr_load_updates
      8231 ±  5%     +11.8%       9203 ±  5%  sched_debug.cfs_rq[13]:/.tg_load_avg
      8153 ±  5%     +11.2%       9067 ±  5%  sched_debug.cfs_rq[14]:/.tg_load_avg
      9188 ±  5%      +8.5%       9970 ±  6%  sched_debug.cfs_rq[6]:/.tg_load_avg
     52333 ±  2%     +12.6%      58934 ±  0%  softirqs.SCHED
      7393 ±  2%      +9.2%       8070 ±  3%  sched_debug.cfs_rq[18]:/.tg_load_avg
     50231 ±  6%     +12.5%      56530 ±  4%  numa-meminfo.node0.SUnreclaim
     12557 ±  6%     +12.5%      14131 ±  4%  numa-vmstat.node0.nr_slab_unreclaimable
      3613 ±  2%     +13.0%       4082 ±  3%  sched_debug.cpu#27.nr_load_updates
     10044 ±  2%      +7.6%      10811 ±  5%  sched_debug.cfs_rq[1]:/.tg_load_avg
      9345 ±  3%      +8.1%      10101 ±  5%  sched_debug.cfs_rq[5]:/.tg_load_avg
      7420 ±  2%      +9.0%       8088 ±  3%  sched_debug.cfs_rq[17]:/.tg_load_avg
     10101 ±  4%     -14.8%       8605 ± 12%  sched_debug.cpu#5.nr_load_updates
     10031 ±  2%      +7.8%      10810 ±  5%  sched_debug.cfs_rq[0]:/.tg_load_avg
     59796 ±  2%     -10.7%      53396 ±  2%  softirqs.RCU
      7367 ±  3%      +9.2%       8046 ±  3%  sched_debug.cfs_rq[20]:/.tg_load_avg
      7408 ±  2%      +8.6%       8046 ±  3%  sched_debug.cfs_rq[19]:/.tg_load_avg
      7392 ±  2%      +8.9%       8054 ±  3%  sched_debug.cfs_rq[22]:/.tg_load_avg
      7384 ±  3%      +8.9%       8040 ±  3%  sched_debug.cfs_rq[21]:/.tg_load_avg
     34.14 ±  0%    +683.5%     267.48 ±  0%  iostat.sda.wrqm/s
      1009 ±  0%   +1255.7%      13682 ±  0%  iostat.sda.avgrq-sz
    257.55 ±  0%     -92.6%      18.94 ±  0%  iostat.sda.w/s
       544 ±  0%   +1268.9%       7460 ±  0%  iostat.sda.w_await
       544 ±  0%   +1268.5%       7457 ±  0%  iostat.sda.await
       600 ±  0%     -41.1%        353 ±  1%  vmstat.system.in
    131497 ±  0%      -1.6%     129445 ±  0%  vmstat.io.bo
    131277 ±  0%      -3.3%     126926 ±  0%  iostat.sda.wkB/s

testbox/testcase/testparams: bay/dd-write/performance-1HDD-cfq-xfs-1dd

c2661b806092d8ea  34b48db66e08ca1c1bc07cf305  
----------------  --------------------------  
          1:4          -25%            :4     kmsg.e1000e#:#:#eth0:Link_Speed_was_downgraded_by_SmartSpeed
         1 ±  0%    -100.0%          0 ±  0%  vmstat.procs.b
     35966 ±  0%     -68.2%      11441 ±  0%  softirqs.BLOCK
       298 ±  0%     -98.7%          4 ± 43%  ftrace.writeback_single_inode.sda.age
     32052 ±  0%     -19.7%      25738 ±  0%  proc-vmstat.nr_dirty
    128302 ±  0%     -19.7%     102971 ±  0%  meminfo.Dirty
      1089 ±  8%     -20.2%        869 ± 15%  proc-vmstat.nr_vmscan_immediate_reclaim
    108812 ±  0%     +22.3%     133114 ±  0%  meminfo.Writeback
     27191 ±  0%     +22.3%      33261 ±  0%  proc-vmstat.nr_writeback
        88 ±  6%     -24.2%         67 ±  5%  sched_debug.cpu#1.cpu_load[0]
      4.23 ±  4%     -34.7%       2.77 ± 22%  perf-profile.cpu-cycles.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback
      4.24 ±  4%     -34.4%       2.78 ± 22%  perf-profile.cpu-cycles.__writeback_inodes_wb.wb_writeback.bdi_writeback_workfn.process_one_work.worker_thread
      4.24 ±  4%     -34.4%       2.78 ± 22%  perf-profile.cpu-cycles.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.bdi_writeback_workfn
      4.24 ±  4%     -34.4%       2.78 ± 22%  perf-profile.cpu-cycles.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.bdi_writeback_workfn.process_one_work
      4.24 ±  4%     -31.8%       2.90 ± 20%  perf-profile.cpu-cycles.bdi_writeback_workfn.process_one_work.worker_thread.kthread.ret_from_fork
      0.54 ± 31%     +83.7%       0.99 ± 22%  perf-profile.cpu-cycles.copy_from_user_atomic_iovec.iov_iter_copy_from_user_atomic.generic_perform_write.xfs_file_buffered_aio_write.xfs_file_write_iter
      1.06 ±  9%     -46.9%       0.56 ± 20%  perf-profile.cpu-cycles.free_hot_cold_page.free_hot_cold_page_list.shrink_page_list.shrink_inactive_list.shrink_lruvec
      4.24 ±  4%     -34.1%       2.80 ± 21%  perf-profile.cpu-cycles.wb_writeback.bdi_writeback_workfn.process_one_work.worker_thread.kthread
      1.12 ± 13%     -45.8%       0.61 ± 16%  perf-profile.cpu-cycles.free_hot_cold_page_list.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone
      2.11 ± 12%     -52.4%       1.00 ± 33%  perf-profile.cpu-cycles.xfs_start_page_writeback.xfs_convert_page.xfs_cluster_write.xfs_vm_writepage.__writepage
    254817 ±  8%     +80.7%     460518 ±  5%  sched_debug.cpu#1.sched_goidle
    529031 ±  7%     +82.6%     966208 ±  6%  sched_debug.cpu#1.sched_count
    528841 ±  7%     +82.6%     965915 ±  6%  sched_debug.cpu#1.nr_switches
       466 ± 20%     +51.6%        707 ± 16%  sched_debug.cfs_rq[2]:/.blocked_load_avg
       212 ± 11%     +55.4%        329 ± 11%  slabinfo.xfs_buf.num_objs
      0.93 ± 19%     -36.1%       0.59 ± 31%  perf-profile.cpu-cycles.__run_hrtimer.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt.apic_timer_interrupt
      1.24 ± 15%     -48.6%       0.64 ± 31%  perf-profile.cpu-cycles.__test_set_page_writeback.xfs_start_page_writeback.xfs_convert_page.xfs_cluster_write.xfs_vm_writepage
      0.70 ± 18%     +43.4%       1.00 ± 17%  perf-profile.cpu-cycles.__set_page_dirty.mark_buffer_dirty.__block_commit_write.block_write_end.generic_write_end
       212 ± 11%     +50.2%        318 ± 12%  slabinfo.xfs_buf.active_objs
     27192 ±  0%     +18.8%      32298 ±  5%  ftrace.global_dirty_state.writeback
       548 ± 18%     +40.6%        771 ± 14%  sched_debug.cfs_rq[2]:/.tg_load_contrib
      4.23 ±  4%     -37.4%       2.65 ± 22%  perf-profile.cpu-cycles.write_cache_pages.generic_writepages.xfs_vm_writepages.do_writepages.__writeback_single_inode
      4.22 ±  4%     -37.3%       2.65 ± 22%  perf-profile.cpu-cycles.xfs_vm_writepage.__writepage.write_cache_pages.generic_writepages.xfs_vm_writepages
      4.22 ±  4%     -37.3%       2.65 ± 22%  perf-profile.cpu-cycles.__writepage.write_cache_pages.generic_writepages.xfs_vm_writepages.do_writepages
      3.27 ±  4%     -41.9%       1.90 ± 29%  perf-profile.cpu-cycles.xfs_cluster_write.xfs_vm_writepage.__writepage.write_cache_pages.generic_writepages
       802 ± 10%     -27.5%        581 ± 12%  sched_debug.cfs_rq[1]:/.tg_load_contrib
      2.85 ±  4%     -45.6%       1.55 ± 39%  perf-profile.cpu-cycles.xfs_convert_page.isra.11.xfs_cluster_write.xfs_vm_writepage.__writepage.write_cache_pages
      4.23 ±  4%     -34.7%       2.77 ± 22%  perf-profile.cpu-cycles.generic_writepages.xfs_vm_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      4.23 ±  4%     -34.7%       2.77 ± 22%  perf-profile.cpu-cycles.xfs_vm_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb
    262384 ±  5%     +62.0%     425142 ± 29%  sched_debug.cpu#1.ttwu_count
     33514 ±  4%     -22.8%      25878 ± 15%  sched_debug.cfs_rq[0]:/.min_vruntime
      1.82 ±  4%     +34.2%       2.44 ±  9%  perf-profile.cpu-cycles.rw_verify_area.vfs_read.sys_read.system_call_fastpath.read
     32144 ±  0%     -17.4%      26555 ±  6%  ftrace.global_dirty_state.dirty
       720 ± 12%     -29.8%        505 ± 14%  sched_debug.cfs_rq[1]:/.blocked_load_avg
       213 ±  9%     +24.1%        265 ± 15%  sched_debug.cfs_rq[3]:/.load
        78 ± 12%     -22.3%         61 ± 19%  sched_debug.cfs_rq[2]:/.runnable_load_avg
      1.24 ±  9%     +35.9%       1.69 ±  6%  perf-profile.cpu-cycles.security_file_permission.rw_verify_area.vfs_read.sys_read.system_call_fastpath
       307 ±  6%     +22.7%        377 ± 11%  slabinfo.signal_cache.num_objs
       307 ±  6%     +22.7%        377 ± 11%  slabinfo.signal_cache.active_objs
      1389 ±  2%     +34.0%       1862 ±  0%  uptime.idle
       562 ±  9%     -30.5%        390 ±  2%  slabinfo.blkdev_requests.active_objs
       580 ±  9%     -30.0%        406 ±  1%  slabinfo.blkdev_requests.num_objs
     29983 ±  5%     -22.8%      23137 ± 14%  sched_debug.cfs_rq[0]:/.exec_clock
      1717 ±  0%     -12.5%       1503 ±  2%  slabinfo.kmalloc-128.active_objs
     13.79 ±  6%     -17.1%      11.44 ±  2%  perf-profile.cpu-cycles.ret_from_fork
     13.79 ±  6%     -17.1%      11.44 ±  2%  perf-profile.cpu-cycles.kthread.ret_from_fork
      1717 ±  0%     -11.1%       1527 ±  3%  slabinfo.kmalloc-128.num_objs
       735 ±  2%     -17.1%        609 ±  3%  slabinfo.kmalloc-512.num_objs
       700 ±  3%     -14.8%        597 ±  3%  slabinfo.kmalloc-512.active_objs
      3.96 ± 10%     +24.7%       4.94 ±  5%  perf-profile.cpu-cycles.iov_iter_copy_from_user_atomic.generic_perform_write.xfs_file_buffered_aio_write.xfs_file_write_iter.new_sync_write
     10.48 ±  4%     +18.1%      12.38 ±  7%  perf-profile.cpu-cycles.vfs_read.sys_read.system_call_fastpath.read
     12981 ±  2%     +16.5%      15123 ±  4%  meminfo.AnonHugePages
     11.69 ±  6%     +15.8%      13.54 ±  6%  perf-profile.cpu-cycles.sys_read.system_call_fastpath.read
     11.96 ±  6%     +14.1%      13.66 ±  6%  perf-profile.cpu-cycles.system_call_fastpath.read
      0.04 ±  2%  +2.6e+05%     114.04 ±  1%  iostat.sda.wrqm/s
      1006 ±  0%    +467.6%       5715 ±  0%  iostat.sda.avgrq-sz
    204.95 ±  0%     -79.7%      41.69 ±  1%  iostat.sda.w/s
       693 ±  0%     +56.8%       1087 ±  2%  iostat.sda.w_await
       693 ±  0%     +56.8%       1087 ±  2%  iostat.sda.await
    142.50 ±  0%     -68.7%      44.57 ±  2%  iostat.sda.avgqu-sz
      4516 ±  0%     +44.4%       6521 ±  3%  vmstat.system.cs
      6657 ±  1%     +11.5%       7420 ±  0%  vmstat.system.in
   2826521 ±  0%     +42.8%    4036905 ±  3%  perf-stat.context-switches
  1.06e+09 ±  3%     +14.6%  1.214e+09 ±  1%  perf-stat.branch-misses
 1.058e+09 ±  2%     +11.3%  1.178e+09 ±  0%  perf-stat.branch-load-misses
  4.62e+09 ±  1%      +9.6%  5.063e+09 ±  0%  perf-stat.L1-icache-load-misses
     61232 ±  2%      +6.7%      65332 ±  1%  perf-stat.cpu-migrations
 5.616e+11 ±  1%      +3.7%  5.824e+11 ±  1%  perf-stat.L1-icache-loads
 6.938e+11 ±  0%      +3.7%  7.193e+11 ±  1%  perf-stat.ref-cycles
 7.697e+10 ±  1%      +4.1%  8.016e+10 ±  1%  perf-stat.bus-cycles
 1.127e+10 ±  1%      +5.9%  1.194e+10 ±  0%  perf-stat.cache-references
   6150016 ±  1%      +4.9%    6452759 ±  1%  perf-stat.iTLB-load-misses
 5.979e+11 ±  1%      +3.7%  6.198e+11 ±  0%  perf-stat.iTLB-loads
 1.119e+08 ±  0%      +2.0%  1.141e+08 ±  1%  perf-stat.LLC-store-misses
 2.125e+11 ±  0%      +1.6%   2.16e+11 ±  0%  perf-stat.dTLB-loads
 1.114e+11 ±  1%      +3.2%   1.15e+11 ±  1%  perf-stat.branch-instructions
 1.363e+11 ±  0%      +1.4%  1.382e+11 ±  1%  perf-stat.L1-dcache-stores

testbox/testcase/testparams: snb-drag/iozone/performance-2HDD-btrfs-cfq

c2661b806092d8ea  34b48db66e08ca1c1bc07cf305  
----------------  --------------------------  
   3721949 ± 10%     -75.8%     900696 ±  2%  iozone.524288KB_16384reclen.random_write
   4415916 ± 18%     -80.9%     844948 ± 48%  iozone.524288KB_64reclen.fwrite
     51312 ±  1%     +98.3%     101737 ±  3%  iozone.time.voluntary_context_switches
   3140204 ± 36%     -68.9%     976488 ±  1%  iozone.524288KB_1024reclen.fwrite
   5168927 ± 30%     +72.6%    8919077 ± 12%  iozone.2048KB_2048reclen.bkwd_read
  12429800 ± 22%     -57.5%    5283570 ±  0%  iozone.64KB_16reclen.read
   9214432 ± 31%    +100.4%   18467538 ± 13%  iozone.64KB_16reclen.reread
   3784507 ± 36%     +54.6%    5852297 ±  9%  iozone.64KB_32reclen.frewrite
   5842770 ± 10%     +59.1%    9293676 ± 25%  iozone.256KB_16reclen.read
   4096260 ± 22%     +26.8%    5194967 ± 25%  iozone.8192KB_2048reclen.record_rewrite
   2143392 ± 10%     +71.8%    3682593 ±  7%  iozone.64KB_32reclen.rewrite
   3926749 ± 10%     +65.7%    6504827 ±  1%  iozone.8192KB_2048reclen.bkwd_read
   3245712 ± 28%     +41.1%    4580273 ±  0%  iozone.8192KB_2048reclen.fwrite
   5516996 ±  2%     -42.0%    3202464 ±  0%  iozone.131072KB_4096reclen.stride_read
  11626146 ±  3%     -27.5%    8425044 ±  8%  iozone.256KB_32reclen.read
   6552054 ± 26%     +37.2%    8987238 ±  3%  iozone.524288KB_2048reclen.random_read
   8126973 ± 22%     +35.7%   11027371 ±  5%  iozone.512KB_128reclen.bkwd_read
   9186536 ±  1%     -40.2%    5497416 ±  3%  iozone.262144KB_2048reclen.reread
   6785922 ± 15%     +46.0%    9908396 ±  1%  iozone.4096KB_256reclen.freread
   5878217 ± 11%     +32.1%    7767855 ± 17%  iozone.128KB_8reclen.bkwd_read
   2908035 ± 11%     +23.8%    3599941 ± 16%  iozone.65536KB_2048reclen.write
   7045416 ± 28%     +23.9%    8727336 ± 14%  iozone.128KB_64reclen.fread
   4116881 ±  7%     -32.5%    2777202 ±  0%  iozone.131072KB_4096reclen.record_rewrite
   9958948 ± 11%     +22.6%   12204733 ± 16%  iozone.256KB_64reclen.freread
   5295317 ±  0%     -38.0%    3285585 ±  5%  iozone.65536KB_16384reclen.random_read
   5154774 ±  2%     -34.7%    3366812 ±  2%  iozone.32768KB_16384reclen.reread
   3350211 ±  1%     -35.5%    2161492 ±  2%  iozone.131072KB_4096reclen.fwrite
   7058730 ± 23%     +23.5%    8720773 ±  7%  iozone.4096KB_512reclen.freread
   9341609 ±  0%     -34.1%    6154779 ±  0%  iozone.8192KB_16reclen.random_read
   4078539 ± 21%     +14.6%    4674272 ± 15%  iozone.64KB_64reclen.fwrite
   9496835 ± 18%     +16.4%   11050866 ± 15%  iozone.512KB_16reclen.reread
   6835690 ±  7%     +46.9%   10043233 ±  6%  iozone.256KB_16reclen.fread
   5966535 ±  7%     +32.9%    7928399 ± 15%  iozone.128KB_16reclen.stride_read
   6896514 ± 19%      +8.5%    7482559 ± 18%  iozone.8192KB_64reclen.read
   5170408 ± 19%     +27.0%    6564086 ± 15%  iozone.128KB_16reclen.bkwd_read
   6841685 ± 17%     +32.0%    9027640 ±  5%  iozone.4096KB_128reclen.stride_read
   7736851 ± 14%     -26.8%    5665375 ±  2%  iozone.128KB_4reclen.fread
   7263403 ± 19%     +20.2%    8727084 ± 15%  iozone.512KB_16reclen.bkwd_read
   1482761 ± 14%     +20.3%    1784297 ± 12%  iozone.64KB_4reclen.rewrite
   2838836 ±  5%     +25.0%    3548955 ± 14%  iozone.8192KB_2048reclen.write
   4452040 ±  1%     -33.4%    2964529 ±  3%  iozone.262144KB_4096reclen.record_rewrite
   8536046 ±  1%     -17.6%    7029910 ±  0%  iozone.131072KB_2048reclen.freread
  11235457 ± 10%     -46.6%    5999172 ± 18%  iozone.64KB_8reclen.freread
   3585860 ±  0%     -34.2%    2358593 ±  0%  iozone.131072KB_2048reclen.fwrite
   9038144 ±  0%     -31.5%    6194380 ±  0%  iozone.262144KB_64reclen.reread
   7062785 ± 19%     +27.2%    8982751 ±  0%  iozone.16384KB_1024reclen.read
   3950846 ±  8%     -26.8%    2893048 ±  0%  iozone.131072KB_2048reclen.write
   9696357 ± 23%     +36.1%   13196984 ±  0%  iozone.4096KB_64reclen.random_read
   4977030 ± 11%     -25.7%    3700119 ±  0%  iozone.262144KB_64reclen.random_write
   3992512 ± 20%     +31.1%    5233138 ±  0%  iozone.131072KB_16384reclen.reread
   6816595 ± 17%     +25.3%    8538164 ±  0%  iozone.8192KB_512reclen.freread
   2915623 ± 19%     +10.5%    3221728 ± 16%  iozone.16384KB_4096reclen.write
   3998465 ±  6%     -29.3%    2825277 ±  0%  iozone.262144KB_8192reclen.random_write
   5300007 ±  6%     -35.0%    3444156 ±  4%  iozone.131072KB_2048reclen.random_write
   5816163 ±  2%     +41.6%    8237185 ±  0%  iozone.8192KB_1024reclen.bkwd_read
   7152954 ±  0%     -29.7%    5028185 ±  1%  iozone.8192KB_4reclen.fread
   6734662 ± 16%     +24.6%    8394385 ±  1%  iozone.4096KB_256reclen.random_write
   3713447 ±  4%     +39.5%    5179264 ±  0%  iozone.524288KB_8192reclen.freread
   2921618 ± 13%     -21.7%    2288382 ±  0%  iozone.64KB_8reclen.fwrite
   4720964 ±  6%     +22.1%    5764336 ± 11%  iozone.128KB_128reclen.record_rewrite
   8197712 ± 14%     -27.5%    5942111 ±  4%  iozone.262144KB_2048reclen.random_read
   3250503 ± 17%     +29.7%    4215130 ±  0%  iozone.8192KB_8192reclen.frewrite
   3539923 ±  9%     -22.0%    2762574 ±  5%  iozone.256KB_16reclen.fwrite
   8277227 ±  1%     -27.2%    6029824 ±  0%  iozone.8192KB_16reclen.reread
   5988294 ±  2%     +19.7%    7168885 ± 14%  iozone.8192KB_32reclen.fread
   5140772 ±  0%     -26.8%    3761046 ±  0%  iozone.524288KB_16384reclen.reread
   5352979 ± 12%     -29.3%    3785540 ±  7%  iozone.512KB_64reclen.rewrite
   7493022 ± 18%     +29.3%    9689073 ± 10%  iozone.4096KB_64reclen.reread
   6782461 ± 12%     +23.9%    8403419 ±  1%  iozone.256KB_32reclen.fread
   4272580 ±  2%     -27.9%    3080979 ±  0%  iozone.262144KB_2048reclen.write
   4182353 ± 12%     +26.3%    5281188 ±  0%  iozone.65536KB_8192reclen.read
   7724548 ±  0%      -2.5%    7529971 ±  1%  iozone.4096KB_4096reclen.reread
   9585735 ±  9%     +25.5%   12034330 ±  3%  iozone.2048KB_64reclen.reread
   4328543 ± 21%     -30.2%    3020814 ±  0%  iozone.131072KB_8192reclen.stride_read
   5474696 ± 34%     +45.3%    7955774 ±  1%  iozone.8192KB_2048reclen.freread
   6145365 ±  3%     +18.1%    7258564 ± 14%  iozone.8192KB_64reclen.stride_read
   8875731 ± 10%     +39.5%   12377375 ±  2%  iozone.2048KB_512reclen.reread
   7740075 ±  3%     +25.8%    9739699 ±  6%  iozone.2048KB_32reclen.read
   6901705 ± 20%     +26.7%    8744111 ±  4%  iozone.1024KB_16reclen.fread
   8359584 ±  1%     +27.6%   10668396 ±  3%  iozone.256KB_64reclen.stride_read
   8450512 ±  5%     +31.3%   11091721 ±  0%  iozone.256KB_256reclen.stride_read
   4355136 ±  2%     +25.6%    5468706 ±  5%  iozone.512KB_32reclen.frewrite
   5208724 ±  1%     -32.6%    3508395 ± 11%  iozone.32768KB_16384reclen.random_read
   3209577 ± 13%     -19.0%    2598777 ±  0%  iozone.32768KB_16384reclen.write
   8195860 ±  2%     -26.3%    6041688 ±  0%  iozone.8192KB_16reclen.read
   5404751 ±  3%     +30.9%    7075305 ± 13%  iozone.128KB_128reclen.random_write
   9151836 ±  1%     -25.5%    6820128 ±  0%  iozone.262144KB_1024reclen.read
   5093159 ±  3%     -30.9%    3516955 ± 11%  iozone.65536KB_16384reclen.stride_read
   7331754 ± 13%     +17.9%    8641522 ±  2%  iozone.32768KB_256reclen.freread
   8045454 ±  2%     -24.6%    6066614 ±  0%  iozone.8192KB_16reclen.freread
   4727302 ± 25%     +35.8%    6417749 ± 10%  iozone.64KB_8reclen.bkwd_read
   3122931 ±  8%     +25.8%    3929301 ±  0%  iozone.524288KB_64reclen.write
   3809641 ± 13%     +23.2%    4694921 ±  9%  iozone.65536KB_8192reclen.fread
  10294877 ± 22%     +34.1%   13809422 ±  2%  iozone.256KB_32reclen.random_read
   3875132 ±  3%     -25.7%    2878020 ±  0%  iozone.262144KB_8192reclen.record_rewrite
   3521943 ±  0%     +19.8%    4218470 ±  9%  iozone.16384KB_256reclen.write
   3263246 ± 11%     -20.5%    2592835 ±  3%  iozone.131072KB_8192reclen.record_rewrite
   9118649 ±  5%     +18.3%   10790863 ± 10%  iozone.512KB_64reclen.reread
   4387342 ±  1%      +4.1%    4566992 ±  0%  iozone.32768KB_4096reclen.record_rewrite
   7716943 ±  6%     +16.4%    8980781 ±  6%  iozone.1024KB_64reclen.bkwd_read
   8751240 ±  0%     -11.6%    7738113 ±  0%  iozone.131072KB_1024reclen.reread
   5503178 ±  1%     -29.4%    3885602 ± 10%  iozone.131072KB_4096reclen.freread
   8867546 ±  4%     +15.7%   10257049 ±  8%  iozone.1024KB_256reclen.bkwd_read
   6118367 ±  6%     +12.5%    6880962 ± 11%  iozone.8192KB_128reclen.bkwd_read
   7474083 ± 10%     +19.8%    8950225 ±  0%  iozone.65536KB_2048reclen.freread
   1902231 ± 11%     +14.8%    2183057 ±  5%  iozone.64KB_4reclen.record_rewrite
   6412619 ±  6%     +12.4%    7206535 ± 10%  iozone.8192KB_32reclen.freread
   2383411 ±  6%     +20.7%    2877496 ±  9%  iozone.8192KB_8192reclen.write
   6474625 ±  4%     -31.5%    4437342 ± 15%  iozone.256KB_64reclen.record_rewrite
   7551263 ± 12%     +17.6%    8877760 ±  0%  iozone.32768KB_128reclen.freread
   7258589 ±  6%     +11.1%    8061492 ± 10%  iozone.1024KB_128reclen.random_write
   2318350 ±  3%     +20.7%    2797222 ±  4%  iozone.128KB_32reclen.write
   9532159 ±  6%     -28.4%    6824469 ±  5%  iozone.2048KB_128reclen.bkwd_read
   9810530 ±  9%     -23.8%    7480347 ±  7%  iozone.256KB_4reclen.freread
   7178801 ±  6%     +26.8%    9104334 ±  1%  iozone.2048KB_512reclen.fread
   4073068 ±  5%     +27.3%    5183826 ±  1%  iozone.8192KB_512reclen.fwrite
   5217651 ±  0%     -20.9%    4129184 ±  4%  iozone.131072KB_1024reclen.random_write
   3568302 ± 10%     -27.8%    2577833 ±  2%  iozone.131072KB_8192reclen.random_write
   4348780 ± 11%     +10.8%    4818282 ± 10%  iozone.512KB_32reclen.fwrite
   9316483 ±  6%     -28.2%    6687738 ±  4%  iozone.1024KB_4reclen.read
   6755316 ± 14%     +19.5%    8070595 ±  3%  iozone.4096KB_64reclen.random_write
   4996612 ±  2%     -20.5%    3974292 ±  1%  iozone.524288KB_8192reclen.reread
   4363175 ±  6%     +14.6%    4999657 ±  6%  iozone.256KB_128reclen.fwrite
   4250330 ±  5%      +7.5%    4567501 ±  1%  iozone.65536KB_4096reclen.record_rewrite
   4856767 ± 10%     -15.9%    4085386 ±  1%  iozone.65536KB_8192reclen.reread
   3894694 ± 10%     +15.3%    4489754 ±  0%  iozone.65536KB_256reclen.write
   4489243 ±  4%     +12.5%    5049573 ±  7%  iozone.1024KB_32reclen.frewrite
   4854507 ±  6%     -13.4%    4206416 ±  2%  iozone.262144KB_8192reclen.reread
  10392729 ±  6%     -30.2%    7253300 ± 17%  iozone.256KB_16reclen.stride_read
   8034794 ±  6%     -23.0%    6187632 ±  9%  iozone.131072KB_2048reclen.reread
   3663595 ± 24%     +25.2%    4586005 ±  6%  iozone.64KB_32reclen.random_write
   3426596 ±  2%     -23.6%    2617824 ±  0%  iozone.32768KB_8192reclen.write
  10121807 ± 11%     -21.5%    7949244 ±  2%  iozone.512KB_64reclen.freread
   8849875 ±  2%      +4.6%    9254086 ±  0%  iozone.65536KB_128reclen.random_read
   6922909 ± 14%     +27.7%    8843304 ±  1%  iozone.65536KB_256reclen.bkwd_read
   4762555 ± 13%     -23.2%    3656779 ±  5%  iozone.128KB_32reclen.record_rewrite
   7493376 ± 12%     +14.0%    8542375 ±  4%  iozone.4096KB_16reclen.stride_read
   7404571 ± 11%     +16.0%    8587206 ±  0%  iozone.16384KB_8reclen.reread
   2252570 ±  1%     +17.3%    2643162 ±  4%  iozone.512KB_4reclen.write
   8221058 ± 12%     -28.4%    5886115 ± 11%  iozone.256KB_32reclen.bkwd_read
   9117257 ± 18%     +23.5%   11256055 ±  1%  iozone.512KB_8reclen.freread
   7731661 ±  2%     +15.0%    8894151 ±  5%  iozone.2048KB_16reclen.stride_read
    578942 ± 10%     +13.3%     656090 ±  8%  iozone.64KB_32reclen
  13443230 ±  7%     -14.5%   11497132 ±  1%  iozone.512KB_32reclen.random_read
    472463 ±  3%     -19.2%     381698 ±  0%  iozone.131072KB_4096reclen
   8025688 ± 13%     +18.2%    9485232 ±  0%  iozone.1024KB_16reclen.bkwd_read
   3883697 ±  6%     +19.5%    4640601 ±  1%  iozone.16384KB_64reclen.write
   8604036 ± 10%     +22.9%   10573638 ±  3%  iozone.512KB_256reclen.freread
    687415 ±  5%     -18.7%     558826 ±  3%  iozone.131072KB_2048reclen
   8888491 ±  7%     +14.8%   10202126 ±  3%  iozone.2048KB_32reclen.stride_read
   7718415 ±  9%     +13.3%    8747529 ±  0%  iozone.131072KB_64reclen.bkwd_read
   8188173 ±  6%     +10.9%    9083352 ±  6%  iozone.512KB_512reclen.stride_read
   5822892 ±  9%     -13.4%    5044342 ±  1%  iozone.512KB_128reclen.frewrite
   7510973 ±  3%     +22.8%    9225029 ±  0%  iozone.524288KB_512reclen.stride_read
   9732731 ± 12%     +25.1%   12175311 ±  1%  iozone.1024KB_128reclen.reread
   3910528 ±  8%     +13.4%    4433939 ±  1%  iozone.1024KB_128reclen.write
   5229285 ±  0%     +17.5%    6143606 ±  2%  iozone.2048KB_2048reclen.fwrite
   3740977 ±  3%      +7.3%    4013075 ±  8%  iozone.65536KB_512reclen.write
   7973715 ±  5%     +15.9%    9240823 ±  3%  iozone.2048KB_64reclen.read
   5347544 ±  4%     -12.6%    4674344 ±  6%  iozone.512KB_64reclen.fwrite
   9148256 ±  9%     +10.0%   10066331 ±  5%  iozone.2048KB_256reclen.freread
   7532427 ±  2%     +20.0%    9038408 ±  0%  iozone.524288KB_64reclen.random_read
   9116693 ±  0%     -16.3%    7627555 ±  0%  iozone.262144KB_1024reclen.bkwd_read
   9293134 ± 18%     +19.5%   11103803 ±  7%  iozone.2048KB_1024reclen.read
   3610496 ±  0%      +2.1%    3684779 ±  0%  iozone.262144KB_2048reclen.fwrite
   2841895 ±  6%     +13.6%    3228081 ±  0%  iozone.8192KB_4096reclen.fwrite
   3318265 ±  5%      +8.9%    3612894 ±  4%  iozone.512KB_8reclen.frewrite
   7649887 ±  5%     +11.8%    8552670 ±  5%  iozone.2048KB_256reclen.fread
   4824041 ±  9%     +13.5%    5477321 ±  3%  iozone.2048KB_1024reclen.fwrite
   2321590 ±  2%     +15.0%    2670161 ±  2%  iozone.256KB_4reclen.frewrite
   9060990 ±  1%     -15.5%    7655972 ±  0%  iozone.524288KB_512reclen.random_read
   4358431 ± 12%     -18.7%    3543052 ±  4%  iozone.131072KB_8192reclen.freread
   4348859 ±  4%     +10.8%    4817434 ±  4%  iozone.4096KB_16reclen.fwrite
   2489477 ±  7%     +10.2%    2743734 ±  1%  iozone.4096KB_4reclen.rewrite
   5103733 ±  0%      +3.4%    5279726 ±  0%  iozone.262144KB_8192reclen.stride_read
   3046196 ± 10%     -17.9%    2500831 ±  1%  iozone.131072KB_16384reclen.record_rewrite
   5121586 ±  2%     -16.7%    4265243 ±  1%  iozone.256KB_16reclen.random_write
   4094339 ±  5%     -10.8%    3653574 ±  0%  iozone.131072KB_1024reclen.write
  12251829 ±  7%     +11.4%   13652899 ±  0%  iozone.512KB_512reclen.random_read
   7690315 ±  7%     +15.2%    8860546 ±  0%  iozone.65536KB_256reclen.freread
   3898899 ±  6%     +11.4%    4341836 ±  0%  iozone.16384KB_16reclen.random_write
   8052112 ±  4%     +12.3%    9041701 ±  4%  iozone.2048KB_8reclen.read
   5168943 ±  6%     -15.5%    4367526 ±  0%  iozone.2048KB_128reclen.fwrite
   3728684 ±  1%     +13.5%    4233448 ±  0%  iozone.512KB_128reclen.write
  10231887 ± 14%     -18.5%    8334367 ±  2%  iozone.512KB_4reclen.reread
   4976350 ±  6%     -16.7%    4147433 ±  4%  iozone.512KB_16reclen.random_write
   5746415 ± 12%     -30.8%    3976333 ± 19%  iozone.256KB_64reclen.frewrite
   7090255 ± 25%     +26.7%    8986290 ±  0%  iozone.32768KB_64reclen.fread
   9078196 ±  1%     -14.4%    7769083 ±  1%  iozone.262144KB_1024reclen.reread
    718806 ±  4%     +13.0%     812074 ±  0%  iozone.64KB_64reclen
   3747212 ±  9%     -19.6%    3014476 ±  7%  iozone.256KB_16reclen.frewrite
   4284349 ±  0%     -15.1%    3636384 ± 12%  iozone.131072KB_1024reclen.fwrite
   3432219 ±  5%      +8.2%    3714618 ±  6%  iozone.8192KB_4096reclen.freread
   4877605 ±  7%     +11.2%    5423051 ±  3%  iozone.2048KB_128reclen.rewrite
   4039676 ±  9%     +13.9%    4601332 ±  0%  iozone.65536KB_128reclen.write
   2995131 ±  7%     +14.2%    3420783 ±  5%  iozone.256KB_8reclen.fwrite
   8335424 ±  5%     +11.0%    9254346 ±  0%  iozone.262144KB_1024reclen.fread
   4847523 ±  0%     -12.9%    4221362 ±  0%  iozone.131072KB_512reclen.fwrite
  10976125 ±  6%     +15.2%   12646489 ±  2%  iozone.1024KB_128reclen.stride_read
  10787523 ±  6%      +5.6%   11391254 ±  4%  iozone.1024KB_64reclen.stride_read
   8384570 ±  6%      +8.8%    9124939 ±  4%  iozone.1024KB_1024reclen.fread
   4668456 ±  3%     +10.0%    5137186 ±  1%  iozone.1024KB_256reclen.rewrite
   3077664 ± 11%     +15.1%    3541009 ±  5%  iozone.512KB_8reclen.rewrite
   5041323 ±  3%      +8.2%    5452436 ±  4%  iozone.2048KB_1024reclen.rewrite
  14889499 ±  4%     -31.4%   10212181 ± 25%  iozone.128KB_32reclen.random_read
   9904025 ±  5%     -19.4%    7984004 ±  6%  iozone.2048KB_128reclen.read
   5050003 ±  6%     +16.8%    5896199 ±  0%  iozone.32768KB_1024reclen.random_write
   3624991 ±  5%      +4.0%    3770555 ±  6%  iozone.1024KB_8reclen.fwrite
   7916217 ± 18%     +15.2%    9116069 ±  6%  iozone.4096KB_128reclen.reread
   6698440 ±  2%     -14.3%    5741172 ±  3%  iozone.1024KB_1024reclen.fwrite
   8067814 ±  5%     -18.4%    6580711 ±  4%  iozone.2048KB_8reclen.bkwd_read
   8789340 ±  0%      -7.7%    8109325 ±  5%  iozone.131072KB_128reclen.reread
   4839847 ±  4%     -17.2%    4006617 ±  3%  iozone.512KB_512reclen.rewrite
   9400749 ±  4%      +8.4%   10192299 ±  0%  iozone.2048KB_4reclen.random_read
   4455272 ±  2%     -17.5%    3676614 ±  5%  iozone.1024KB_16reclen.fwrite
   3114613 ±  3%      +7.1%    3334851 ±  5%  iozone.1024KB_8reclen.write
   4980243 ±  8%      +9.2%    5438915 ±  2%  iozone.8192KB_128reclen.fwrite
   3785353 ±  7%      +8.0%    4090008 ±  2%  iozone.1024KB_32reclen.write
         8 ±  0%     +12.5%          9 ±  0%  iozone.time.percent_of_cpu_this_job_got
    620886 ±  3%      +8.8%     675294 ±  1%  iozone.524288KB_2048reclen
   3413236 ±  5%      +5.0%    3582992 ±  5%  iozone.1024KB_8reclen.rewrite
    618456 ±  4%      +4.4%     645493 ±  4%  iozone.8192KB_32reclen
   8315952 ±  4%      +7.5%    8943417 ±  1%  iozone.65536KB_256reclen.reread
   7913618 ±  6%     +11.8%    8845045 ±  0%  iozone.16384KB_128reclen.random_read
   4233723 ±  3%      +5.6%    4469238 ±  4%  iozone.4096KB_16reclen.rewrite
   7895734 ±  4%     -18.7%    6416209 ± 13%  iozone.4096KB_16reclen.bkwd_read
   4481824 ±  2%     +19.5%    5355949 ±  0%  iozone.8192KB_64reclen.fwrite
   8631125 ±  5%      +7.4%    9265669 ±  0%  iozone.65536KB_2048reclen.random_read
   3004260 ± 19%     +15.7%    3477316 ±  5%  iozone.128KB_128reclen.write
   5138964 ±  8%     +15.2%    5918377 ±  0%  iozone.4096KB_64reclen.fwrite
   8558023 ±  5%      +7.5%    9203339 ±  3%  iozone.256KB_4reclen.reread
   2286884 ±  2%      +8.0%    2470446 ±  3%  iozone.64KB_16reclen.fwrite
   3932842 ±  3%      +8.5%    4266645 ±  1%  iozone.1024KB_16reclen.rewrite
   4558245 ±  0%     -10.3%    4089833 ±  0%  iozone.8192KB_16reclen.random_write
   4386732 ±  0%     -14.5%    3749266 ±  0%  iozone.32768KB_512reclen.write
   7341150 ±  4%      +6.4%    7813536 ±  1%  iozone.16384KB_8reclen.random_read
   8376231 ±  3%      +9.0%    9126687 ±  1%  iozone.2048KB_512reclen.read
   8032190 ±  3%     +11.3%    8938556 ±  0%  iozone.65536KB_256reclen.read
  10922099 ± 24%     +30.0%   14200794 ±  0%  iozone.128KB_128reclen.read
   5344071 ±  1%      +7.2%    5728578 ±  3%  iozone.2048KB_32reclen.fwrite
   3539347 ±  4%      +6.6%    3774150 ±  1%  iozone.65536KB_2048reclen.fwrite
   2805718 ±  4%     -18.9%    2274675 ± 12%  iozone.4096KB_4reclen.record_rewrite
   4812062 ±  7%      +9.2%    5256356 ±  0%  iozone.32768KB_8192reclen.reread
    393057 ±  4%      +6.2%     417250 ±  1%  iozone.524288KB_8192reclen
   7219552 ±  5%      +7.9%    7786633 ±  1%  iozone.2048KB_1024reclen.record_rewrite
   5259188 ±  1%     -17.1%    4358000 ±  9%  iozone.262144KB_16384reclen.reread
   8092792 ±  6%      +9.1%    8829873 ±  0%  iozone.16384KB_2048reclen.read
    718746 ±  2%      +6.6%     765960 ±  1%  iozone.2048KB_16reclen
   9683795 ±  3%     -29.0%    6879528 ± 28%  iozone.4096KB_2048reclen.stride_read
   4110070 ±  4%      +6.3%    4368383 ±  1%  iozone.1024KB_8reclen.record_rewrite
   8039446 ±  5%      +9.3%    8785884 ±  0%  iozone.16384KB_256reclen.reread
   8484403 ±  3%      +4.7%    8883833 ±  0%  iozone.32768KB_256reclen.random_read
  12636319 ±  6%     -16.0%   10611712 ±  7%  iozone.1024KB_1024reclen.read
   6763506 ± 14%     +19.4%    8077808 ±  0%  iozone.4096KB_256reclen.fread
   7476510 ±  1%      +6.5%    7962242 ±  3%  iozone.4096KB_512reclen.record_rewrite
    749887 ±  4%      +7.1%     803484 ±  0%  iozone.4096KB_256reclen
   8207035 ±  2%     -12.5%    7178405 ±  9%  iozone.2048KB_128reclen.record_rewrite
   4138686 ±  9%     +11.8%    4625728 ±  2%  iozone.256KB_64reclen.rewrite
   2571399 ±  1%      -9.5%    2326457 ±  1%  iozone.2048KB_4reclen.frewrite
   7552793 ±  2%      +5.8%    7989546 ±  2%  iozone.65536KB_2048reclen.record_rewrite
   8295281 ±  1%      +5.8%    8779713 ±  3%  iozone.8192KB_128reclen.read
   5597466 ±  1%     -15.1%    4750831 ±  8%  iozone.262144KB_4096reclen.reread
   3280285 ±  0%      +1.8%    3337806 ±  0%  iozone.262144KB_8192reclen.fwrite
   2576207 ±  3%      +5.2%    2711076 ±  3%  iozone.1024KB_4reclen.write
    678845 ±  3%      +3.9%     705564 ±  3%  iozone.524288KB_256reclen
  12627771 ±  2%     -10.7%   11275314 ±  4%  iozone.2048KB_2048reclen.random_read
   3677955 ±  3%      +4.6%    3848068 ±  1%  iozone.16384KB_8reclen.rewrite
    722786 ±  1%      -7.9%     666043 ±  0%  iozone.131072KB_1024reclen
   7960527 ± 14%     +17.3%    9340298 ±  0%  iozone.65536KB_128reclen.reread
   3502223 ± 19%     +19.0%    4167876 ±  1%  iozone.16384KB_4096reclen.rewrite
   5551577 ±  1%     -14.1%    4769927 ±  0%  iozone.131072KB_256reclen.random_write
   8696931 ±  0%     -11.2%    7724092 ±  3%  iozone.131072KB_128reclen.fread
   4069311 ±  6%      +9.2%    4442327 ±  0%  iozone.2048KB_8reclen.record_rewrite
    722377 ±  2%      -9.9%     651034 ±  2%  iozone.262144KB_2048reclen
   1834196 ± 25%     +20.4%    2209265 ±  3%  iozone.128KB_4reclen.write
   5138057 ±  1%     -11.0%    4571125 ±  2%  iozone.524288KB_16384reclen.random_read
   8282824 ±  3%      -9.1%    7531868 ±  0%  iozone.262144KB_256reclen.bkwd_read
  14346407 ±  2%     -10.6%   12826594 ±  4%  iozone.512KB_64reclen.random_read
   8610754 ±  3%      +3.1%    8879944 ±  3%  iozone.65536KB_512reclen.random_read
   6283152 ± 37%     +32.0%    8295378 ±  1%  iozone.16384KB_8reclen.fread
   8681267 ±  0%     -18.2%    7099340 ± 12%  iozone.16384KB_512reclen.bkwd_read
   4371321 ±  7%      +7.6%    4705433 ±  4%  iozone.1024KB_32reclen.rewrite
   4862202 ±  1%      +6.9%    5200107 ±  1%  iozone.4096KB_256reclen.rewrite
   5590147 ±  6%      +6.9%    5973519 ±  2%  iozone.2048KB_64reclen.fwrite
   8615326 ±  3%      -9.3%    7815110 ±  4%  iozone.262144KB_512reclen.bkwd_read
   8623349 ±  3%      +6.7%    9199759 ±  0%  iozone.524288KB_128reclen.stride_read
      1290 ±  0%      -8.9%       1175 ±  0%  iozone.time.elapsed_time
      1290 ±  0%      -8.9%       1175 ±  0%  iozone.time.elapsed_time.max
   5118732 ±  2%      -8.9%    4664576 ±  1%  iozone.262144KB_512reclen.rewrite
   5397923 ±  4%      +5.6%    5702108 ±  1%  iozone.32768KB_2048reclen.random_write
   8418676 ±  3%      +5.5%    8881409 ±  0%  iozone.131072KB_256reclen.stride_read
   4219879 ±  1%     -19.3%    3405999 ± 14%  iozone.16384KB_16384reclen.random_write
   4212419 ±  2%     -14.5%    3600701 ±  9%  iozone.512KB_8reclen.record_rewrite
   5690229 ±  4%      +5.9%    6028126 ±  0%  iozone.16384KB_4096reclen.random_read
   4177221 ±  2%     -11.6%    3691015 ±  5%  iozone.512KB_16reclen.frewrite
   3632679 ±  2%      +7.5%    3906683 ±  2%  iozone.65536KB_16384reclen.rewrite
    630500 ±  0%      -7.3%     584468 ±  0%  iozone.8192KB_16reclen
    476250 ±  1%      -5.2%     451306 ±  0%  iozone.262144KB_4096reclen
   4761764 ±  3%     -13.8%    4105680 ±  7%  iozone.1024KB_16reclen.frewrite
    440579 ±  2%      -5.1%     417928 ±  0%  iozone.262144KB_8192reclen
   4944802 ±  4%      +6.7%    5275429 ±  0%  iozone.4096KB_64reclen.frewrite
   8388834 ±  4%      +5.9%    8881159 ±  0%  iozone.65536KB_256reclen.random_read
  13208377 ±  3%      -8.8%   12044935 ±  2%  iozone.1024KB_256reclen.reread
   3267837 ±  1%     +11.8%    3653307 ±  1%  iozone.16384KB_1024reclen.write
   2934685 ± 11%     +11.5%    3273363 ±  0%  iozone.524288KB_8192reclen.frewrite
   8298872 ±  3%      +5.5%    8754890 ±  3%  iozone.16384KB_128reclen.bkwd_read
   5310937 ±  4%      +9.1%    5796197 ±  0%  iozone.262144KB_4096reclen.freread
   7770699 ± 14%     +14.6%    8905169 ±  2%  iozone.65536KB_128reclen.bkwd_read
    539518 ±  1%      +3.7%     559486 ±  3%  iozone.256KB_4reclen
   4301008 ± 16%     +18.0%    5076857 ±  0%  iozone.131072KB_8192reclen.bkwd_read
   7490770 ±  3%      +2.1%    7650614 ±  3%  iozone.2048KB_64reclen.record_rewrite
   8474515 ±  2%      +8.6%    9201379 ±  0%  iozone.131072KB_128reclen.bkwd_read
   9752632 ±  3%      +1.9%    9935002 ±  3%  iozone.8192KB_128reclen.random_read
   5918384 ± 12%     +10.5%    6539287 ±  3%  iozone.2048KB_4reclen.bkwd_read
   2646987 ±  5%      +7.8%    2853445 ±  0%  iozone.4096KB_4reclen.write
   8244553 ±  4%      +9.6%    9037092 ±  0%  iozone.16384KB_128reclen.reread
   8103373 ±  7%      +8.7%    8807564 ±  2%  iozone.131072KB_512reclen.bkwd_read
   8695727 ±  5%      +5.5%    9177772 ±  2%  iozone.16384KB_64reclen.random_read
   5117574 ±  1%      +4.6%    5353731 ±  1%  iozone.2048KB_64reclen.rewrite
   8499282 ±  1%      +6.5%    9049599 ±  0%  iozone.131072KB_512reclen.stride_read
    736436 ±  0%      -5.7%     694742 ±  0%  iozone.131072KB_512reclen
  13251967 ±  5%      +7.4%   14226322 ±  0%  iozone.2048KB_64reclen.random_read
   4842288 ±  3%      +6.8%    5172749 ±  1%  iozone.32768KB_8192reclen.random_read
   5632428 ±  3%      +6.0%    5971338 ±  2%  iozone.16384KB_128reclen.random_write
   8232506 ± 10%      +8.7%    8946073 ±  1%  iozone.16384KB_256reclen.random_read
   5224250 ±  1%      +4.5%    5457558 ±  1%  iozone.131072KB_128reclen.rewrite
   7799129 ±  7%      +8.7%    8476105 ±  0%  iozone.131072KB_256reclen.bkwd_read
    706404 ±  6%      +7.5%     759081 ±  1%  iozone.4096KB_64reclen
   3741897 ±  4%      +6.3%    3976035 ±  1%  iozone.32768KB_4096reclen.rewrite
   7867821 ±  1%      +5.7%    8312843 ±  0%  iozone.131072KB_512reclen.record_rewrite
   3213089 ±  1%      +4.9%    3371794 ±  1%  iozone.262144KB_4096reclen.fwrite
   3963945 ± 18%     +16.8%    4628496 ±  0%  iozone.4096KB_2048reclen.fwrite
  12632973 ±  4%      +8.7%   13731024 ±  0%  iozone.1024KB_16reclen.random_read
   5706448 ±  5%      +6.3%    6068351 ±  0%  iozone.16384KB_4096reclen.reread
  12029016 ±  3%      +7.4%   12922022 ±  0%  iozone.2048KB_16reclen.random_read
   8566438 ±  1%     -11.1%    7616198 ±  6%  iozone.131072KB_512reclen.reread
   1752687 ± 10%     +14.2%    2000974 ±  0%  iozone.128KB_4reclen.fwrite
   6353720 ± 21%     +17.1%    7442978 ±  1%  iozone.256KB_8reclen.bkwd_read
   7892141 ± 14%     +14.9%    9069494 ±  1%  iozone.65536KB_128reclen.read
   5280056 ±  2%      -9.5%    4779680 ±  5%  iozone.8192KB_64reclen.frewrite
   3881212 ±  3%     -16.3%    3246640 ± 10%  iozone.262144KB_16384reclen.record_rewrite
   3634480 ±  2%      -6.7%    3390913 ±  0%  iozone.512KB_32reclen.write
   3599606 ±  6%      +9.4%    3939272 ±  0%  iozone.1024KB_8reclen.random_write
   8721661 ±  9%     -10.7%    7791708 ±  0%  iozone.256KB_4reclen.random_read
   2090471 ± 19%     -34.5%    1368296 ± 25%  iozone.64KB_4reclen.fwrite
   3820137 ± 17%     +16.0%    4430091 ±  0%  iozone.262144KB_1024reclen.frewrite
    848883 ±  3%      +4.1%     883999 ±  1%  iozone.512KB_128reclen
   2898218 ± 17%     +14.3%    3311275 ±  1%  iozone.16384KB_16384reclen.write
    711350 ±  0%      +4.0%     739847 ±  1%  iozone.65536KB_256reclen
    528192 ±  3%      +7.9%     570016 ±  0%  iozone.8192KB_2048reclen
   4699597 ±  2%      +5.5%    4957064 ±  1%  iozone.4096KB_32reclen.frewrite
   5049490 ±  5%      -7.0%    4693935 ±  0%  iozone.16384KB_16384reclen.read
   4192784 ±  1%     -16.0%    3519980 ± 12%  iozone.8192KB_4096reclen.random_write
   8570663 ±  0%      +3.3%    8855987 ±  2%  iozone.65536KB_128reclen.record_rewrite
   4278997 ±  0%      -5.4%    4046871 ±  0%  iozone.1024KB_64reclen.write
   8435258 ±  1%      -7.3%    7819757 ±  2%  iozone.131072KB_256reclen.reread
  13740909 ±  2%      -8.0%   12646489 ±  2%  iozone.1024KB_32reclen.random_read
   5393444 ±  2%      +3.5%    5581472 ±  1%  iozone.8192KB_128reclen.rewrite
   4817848 ±  1%      +3.8%    5000078 ±  1%  iozone.262144KB_512reclen.frewrite
   4751289 ±  1%      +3.3%    4908770 ±  1%  iozone.32768KB_2048reclen.rewrite
   5205405 ±  9%      +8.9%    5667739 ±  1%  iozone.16384KB_2048reclen.random_write
  14369401 ±  1%      +3.2%   14832934 ±  1%  iozone.512KB_128reclen.random_read
   8601039 ±  1%      +5.3%    9059717 ±  0%  iozone.131072KB_1024reclen.stride_read
   7725345 ± 19%     +16.2%    8980339 ±  0%  iozone.1024KB_512reclen.bkwd_read
   8189918 ± 10%     +10.9%    9085758 ±  1%  iozone.65536KB_512reclen.freread
   5525682 ±  1%      -9.0%    5026193 ±  6%  iozone.131072KB_512reclen.random_write
   7186070 ±  3%      +4.5%    7509587 ±  1%  iozone.16384KB_4reclen.read
   5014894 ±  0%      +2.6%    5144714 ±  2%  iozone.131072KB_128reclen.frewrite
   8689927 ±  2%     -11.1%    7722061 ±  6%  iozone.524288KB_256reclen.bkwd_read
   7779429 ±  2%      -8.6%    7112578 ±  2%  iozone.1024KB_256reclen.record_rewrite
   5144245 ±  2%     -10.4%    4607355 ±  6%  iozone.16384KB_128reclen.frewrite
   2693551 ±  3%      +3.4%    2785077 ±  1%  iozone.2048KB_4reclen.record_rewrite
   8968489 ±  0%     -10.0%    8070177 ±  5%  iozone.524288KB_128reclen.random_read
  13581297 ±  1%      +3.5%   14056095 ±  1%  iozone.512KB_256reclen.random_read
   8219973 ±  2%      -6.5%    7682016 ±  1%  iozone.262144KB_64reclen.record_rewrite
   7435724 ±  5%      +5.7%    7861861 ±  2%  iozone.8192KB_512reclen.record_rewrite
   8406962 ±  1%      +6.6%    8965829 ±  0%  iozone.131072KB_2048reclen.stride_read
   3960043 ±  4%      -7.2%    3676895 ±  0%  iozone.16384KB_16reclen.write
   3478696 ±  2%      +5.6%    3672851 ±  0%  iozone.65536KB_2048reclen.frewrite
   5145881 ±  2%     -17.4%    4250075 ± 13%  iozone.524288KB_16384reclen.fread
    752211 ±  0%      -4.0%     722374 ±  0%  iozone.131072KB_128reclen
   5020800 ±  1%      +4.0%    5219629 ±  1%  iozone.65536KB_256reclen.rewrite
   8948722 ±  1%      +4.4%    9341540 ±  0%  iozone.524288KB_2048reclen.fread
   4850242 ±  2%      +3.7%    5031843 ±  0%  iozone.65536KB_1024reclen.rewrite
   4966369 ± 15%     +15.4%    5730703 ±  0%  iozone.524288KB_4096reclen.stride_read
   6952176 ± 15%     +11.5%    7754097 ±  2%  iozone.4096KB_32reclen.fread
   9041612 ±  2%      +2.6%    9279240 ±  0%  iozone.262144KB_2048reclen.freread
   4927943 ±  0%      +3.7%    5107872 ±  1%  iozone.65536KB_256reclen.fwrite
   5145327 ±  1%      -5.2%    4875664 ±  0%  iozone.524288KB_16384reclen.bkwd_read
    746903 ±  1%      -3.5%     720758 ±  0%  iozone.262144KB_64reclen
   2141436 ±  6%      +5.8%    2266570 ±  0%  iozone.16384KB_4reclen.random_write
   8894902 ±  1%      -5.3%    8425790 ±  0%  iozone.32768KB_128reclen.random_read
   6284873 ±  1%      +2.6%    6448006 ±  1%  iozone.8192KB_64reclen.bkwd_read
   5472662 ±  6%      +5.4%    5767528 ±  1%  iozone.16384KB_64reclen.random_write
   8802415 ±  1%      +5.5%    9290691 ±  0%  iozone.131072KB_128reclen.freread
   6825709 ± 16%     -14.7%    5823936 ±  0%  iozone.8192KB_512reclen.bkwd_read
   9002211 ±  1%      +3.2%    9293885 ±  0%  iozone.524288KB_2048reclen.freread
   9060520 ±  0%      +4.2%    9442930 ±  0%  iozone.524288KB_1024reclen.reread
   8570321 ±  1%      +3.0%    8824025 ±  1%  iozone.8192KB_128reclen.reread
   5511902 ±  3%      +5.4%    5811039 ±  0%  iozone.262144KB_4096reclen.fread
   7290581 ±  2%      +3.4%    7541658 ±  1%  iozone.512KB_64reclen.record_rewrite
   8557473 ± 15%     +15.3%    9868433 ±  0%  iozone.256KB_64reclen.reread
   8914463 ±  1%      +4.9%    9355452 ±  0%  iozone.262144KB_64reclen.fread
    799025 ±  1%      +4.3%     833154 ±  1%  iozone.2048KB_256reclen
   3713883 ±  2%      -3.4%    3588362 ±  0%  iozone.131072KB_64reclen.write
    755537 ±  1%      +1.7%     768587 ±  1%  iozone.1024KB_16reclen
    710165 ±  1%      +3.5%     734717 ±  1%  iozone.1024KB_8reclen
   8835260 ±  4%      +5.1%    9284112 ±  0%  iozone.524288KB_1024reclen.stride_read
   3529822 ±  1%      +3.8%    3663421 ±  0%  iozone.131072KB_8192reclen.rewrite
   7863389 ± 14%     +12.6%    8855866 ±  0%  iozone.16384KB_128reclen.read
   5670555 ±  0%      -4.3%    5429164 ±  0%  iozone.262144KB_4096reclen.bkwd_read
    860746 ±  1%      +2.9%     886092 ±  1%  iozone.1024KB_128reclen
   5633521 ±  3%      -7.7%    5198984 ±  1%  iozone.1024KB_32reclen.fwrite
    722227 ±  1%      -3.9%     693896 ±  0%  iozone.262144KB_1024reclen
   2465364 ±  1%      +2.9%    2537975 ±  0%  iozone.1024KB_4reclen.frewrite
   4096279 ±  5%      +4.0%    4261022 ±  1%  iozone.1024KB_512reclen.write
   8709898 ±  6%      +7.6%    9368367 ±  0%  iozone.524288KB_64reclen.reread
   5650560 ±  3%     -10.8%    5041445 ±  4%  iozone.1024KB_512reclen.fwrite
   4978457 ±  6%      +7.3%    5343755 ±  0%  iozone.16384KB_8192reclen.read
   4506463 ± 16%     +12.9%    5086235 ±  0%  iozone.131072KB_8192reclen.fread
   8756733 ±  2%      +2.1%    8939757 ±  1%  iozone.8192KB_2048reclen.read
   6435816 ± 11%     +10.5%    7109834 ±  1%  iozone.2048KB_1024reclen.frewrite
   8246013 ±  6%      +6.3%    8762089 ±  1%  iozone.16384KB_512reclen.fread
   5154158 ±  2%      +2.6%    5286682 ±  1%  iozone.131072KB_64reclen.rewrite
   8288609 ±  2%      +3.4%    8571211 ±  0%  iozone.32768KB_2048reclen.freread
   4997063 ±  2%      +5.5%    5273138 ±  0%  iozone.262144KB_8192reclen.fread
    731906 ±  0%      -2.7%     711971 ±  1%  iozone.131072KB_256reclen
   7568695 ±  0%      -5.0%    7190624 ±  1%  iozone.8192KB_4reclen.reread
   4857649 ±  3%      +5.2%    5109039 ±  0%  iozone.131072KB_16384reclen.bkwd_read
   4305394 ±  4%      +4.7%    4509380 ±  0%  iozone.16384KB_4096reclen.random_write
   8707732 ±  6%      +6.4%    9261780 ±  0%  iozone.262144KB_2048reclen.fread
   9053742 ±  1%      -4.2%    8670031 ±  0%  iozone.32768KB_128reclen.reread
  13147518 ±  1%      -4.4%   12565952 ±  0%  iozone.1024KB_256reclen.random_read
   8734670 ±  1%      +4.4%    9119246 ±  0%  iozone.524288KB_256reclen.freread
   5165047 ±  0%      +3.1%    5324018 ±  0%  iozone.524288KB_64reclen.rewrite
   5090097 ±  0%      +3.5%    5268805 ±  0%  iozone.262144KB_8192reclen.read
   8618018 ±  2%      +4.5%    9007477 ±  0%  iozone.16384KB_512reclen.read
   2596796 ±  4%      +4.6%    2717180 ±  1%  iozone.16384KB_4reclen.frewrite
   7537760 ±  1%      -4.4%    7202589 ±  0%  iozone.8192KB_4reclen.read
   4877143 ±  1%      +3.6%    5053563 ±  0%  iozone.131072KB_64reclen.frewrite
   8735163 ±  1%      -3.4%    8438783 ±  0%  iozone.16384KB_16reclen.reread
   7968658 ±  1%      -4.6%    7603941 ±  1%  iozone.262144KB_1024reclen.record_rewrite
   8474810 ±  0%      -2.7%    8241844 ±  0%  iozone.524288KB_64reclen.record_rewrite
   8374674 ±  1%      +2.6%    8589893 ±  0%  iozone.131072KB_256reclen.read
    506646 ±  2%      -5.1%     480998 ±  1%  iozone.8192KB_4reclen
   4264006 ± 16%     +15.3%    4916284 ±  1%  iozone.32768KB_8192reclen.bkwd_read
   8502362 ±  0%      +3.1%    8764301 ±  0%  iozone.16384KB_256reclen.stride_read
   4033525 ±  3%      -6.4%    3775337 ±  0%  iozone.4096KB_8reclen.fwrite
   8660785 ±  1%      +3.7%    8979059 ±  1%  iozone.65536KB_64reclen.fread
   4272540 ±  2%      +3.5%    4423901 ±  0%  iozone.32768KB_1024reclen.frewrite
   4660936 ± 20%     +15.5%    5384361 ±  1%  iozone.2048KB_2048reclen.frewrite
   8841767 ±  3%      +5.0%    9287418 ±  0%  iozone.524288KB_512reclen.bkwd_read
   8363629 ±  0%      -9.6%    7562760 ±  6%  iozone.131072KB_256reclen.freread
   4924284 ±  0%      +3.4%    5090277 ±  0%  iozone.262144KB_256reclen.frewrite
    444239 ±  0%      -4.0%     426444 ±  0%  iozone.32768KB_8192reclen
   7239692 ± 19%     +15.8%    8385359 ±  0%  iozone.16384KB_2048reclen.fread
   3186860 ±  6%      +6.4%    3390568 ±  1%  iozone.262144KB_16384reclen.fwrite
    693176 ±  3%      +2.9%     713360 ±  1%  iozone.4096KB_32reclen
   9876019 ±  6%     -10.6%    8824718 ±  3%  iozone.256KB_32reclen.reread
   3640648 ±  2%      -6.6%    3399521 ±  1%  iozone.2048KB_8reclen.frewrite
   5510551 ±  0%     -20.8%    4363318 ± 21%  iozone.8192KB_8192reclen.stride_read
   5075625 ±  2%      -7.1%    4713577 ±  4%  iozone.16384KB_8192reclen.frewrite
   3541634 ±  9%      +9.2%    3866061 ±  0%  iozone.16384KB_8reclen.fwrite
   4121169 ±  2%      -6.5%    3853787 ±  2%  iozone.16384KB_16384reclen.fwrite
   3760939 ±  1%      +2.7%    3861953 ±  0%  iozone.16384KB_8reclen.frewrite
   8157284 ±  1%      +2.9%    8396221 ±  0%  iozone.16384KB_256reclen.record_rewrite
   4994815 ±  1%     -20.4%    3977567 ± 22%  iozone.65536KB_16384reclen.reread
   9168752 ±  0%      +2.7%    9413922 ±  0%  iozone.524288KB_1024reclen.read
   4093851 ±  7%      +8.4%    4438329 ±  0%  iozone.262144KB_1024reclen.fwrite
   8775725 ±  0%      +1.6%    8916270 ±  0%  iozone.131072KB_128reclen.record_rewrite
   4899985 ±  6%      +7.6%    5271924 ±  0%  iozone.262144KB_16384reclen.fread
   5052411 ±  1%      +3.6%    5232803 ±  0%  iozone.524288KB_8192reclen.fread
   5138795 ±  3%      +3.4%    5311191 ±  1%  iozone.16384KB_16384reclen.freread
   8127109 ± 10%     +10.3%    8962844 ±  0%  iozone.32768KB_1024reclen.freread
   3240859 ±  0%      +4.2%    3375574 ±  0%  iozone.16384KB_8reclen.random_write
   8558845 ±  5%      +6.9%    9149078 ±  0%  iozone.262144KB_512reclen.fread
   9047729 ±  1%      +2.8%    9298371 ±  0%  iozone.524288KB_512reclen.fread
    598367 ±  1%      +2.2%     611721 ±  0%  iozone.16384KB_8reclen
   7924619 ± 15%     +13.2%    8971887 ±  0%  iozone.65536KB_128reclen.fread
   5934921 ±  0%     -12.5%    5192079 ± 10%  iozone.8192KB_1024reclen.random_write
   5794602 ±  2%      +2.8%    5958451 ±  1%  iozone.16384KB_256reclen.random_write
   8709385 ±  1%      +3.7%    9027315 ±  0%  iozone.131072KB_256reclen.random_read
   4140616 ±  3%      +4.3%    4320284 ±  0%  iozone.32768KB_8192reclen.random_write
   5549357 ±  0%      +2.9%    5711175 ±  0%  iozone.262144KB_512reclen.random_write
    732794 ±  4%      +5.1%     770280 ±  0%  iozone.65536KB_128reclen
   6523770 ±  1%      +1.5%    6621037 ±  1%  iozone.8192KB_128reclen.random_write
   3593208 ±  3%      -7.2%    3335532 ±  3%  iozone.131072KB_2048reclen.frewrite
   8285967 ±  0%      +2.0%    8449693 ±  1%  iozone.16384KB_64reclen.record_rewrite
 1.647e+08 ±  1%      +2.0%   1.68e+08 ±  1%  iozone.reread_KBps
   4720579 ± 11%     +10.0%    5191956 ±  0%  iozone.524288KB_16384reclen.stride_read
   5405499 ±  0%      +2.9%    5560629 ±  0%  iozone.131072KB_4096reclen.fread
   8492214 ±  7%      +7.3%    9111754 ±  0%  iozone.262144KB_512reclen.freread
   3609222 ±  1%      +1.2%    3651428 ±  1%  iozone.262144KB_2048reclen.frewrite
   3622658 ±  3%      +4.4%    3781302 ±  0%  iozone.8192KB_16reclen.write
   7708839 ±  3%      +4.8%    8079310 ±  0%  iozone.8192KB_1024reclen.record_rewrite
    821327 ±  1%      -3.0%     796539 ±  0%  iozone.512KB_64reclen
   6471648 ±  2%      +2.9%    6658424 ±  1%  iozone.16384KB_4reclen.bkwd_read
   7966254 ±  1%      +1.9%    8118825 ±  0%  iozone.524288KB_256reclen.record_rewrite
   9006794 ±  1%     -12.4%    7887715 ± 11%  iozone.32768KB_64reclen.freread
   4198799 ±  4%      +4.7%    4394653 ±  0%  iozone.4096KB_512reclen.write
    667396 ±  2%      +3.0%     687243 ±  0%  iozone.128KB_32reclen
   5131940 ±  1%      +2.0%    5234578 ±  0%  iozone.262144KB_8192reclen.freread
   2649388 ±  1%      -4.3%    2534745 ±  1%  iozone.1024KB_4reclen.fwrite
   8440344 ±  9%      +7.6%    9079989 ±  0%  iozone.16384KB_1024reclen.reread
   2567854 ±  1%      +1.5%    2607344 ±  0%  iozone.2048KB_4reclen.rewrite
   4829612 ±  3%      +3.8%    5011975 ±  0%  iozone.16384KB_512reclen.frewrite
   7509821 ±  1%      +2.0%    7661779 ±  0%  iozone.16384KB_8reclen.bkwd_read
   9245568 ±  1%      +1.4%    9376836 ±  0%  iozone.524288KB_64reclen.fread
   3664908 ±  0%      +1.7%    3726704 ±  0%  iozone.524288KB_16384reclen.rewrite
  1.82e+08 ±  0%      +0.6%  1.831e+08 ±  0%  iozone.random_read_KBps
   7963590 ± 15%     +13.0%    8997166 ±  0%  iozone.524288KB_256reclen.stride_read
   4818207 ±  7%      +5.4%    5078775 ±  0%  iozone.8192KB_256reclen.fwrite
   8282307 ±  1%      +3.2%    8547026 ±  0%  iozone.131072KB_256reclen.record_rewrite
    653264 ±  0%      +1.8%     664923 ±  0%  iozone.16384KB_16reclen
   4492579 ± 22%     +16.7%    5241982 ±  0%  iozone.524288KB_8192reclen.stride_read
   5068640 ±  0%      +2.3%    5184945 ±  0%  iozone.524288KB_16384reclen.read
   8477862 ± 12%      +9.0%    9241119 ±  0%  iozone.524288KB_2048reclen.bkwd_read
   3159354 ±  9%      +8.3%    3421414 ±  0%  iozone.262144KB_16384reclen.frewrite
   5271794 ±  5%      +4.5%    5511542 ±  0%  iozone.131072KB_4096reclen.bkwd_read
   2849172 ±  1%      -2.7%    2772173 ±  0%  iozone.16384KB_4reclen.record_rewrite
   9093349 ±  1%      +2.2%    9293596 ±  0%  iozone.524288KB_2048reclen.stride_read
   5991723 ±  0%      +1.9%    6107710 ±  0%  iozone.65536KB_128reclen.random_write
   5041457 ±  0%      +2.1%    5147851 ±  0%  iozone.32768KB_8192reclen.freread
   3202511 ±  5%      +5.4%    3374970 ±  0%  iozone.262144KB_4096reclen.frewrite
   4433969 ±  1%      -6.6%    4143523 ±  3%  iozone.8192KB_16reclen.rewrite
   9101889 ±  1%      +1.5%    9236783 ±  0%  iozone.524288KB_512reclen.read
   4859536 ±  9%      +8.8%    5285787 ±  0%  iozone.262144KB_16384reclen.freread
  79784238 ±  0%      -1.9%   78230145 ±  0%  iozone.fwrite_KBps
    740026 ±  0%      -2.8%     719505 ±  0%  iozone.262144KB_256reclen
   4103998 ±  5%      -5.4%    3881293 ±  0%  iozone.262144KB_512reclen.write
   5166349 ± 18%     +14.5%    5917164 ±  0%  iozone.16384KB_4096reclen.fread
   8542266 ±  4%      +3.8%    8868681 ±  0%  iozone.16384KB_128reclen.record_rewrite
   5234914 ±  2%      -4.1%    5019179 ±  1%  iozone.1024KB_1024reclen.rewrite
   8739322 ±  0%      -5.4%    8266567 ±  3%  iozone.131072KB_1024reclen.freread
   5088472 ±  1%      -2.8%    4944942 ±  0%  iozone.16384KB_32reclen.rewrite
   8587630 ± 10%      +8.4%    9307652 ±  0%  iozone.524288KB_128reclen.freread
   5809713 ±  0%     -10.0%    5230213 ±  8%  iozone.262144KB_128reclen.random_write
   4921492 ±  0%      -1.6%    4844785 ±  0%  iozone.262144KB_64reclen.frewrite
   3327837 ±  0%      -4.4%    3181225 ±  3%  iozone.131072KB_8192reclen.frewrite
   5762326 ±  1%      +1.4%    5845299 ±  0%  iozone.16384KB_16reclen.record_rewrite
   8542725 ±  0%      +1.3%    8656262 ±  0%  iozone.131072KB_1024reclen.read
   8031016 ±  9%      +7.8%    8657238 ±  0%  iozone.16384KB_1024reclen.fread
    438258 ±  0%      -4.1%     420454 ±  2%  iozone.65536KB_16384reclen
    771229 ±  0%      -5.1%     731522 ±  4%  iozone.262144KB_128reclen
    775060 ±  0%      +1.0%     783069 ±  0%  iozone.256KB_64reclen
   3800316 ±  0%      -3.4%    3672024 ±  1%  iozone.65536KB_16384reclen.frewrite
   7467330 ± 14%     +11.3%    8309007 ±  0%  iozone.8192KB_8reclen.reread
   5397975 ±  1%      -2.4%    5268371 ±  0%  iozone.524288KB_128reclen.rewrite
   2639373 ±  0%      +0.7%    2658316 ±  0%  iozone.16384KB_4reclen.rewrite
   5207951 ±  0%      +0.7%    5246733 ±  0%  iozone.65536KB_128reclen.fwrite
   8636430 ±  0%      -1.7%    8489977 ±  0%  iozone.131072KB_2048reclen.fread
 1.523e+08 ±  0%      -1.5%    1.5e+08 ±  0%  iozone.stride_read_KBps
   8572154 ±  0%      -2.1%    8393402 ±  0%  iozone.16384KB_16reclen.read
   4258462 ±  5%      +5.1%    4476593 ±  0%  iozone.131072KB_256reclen.write
   8551275 ±  1%      -2.2%    8359432 ±  0%  iozone.16384KB_16reclen.freread
   7314313 ±  0%      +0.5%    7353814 ±  0%  iozone.16384KB_32reclen.record_rewrite
  78739168 ±  8%     -93.2%    5348444 ±  5%  cpuidle.C3-SNB.time
       758 ± 26%     -86.9%         99 ±  5%  sched_debug.cpu#0.load
     16666 ±  4%     -81.2%       3127 ±  0%  cpuidle.C3-SNB.usage
         1 ±  0%    -100.0%          0 ±  0%  vmstat.procs.b
    113046 ±  0%     -72.0%      31652 ±  0%  softirqs.BLOCK
     28577 ±  4%     -85.3%       4202 ±  1%  proc-vmstat.nr_dirty
    114128 ±  4%     -85.1%      16992 ±  2%  meminfo.Dirty
     51312 ±  1%     +98.3%     101737 ±  3%  time.voluntary_context_switches
        39 ± 36%     +38.6%         54 ± 10%  sched_debug.cpu#3.nr_uninterruptible
      0.43 ± 29%     +82.8%       0.78 ± 29%  perf-profile.cpu-cycles.write_ctree_super.btrfs_sync_log.btrfs_sync_file.do_fsync.sys_fsync
    124727 ±  1%     +79.8%     224216 ±  0%  meminfo.Writeback
     31156 ±  1%     +80.0%      56074 ±  0%  proc-vmstat.nr_writeback
         5 ± 22%    +155.9%         14 ±  3%  sched_debug.cfs_rq[3]:/.nr_spread_over
  48927281 ±  9%     +89.1%   92526867 ±  6%  cpuidle.C1-SNB.time
        11 ± 19%     -63.6%          4 ± 25%  sched_debug.cfs_rq[0]:/.nr_spread_over
        18 ± 32%     -53.6%          8 ±  5%  sched_debug.cfs_rq[2]:/.nr_spread_over
        10 ± 22%     +82.8%         19 ± 17%  sched_debug.cpu#1.cpu_load[0]
      1009 ± 36%     +32.2%       1334 ± 24%  slabinfo.btrfs_delayed_data_ref.active_objs
      1023 ± 35%     +31.0%       1341 ± 23%  slabinfo.btrfs_delayed_data_ref.num_objs
      3439 ± 39%     -60.8%       1350 ± 28%  sched_debug.cpu#0.curr->pid
        45 ± 16%     -46.4%         24 ±  6%  sched_debug.cfs_rq[0]:/.runnable_load_avg
         9 ± 35%     +75.9%         17 ± 11%  sched_debug.cpu#1.cpu_load[1]
    412610 ±  0%     -36.8%     260704 ±  2%  cpuidle.C6-SNB.usage
       772 ±  0%     +32.5%       1023 ±  0%  slabinfo.kmalloc-2048.num_objs
       736 ±  0%     +28.1%        944 ±  0%  slabinfo.kmalloc-2048.active_objs
      1.71 ± 13%     -31.7%       1.17 ±  6%  perf-profile.cpu-cycles.ata_sff_tf_load.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd
      0.70 ± 14%     +33.6%       0.94 ± 10%  perf-profile.cpu-cycles.scsi_request_fn.__blk_run_queue.blk_queue_bio.generic_make_request.submit_bio
      1.81 ±  7%     +34.0%       2.42 ± 11%  perf-profile.cpu-cycles.btrfs_sync_log.btrfs_sync_file.do_fsync.sys_fsync.system_call_fastpath
      1.55 ± 12%     -30.5%       1.08 ±  7%  perf-profile.cpu-cycles.__const_udelay.ata_sff_tf_load.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd
      0.86 ±  7%     +40.1%       1.20 ±  4%  perf-profile.cpu-cycles.__set_page_dirty_nobuffers.btrfs_set_page_dirty.set_page_dirty.btrfs_dirty_pages.__btrfs_buffered_write
       511 ±  1%     +48.5%        759 ±  0%  slabinfo.mnt_cache.num_objs
       786 ± 16%     -35.9%        504 ±  3%  sched_debug.cfs_rq[1]:/.tg_load_contrib
       849 ± 12%     +33.3%       1132 ±  4%  sched_debug.cfs_rq[0]:/.blocked_load_avg
       475 ±  1%     +44.2%        685 ±  0%  slabinfo.mnt_cache.active_objs
         9 ± 49%     +66.1%         15 ±  3%  sched_debug.cpu#1.cpu_load[2]
       230 ± 32%     +43.5%        330 ± 17%  sched_debug.cfs_rq[2]:/.load
      6.92 ±  4%     -20.9%       5.47 ±  6%  perf-profile.cpu-cycles.ata_bmdma_qc_issue.ata_qc_issue.ata_scsi_queuecmd.scsi_dispatch_cmd.scsi_request_fn
       232 ± 31%     +42.2%        330 ± 16%  sched_debug.cpu#2.load
      0.84 ±  8%     +26.3%       1.06 ± 11%  perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.try_to_wake_up
      1.22 ± 18%     -34.4%       0.80 ±  7%  perf-profile.cpu-cycles.delay_tsc.__const_udelay.ata_sff_tf_load.ata_bmdma_qc_issue.ata_qc_issue
       765 ± 18%     -37.1%        481 ±  4%  sched_debug.cfs_rq[1]:/.blocked_load_avg
       903 ± 10%     +29.1%       1166 ±  3%  sched_debug.cfs_rq[0]:/.tg_load_contrib
       844 ± 15%     -31.0%        582 ±  5%  slabinfo.btrfs_trans_handle.active_objs
      0.77 ±  6%     +20.7%       0.93 ± 13%  perf-profile.cpu-cycles.enqueue_entity.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate
    117674 ±  3%     -21.3%      92602 ±  0%  sched_debug.cpu#0.ttwu_local
 1.022e+08 ±  0%     -19.7%   81997390 ±  0%  cpuidle.C1E-SNB.time
      1.60 ±  8%     +25.3%       2.00 ±  2%  perf-profile.cpu-cycles.btrfs_dirty_pages.__btrfs_buffered_write.btrfs_file_write_iter.new_sync_write.vfs_write
       853 ± 14%     -29.4%        602 ±  5%  slabinfo.btrfs_trans_handle.num_objs
      3508 ±  0%     +14.2%       4007 ±  0%  uptime.idle
    285629 ±  7%     +10.3%     314942 ±  0%  sched_debug.cpu#2.sched_goidle
      0.96 ±  7%     +31.3%       1.27 ±  0%  perf-profile.cpu-cycles.btrfs_set_page_dirty.set_page_dirty.btrfs_dirty_pages.__btrfs_buffered_write.btrfs_file_write_iter
    583101 ±  7%      +9.8%     640157 ±  0%  sched_debug.cpu#2.sched_count
    580000 ±  7%     +10.0%     637904 ±  0%  sched_debug.cpu#2.nr_switches
      0.93 ± 12%     +17.3%       1.09 ±  7%  perf-profile.cpu-cycles.find_lock_delalloc_range.constprop.44.writepage_delalloc.__extent_writepage.extent_write_cache_pages.extent_writepages
      1.30 ±  2%     +21.5%       1.58 ±  2%  perf-profile.cpu-cycles.set_page_dirty.btrfs_dirty_pages.__btrfs_buffered_write.btrfs_file_write_iter.new_sync_write
    804132 ± 10%     -18.4%     656255 ±  2%  sched_debug.cpu#2.avg_idle
     87472 ±  1%     -18.0%      71705 ±  0%  sched_debug.cpu#0.nr_load_updates
     19076 ±  1%     +20.0%      22898 ±  3%  sched_debug.cfs_rq[1]:/.exec_clock
    134079 ±  2%     -18.3%     109513 ±  1%  sched_debug.cpu#0.sched_goidle
     43539 ±  1%     -13.0%      37872 ±  1%  sched_debug.cfs_rq[0]:/.exec_clock
    281360 ±  2%     -17.6%     231880 ±  1%  sched_debug.cpu#0.nr_switches
    323775 ±  1%     -14.2%     277704 ±  5%  sched_debug.cpu#1.ttwu_local
    284555 ±  2%     -17.8%     233791 ±  1%  sched_debug.cpu#0.sched_count
    286836 ±  6%      +8.8%     312002 ±  4%  sched_debug.cpu#3.ttwu_count
     28292 ±  3%     +24.9%      35336 ±  3%  sched_debug.cfs_rq[1]:/.min_vruntime
    291421 ±  5%     +10.1%     320997 ±  4%  sched_debug.cpu#3.sched_goidle
    258989 ±  6%     +10.6%     286386 ±  5%  sched_debug.cpu#3.ttwu_local
    591002 ±  5%     +10.1%     650795 ±  4%  sched_debug.cpu#3.nr_switches
    594058 ±  5%      +9.9%     652918 ±  4%  sched_debug.cpu#3.sched_count
      3.64 ±  4%      +9.0%       3.97 ±  5%  perf-profile.cpu-cycles.start_secondary
      3.56 ±  4%      +9.4%       3.89 ±  5%  perf-profile.cpu-cycles.cpu_startup_entry.start_secondary
      1678 ±  0%     +18.2%       1984 ±  0%  slabinfo.kmalloc-1024.active_objs
      1706 ±  0%     +17.9%       2012 ±  0%  slabinfo.kmalloc-1024.num_objs
     16895 ±  4%     -14.0%      14534 ±  4%  sched_debug.cfs_rq[3]:/.min_vruntime
      1382 ±  7%      +6.2%       1468 ±  5%  slabinfo.proc_inode_cache.active_objs
      8.76 ±  1%     +13.2%       9.91 ±  0%  perf-profile.cpu-cycles.new_sync_read.vfs_read.sys_read.system_call_fastpath.__read_nocancel
      8.77 ±  2%     +13.1%       9.91 ±  0%  perf-profile.cpu-cycles.vfs_read.sys_read.system_call_fastpath.__read_nocancel
     16.92 ±  0%     -13.9%      14.57 ±  1%  perf-profile.cpu-cycles.do_IRQ.ret_from_intr.cpuidle_enter.cpu_startup_entry.rest_init
     16.93 ±  0%     -13.6%      14.62 ±  1%  perf-profile.cpu-cycles.ret_from_intr.cpuidle_enter.cpu_startup_entry.rest_init.start_kernel
      8.80 ±  2%     +12.8%       9.93 ±  0%  perf-profile.cpu-cycles.__read_nocancel
      8.78 ±  2%     +13.0%       9.91 ±  0%  perf-profile.cpu-cycles.sys_read.system_call_fastpath.__read_nocancel
      8.79 ±  1%     +12.8%       9.91 ±  0%  perf-profile.cpu-cycles.system_call_fastpath.__read_nocancel
         8 ±  0%     +12.5%          9 ±  0%  time.percent_of_cpu_this_job_got
      1714 ±  0%     +12.0%       1920 ±  0%  slabinfo.kmalloc-96.num_objs
    255258 ±  8%     +11.5%     284664 ±  0%  sched_debug.cpu#2.ttwu_local
      1639 ±  1%     +12.2%       1839 ±  0%  slabinfo.kmalloc-96.active_objs
     15.35 ±  0%     -13.7%      13.25 ±  3%  perf-profile.cpu-cycles.irq_exit.do_IRQ.ret_from_intr.cpuidle_enter.cpu_startup_entry
     15.21 ±  0%     -13.2%      13.20 ±  3%  perf-profile.cpu-cycles.__do_softirq.irq_exit.do_IRQ.ret_from_intr.cpuidle_enter
      2.05 ±  6%      +5.8%       2.17 ±  3%  perf-profile.cpu-cycles.btrfs_csum_data.btrfs_csum_one_bio.btrfs_submit_bio_hook.submit_one_bio.flush_epd_write_bio
      8.53 ±  0%   +1627.3%     147.42 ±  0%  iostat.sda.wrqm/s
       868 ±  0%    +719.9%       7122 ±  1%  iostat.sda.avgrq-sz
    170.07 ±  0%     -71.5%      48.53 ±  0%  iostat.sda.w/s
       837 ±  0%    +121.6%       1855 ±  0%  iostat.sda.w_await
       837 ±  0%    +121.6%       1855 ±  0%  iostat.sda.await
    143.46 ±  0%     -71.5%      40.85 ±  0%  iostat.sda.avgqu-sz
      1936 ±  0%     +11.0%       2149 ±  0%  vmstat.system.cs
     74904 ±  0%      +9.7%      82169 ±  0%  vmstat.io.bo
     74884 ±  0%      +9.7%      82165 ±  0%  iostat.sda.wkB/s

lkp-ws02: Westmere-EP
Memory: 16G

snb-drag: Sandy Bridge
Memory: 6G

bay: Pentium D
Memory: 2G

ivb44: Ivytown Ivy Bridge-EP
Memory: 64G




                                iostat.sdi.wrqm/s

  90 ++---------------------------------------------------------------------+
     |                                            O O O O   O         O O O |
  80 O+    O O O   O               O   O                      O O O         O
  70 ++O O             O O O O O O   O   OO O O O                           |
     |                                                                      |
  60 ++                                                                     |
  50 ++                                                                     |
     |                                                                      |
  40 ++                                                                     |
  30 ++                                                                     |
     *.   .*.               .*.                                             |
  20 ++*.*   *.*   *.*.*.*.*   *.*.*                                        |
  10 ++         : :                                                         |
     |          : :                                                         |
   0 ++----------O---O------------------------------------O---------O-------+


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



--=-5Gs+Ki84rWt/KNOyWXFn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: dd-write
default_monitors:
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
commit: 406d4044a3ed9c1455e74914d9bbc49de35a51d7
model: Core2
memory: 8G
nr_hdd_partitions: 12
hdd_partitions: "/dev/disk/by-id/scsi-35000c5000*-part1"
swap_partitions: 
runtime: 5m
disk: 11HDD
md:
- JBOD
iosched:
- cfq
fs:
- ext4
fs2:
- 
monitors:
  perf-stat: 
  perf-profile: 
  ftrace:
  - events: balance_dirty_pages bdi_dirty_ratelimit global_dirty_state writeback_single_inode
nr_threads:
- 10dd
dd: 
testbox: lkp-st02
tbox_group: lkp-st02
kconfig: x86_64-rhel
enqueue_time: 2014-12-16 02:28:06.248468280 +08:00
head_commit: 406d4044a3ed9c1455e74914d9bbc49de35a51d7
base_commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
branch: linux-devel/devel-hourly-2014121907
kernel: "/kernel/x86_64-rhel/406d4044a3ed9c1455e74914d9bbc49de35a51d7/vmlinuz-3.18.0-g406d404"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-st02/dd-write/5m-11HDD-JBOD-cfq-ext4-10dd/debian-x86_64.cgz/x86_64-rhel/406d4044a3ed9c1455e74914d9bbc49de35a51d7/0"
job_file: "/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-JBOD-cfq-ext4-10dd-x86_64-rhel-HEAD-406d4044a3ed9c1455e74914d9bbc49de35a51d7-0.yaml"
dequeue_time: 2014-12-19 11:21:33.802276274 +08:00
job_state: finished
loadavg: 79.12 69.10 31.81 1/154 6761
start_time: '1418959356'
end_time: '1418959681'
version: "/lkp/lkp/.src-20141219-090914"
time_delta: '1418959305.662960627'

--=-5Gs+Ki84rWt/KNOyWXFn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

echo 1 > /sys/kernel/debug/tracing/events/writeback/balance_dirty_pages/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/bdi_dirty_ratelimit/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/global_dirty_state/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode/enable
mkfs -t ext4 -q -F /dev/sdb1
mkfs -t ext4 -q -F /dev/sdg1
mkfs -t ext4 -q -F /dev/sdk1
mkfs -t ext4 -q -F /dev/sdh1
mkfs -t ext4 -q -F /dev/sdi1
mkfs -t ext4 -q -F /dev/sdj1
mkfs -t ext4 -q -F /dev/sde1
mkfs -t ext4 -q -F /dev/sdc1
mkfs -t ext4 -q -F /dev/sdm1
mkfs -t ext4 -q -F /dev/sdf1
mkfs -t ext4 -q -F /dev/sdl1
mount -t ext4 /dev/sdb1 /fs/sdb1
mount -t ext4 /dev/sdj1 /fs/sdj1
mount -t ext4 /dev/sdi1 /fs/sdi1
mount -t ext4 /dev/sdk1 /fs/sdk1
mount -t ext4 /dev/sdm1 /fs/sdm1
mount -t ext4 /dev/sdg1 /fs/sdg1
mount -t ext4 /dev/sdl1 /fs/sdl1
mount -t ext4 /dev/sdh1 /fs/sdh1
mount -t ext4 /dev/sde1 /fs/sde1
mount -t ext4 /dev/sdf1 /fs/sdf1
mount -t ext4 /dev/sdc1 /fs/sdc1
dd  if=/dev/zero of=/fs/sdb1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdm1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-10 status=noxfer &
sleep 289
killall -9 dd

--=-5Gs+Ki84rWt/KNOyWXFn
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-5Gs+Ki84rWt/KNOyWXFn--

