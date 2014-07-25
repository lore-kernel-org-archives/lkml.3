Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbaGYGUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:20:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:13613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242AbaGYGUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:20:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="548830365"
Message-ID: <53D1F738.6090709@intel.com>
Date: Fri, 25 Jul 2014 14:20:40 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: Josef Bacik <jbacik@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [LKP] [Btrfs] d5f375270aa: -20.0% fsmark.app_overhead
References: <53d1f54c.blMxjnD1lFq2jITL%fengguang.wu@intel.com>
In-Reply-To: <53d1f54c.blMxjnD1lFq2jITL%fengguang.wu@intel.com>
X-Forwarded-Message-Id: <53d1f54c.blMxjnD1lFq2jITL%fengguang.wu@intel.com>
Content-Type: multipart/mixed;
 boundary="------------040802030202090107020209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040802030202090107020209
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

FYI, we noticed the below changes on

commit d5f375270aa55794f4a7196b5247469f86278a8f ("Btrfs: faster/more efficient insertion of file extent items")

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    914752 ~ 1%      -1.4%     902289 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
   2811730 ~ 0%     -26.0%    2080244 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
   3726483 ~ 0%     -20.0%    2982534 ~ 0%  TOTAL fsmark.app_overhead

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
       611 ~ 0%      +5.6%        645 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
      1072 ~ 0%      -9.7%        968 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
      1684 ~ 0%      -4.2%       1613 ~ 0%  TOTAL fsmark.files_per_sec

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
   7577550 ~14%     -59.6%    3058053 ~ 7%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
   7577550 ~14%     -59.6%    3058053 ~ 7%  TOTAL cpuidle.C1E-NHM.time

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    105466 ~ 2%     +26.4%     133267 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
    516731 ~ 2%     +45.1%     749581 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    622197 ~ 2%     +41.9%     882848 ~ 0%  TOTAL cpuidle.C1-NHM.usage

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    612557 ~ 8%     +36.5%     836424 ~ 2%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    612557 ~ 8%     +36.5%     836424 ~ 2%  TOTAL proc-vmstat.pgpgout

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
       409 ~ 8%     +28.9%        528 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
       409 ~ 8%     +28.9%        528 ~ 1%  TOTAL cpuidle.POLL.usage

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    203846 ~ 5%     +23.1%     250960 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    203846 ~ 5%     +23.1%     250960 ~ 1%  TOTAL meminfo.Active(file)

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     50935 ~ 5%     +23.1%      62696 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     50935 ~ 5%     +23.1%      62696 ~ 1%  TOTAL proc-vmstat.nr_active_file

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
  27799300 ~ 1%     +21.8%   33847790 ~ 5%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
  27799300 ~ 1%     +21.8%   33847790 ~ 5%  TOTAL cpuidle.C1-NHM.time

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    239715 ~ 4%     +19.7%     287020 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    239715 ~ 4%     +19.7%     287020 ~ 1%  TOTAL meminfo.Active

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     12.50 ~ 2%     +17.0%      14.62 ~ 3%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
     12.50 ~ 2%     +17.0%      14.62 ~ 3%  TOTAL turbostat.%c1

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
  35865226 ~ 4%      -8.9%   32690229 ~ 3%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
  53265661 ~ 5%     +22.6%   65295599 ~ 4%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
  89130888 ~ 5%      +9.9%   97985828 ~ 4%  TOTAL cpuidle.C3-NHM.time

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    177363 ~ 3%     +15.7%     205258 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    177363 ~ 3%     +15.7%     205258 ~ 1%  TOTAL proc-vmstat.nr_written

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
 2.799e+08 ~ 2%     +14.4%  3.202e+08 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
 2.799e+08 ~ 2%     +14.4%  3.202e+08 ~ 1%  TOTAL cpuidle.C6-NHM.time

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      8995 ~ 4%      +9.2%       9824 ~ 3%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
      8995 ~ 4%      +9.2%       9824 ~ 3%  TOTAL cpuidle.C1E-NHM.usage

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    145906 ~ 1%     +12.6%     164283 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    145906 ~ 1%     +12.6%     164283 ~ 1%  TOTAL cpuidle.C6-NHM.usage

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    181623 ~ 3%     +13.3%     205797 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    181623 ~ 3%     +13.3%     205797 ~ 1%  TOTAL proc-vmstat.nr_dirtied

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     12831 ~ 0%     +11.4%      14297 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     12831 ~ 0%     +11.4%      14297 ~ 0%  TOTAL slabinfo.btrfs_extent_buffer.num_objs

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     12830 ~ 0%     +11.4%      14294 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     12830 ~ 0%     +11.4%      14294 ~ 0%  TOTAL slabinfo.btrfs_extent_buffer.active_objs

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     16.24 ~ 2%     +12.0%      18.18 ~ 2%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     16.24 ~ 2%     +12.0%      18.18 ~ 2%  TOTAL turbostat.%c6

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      1575 ~ 2%      +9.9%       1732 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
      1575 ~ 2%      +9.9%       1732 ~ 1%  TOTAL proc-vmstat.nr_dirty

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    261613 ~ 0%      +8.9%     284781 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
   1793113 ~ 1%     +39.0%    2493055 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
   2054726 ~ 1%     +35.2%    2777837 ~ 0%  TOTAL time.voluntary_context_switches

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     11.25 ~ 2%     +18.1%      13.28 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     11.25 ~ 2%     +18.1%      13.28 ~ 1%  TOTAL iostat.sdb.avgqu-sz

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
    183744 ~ 1%     -15.6%     155153 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    183744 ~ 1%     -15.6%     155153 ~ 0%  TOTAL time.involuntary_context_switches

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
       529 ~ 0%     -15.6%        446 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
       529 ~ 0%     -15.6%        446 ~ 0%  TOTAL iostat.sdb.w/s

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      8009 ~ 1%     +15.2%       9225 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
     29796 ~ 2%     +20.7%      35971 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     37805 ~ 2%     +19.6%      45196 ~ 0%  TOTAL vmstat.system.cs

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      9275 ~ 1%      +6.3%       9861 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
      6245 ~ 7%     +23.5%       7716 ~ 2%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     15521 ~ 3%     +13.3%      17577 ~ 1%  TOTAL vmstat.io.bo

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      9277 ~ 1%      +5.8%       9815 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
      6248 ~ 7%     +23.5%       7718 ~ 2%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
     15525 ~ 3%     +12.9%      17534 ~ 1%  TOTAL iostat.sdb.wkB/s

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      1.12 ~ 1%      -9.5%       1.01 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
      1.12 ~ 1%      -9.5%       1.01 ~ 1%  TOTAL iostat.sdb.rrqm/s

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
   1448553 ~ 3%     +13.2%    1639185 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
   1448553 ~ 3%     +13.2%    1639185 ~ 1%  TOTAL time.file_system_outputs

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     99.39 ~ 1%      +3.4%     102.76 ~ 2%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
    126.06 ~ 5%     +21.4%     153.02 ~ 2%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    225.45 ~ 3%     +13.5%     255.78 ~ 2%  TOTAL iostat.sdb.wrqm/s

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
     85.36 ~ 1%      -6.0%      80.24 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
     95.60 ~ 0%     +10.9%     106.03 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
    180.96 ~ 1%      +2.9%     186.27 ~ 0%  TOTAL time.elapsed_time

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      1774 ~ 0%      +8.7%       1928 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
      4833 ~ 1%      +4.2%       5038 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
      6607 ~ 1%      +5.4%       6967 ~ 0%  TOTAL vmstat.system.in

51b98effa4c673f  d5f375270aa55794f4a7196b5  
---------------  -------------------------  
      1.98 ~ 0%      +4.8%       2.08 ~ 1%  nhm4/fsmark/1x-32t-1HDD-btrfs-8K-400M-fsyncBeforeClose-16d-256f
      4.07 ~ 1%      +4.8%       4.27 ~ 0%  nhm4/fsmark/1x-32t-1HDD-btrfs-9B-400M-fsyncBeforeClose-16d-256f
      6.06 ~ 1%      +4.8%       6.35 ~ 0%  TOTAL turbostat.%c0


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                               fsmark.files_per_sec

  700 ++--------------------------------------------------------------------+
      O O  O O O O  O O O O  O O O O  O O O O  O O O O  O O                 |
  600 *+*..*.*.*.*..*.*.*.*..*.*.*    *.*.*.*..*.*.*.*..*.*.*.*..*.*.*.*..*.*
      |                          :    :                                     |
  500 ++                         :    :                                     |
      |                           :  :                                      |
  400 ++                          :  :                                      |
      |                           :  :                                      |
  300 ++                          :  :                                      |
      |                           : :                                       |
  200 ++                          : :                                       |
      |                            ::                                       |
  100 ++                           ::                                       |
      |                            :                                        |
    0 ++---------------------------*----------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Aaron

--------------040802030202090107020209
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
ZnJlcS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2RldmljZXMv
c3lzdGVtL2NwdS9jcHU0L2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgplY2hvIHBlcmZvcm1h
bmNlID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1NS9jcHVmcmVxL3NjYWxpbmdfZ292
ZXJub3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTYv
Y3B1ZnJlcS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2Rldmlj
ZXMvc3lzdGVtL2NwdS9jcHU3L2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgpta2ZzIC10IGJ0
cmZzIC9kZXYvc2RiMQptb3VudCAtdCBidHJmcyAvZGV2L3NkYjEgL2ZzL3NkYjEKLi9mc19t
YXJrIC1kIC9mcy9zZGIxLzEgLWQgL2ZzL3NkYjEvMiAtZCAvZnMvc2RiMS8zIC1kIC9mcy9z
ZGIxLzQgLWQgL2ZzL3NkYjEvNSAtZCAvZnMvc2RiMS82IC1kIC9mcy9zZGIxLzcgLWQgL2Zz
L3NkYjEvOCAtZCAvZnMvc2RiMS85IC1kIC9mcy9zZGIxLzEwIC1kIC9mcy9zZGIxLzExIC1k
IC9mcy9zZGIxLzEyIC1kIC9mcy9zZGIxLzEzIC1kIC9mcy9zZGIxLzE0IC1kIC9mcy9zZGIx
LzE1IC1kIC9mcy9zZGIxLzE2IC1kIC9mcy9zZGIxLzE3IC1kIC9mcy9zZGIxLzE4IC1kIC9m
cy9zZGIxLzE5IC1kIC9mcy9zZGIxLzIwIC1kIC9mcy9zZGIxLzIxIC1kIC9mcy9zZGIxLzIy
IC1kIC9mcy9zZGIxLzIzIC1kIC9mcy9zZGIxLzI0IC1kIC9mcy9zZGIxLzI1IC1kIC9mcy9z
ZGIxLzI2IC1kIC9mcy9zZGIxLzI3IC1kIC9mcy9zZGIxLzI4IC1kIC9mcy9zZGIxLzI5IC1k
IC9mcy9zZGIxLzMwIC1kIC9mcy9zZGIxLzMxIC1kIC9mcy9zZGIxLzMyIC1EIDE2IC1OIDI1
NiAtbiAxNjAwIC1MIDEgLVMgMSAtcyA4MTkyCgo=
--------------040802030202090107020209--
