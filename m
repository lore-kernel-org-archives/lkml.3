Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab3EXDdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:33:50 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47657 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596Ab3EXDdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:33:46 -0400
Date: Thu, 23 May 2013 23:33:39 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: linux-s390 <linux-s390@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        xfs@oss.sgi.com, Steve Best <sbest@redhat.com>,
        Hendrik Brueckner <bhendrik@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Message-ID: <806463874.5711876.1369366419059.JavaMail.root@redhat.com>
In-Reply-To: <1125086079.5019070.1369285040855.JavaMail.root@redhat.com>
References: <40971621.4497871.1369211701112.JavaMail.root@redhat.com> <1805266998.4499261.1369211998387.JavaMail.root@redhat.com> <20130522095300.GK29466@dastard> <1483868349.4996990.1369279016162.JavaMail.root@redhat.com> <20130523034611.GX24543@dastard> <1125086079.5019070.1369285040855.JavaMail.root@redhat.com>
Subject: Re: 3.9.2/3.9.3: stack overrun on s390x and ppc64 (WAS Re: 3.9.2:
 xfstests triggered panic)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.2/3.9.3: stack overrun on s390x and ppc64 (WAS Re: 3.9.2: xfstests triggered panic)
Thread-Index: UrqmsS7Y5wTYDzl3iTO6fgrXyEgS3liyEEZW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here is clearer stack output from the run.
CAI Qian

+ ./check
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/s390x ibm-z10-23 3.9.3

001	 29s
002	 3s
003	 2s
004	 [not run] this test requires a valid $SCRATCH_DEV
005	 2s
006	 9s
007	 10s
008	 7s
009	 [not run] this test requires a valid $SCRATCH_DEV
010	 [not run] dbtest was not built for this platform
011	 9s
012	 10s
013	 35s
014	 5s
015	 [not run] this test requires a valid $SCRATCH_DEV
016	 [not run] this test requires a valid $SCRATCH_DEV
017	 [not run] this test requires a valid $SCRATCH_DEV
018	 [not run] this test requires a valid $SCRATCH_DEV
019	 [not run] this test requires a valid $SCRATCH_DEV
020	


[ 1316.571227] XFS (dm-0): Mounting Filesystem
[ 1316.697803] XFS (dm-0): Ending clean mount
[ 1318.080615] XFS (dm-0): Ending clean mount
[ 1348.791125] XFS (dm-0): Mounting Filesystem
[ 1348.989166] XFS (dm-0): Ending clean mount
[ 1353.335478] XFS (dm-0): Mounting Filesystem
[ 1353.496364] XFS (dm-0): Ending clean mount
[ 1357.495427] XFS (dm-0): Mounting Filesystem
[ 1357.676971] XFS (dm-0): Ending clean mount
[ 1361.646399] XFS (dm-0): Mounting Filesystem
[ 1361.890426] XFS (dm-0): Ending clean mount
[ 1371.798944] XFS (dm-0): Mounting Filesystem
[ 1371.976922] XFS (dm-0): Ending clean mount
[ 1384.559103] XFS (dm-0): Mounting Filesystem
[ 1384.725657] XFS (dm-0): Ending clean mount
[ 1393.131347] XFS (dm-0): Mounting Filesystem
[ 1393.357927] XFS (dm-0): Ending clean mount
[ 1407.282708] XFS (dm-0): Mounting Filesystem
[ 1407.745176] XFS (dm-0): Ending clean mount
[ 1422.927074] XFS (dm-0): Mounting Filesystem
[ 1423.136266] XFS (dm-0): Ending clean mount
[ 1425.500910] XFS (dm-0): Mounting Filesystem
[ 1425.608851] XFS (dm-0): Ending clean mount
[ 1450.978110] XFS (dm-0): Mounting Filesystem
[ 1451.255368] XFS (dm-0): Ending clean mount
[ 1453.603742] XFS (dm-0): Mounting Filesystem
[ 1453.680657] XFS (dm-0): Ending clean mount
[ 1456.262266] XFS (dm-0): Mounting Filesystem
[ 1456.330515] XFS (dm-0): Ending clean mount
[ 1457.053767] XFS (dm-0): Mounting Filesystem
[ 1457.107258] XFS (dm-0): Ending clean mount
[ 1462.049374] XFS (dm-0): Mounting Filesystem
[ 1462.111389] XFS (dm-0): Ending clean mount
[ 1471.109589] ODEBUG: deactivate not available (active state 0) object type: ti
mer_list hint: process_timeout+0x0/0x8
[ 1471.109683] ------------[ cut here ]------------
[ 1471.109688] WARNING: at lib/debugobjects.c:260
[ 1471.109692] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F
) vmur(F) xfs(F) libcrc32c(F) dasd_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F
) ctcm(F) qeth(F) qdio(F) ccwgroup(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_l
og(F) dm_mod(F)
[ 1471.109848] CPU: 0 Tainted: GF            3.9.3 #2
[ 1471.109858] Process swapper/0 (pid: 0, task: 0000000000a2b4d0, ksp: 000000000
0a17d28)
[ 1471.109868] Krnl PSW : 0404c00180000000 000000000046c84a (debug_print_object+
0xca/0xd8)
[ 1471.114762]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:
3
Krnl GPRS: 0000000000000000 0000000000a2b4d0 0000000000000067 000000000101f708
[ 1471.114769]            000000000046c846 0000000084a4d448 000000000086936a 000
0000001040700
[ 1471.114773]            0000000001a0f290 0400000000000001 0000000000874cf8 000
0000000a395d8
[ 1471.114777]            000000000195f820 000000000001bd20 000000000046c846 000
000000001bc20
[ 1471.114792] Krnl Code: 000000000046c83a: e34410000004        lg      %r4,0(%r
4,%r1)
           000000000046c840: c0e500139f88       brasl   %r14,6e0750
          #000000000046c846: a7f40001           brc     15,46c848
          >000000000046c84a: a7f4ffc2           brc     15,46c7ce
           000000000046c84e: a7290000           lghi    %r2,0
           000000000046c852: a7f4ffd7           brc     15,46c800
           000000000046c856: 0707               bcr     0,%r7
           000000000046c858: ebaff0680024       stmg    %r10,%r15,104(%r15)
[ 1471.114825] Call Trace:
[ 1471.114828] ([<000000000046c846>] debug_print_object+0xc6/0xd8)
[ 1471.114833]  [<000000000046d35c>] debug_object_deactivate+0x15c/0x160
[ 1471.114838]  [<0000000000148244>] run_timer_softirq+0x180/0x464
[ 1471.114843]  [<000000000013d8d6>] __do_softirq+0x112/0x42c
[ 1471.114847]  [<000000000013ddf8>] irq_exit+0xc8/0xe8
[ 1471.114851]  [<000000000010d55e>] do_extint+0x25e/0x318
[ 1471.114859]  [<00000000006f0d90>] ext_skip+0x40/0x44
[ 1471.114866]  [<00000000006f05d6>] vtime_stop_cpu+0x52/0xbc
[ 1471.114870] ([<00000000006f05b4>] vtime_stop_cpu+0x30/0xbc)
[ 1471.114874]  [<000000000010476e>] cpu_idle+0x112/0x1b8
[ 1471.114879]  [<0000000000aaf99a>] start_kernel+0x42e/0x43c
[ 1471.114885]  [<0000000000100020>] _stext+0x20/0x80
[ 1471.114891] 2 locks held by swapper/0/0:
[ 1471.114894]  #0:  (&(&base->lock)->rlock){-.-.-.}, at: [<0000000000148128>] r
un_timer_softirq+0x64/0x464
[ 1471.114908]  #1:  (&obj_hash[i].lock){-.-.-.}, at: [<000000000046d2ba>] debug
_object_deactivate+0xba/0x160
[ 1471.114918] Last Breaking-Event-Address:
[ 1471.114921]  [<000000000046c846>] debug_print_object+0xc6/0xd8
[ 1471.114927] ---[ end trace dd87895f75677361 ]---
[ 1471.117683] ODEBUG: object is on stack, but not annotated
[ 1471.117723] ------------[ cut here ]------------
[ 1471.117726] WARNING: at lib/debugobjects.c:300
[ 1471.117729] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F
) vmur(F) xfs(F) libcrc32c(F) dasd_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F
) ctcm(F) qeth(F) qdio(F) ccwgroup(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_l
og(F) dm_mod(F)
[ 1471.117791] CPU: 0 Tainted: GF       W    3.9.3 #2
[ 1471.117794] Process rcu_sched (pid: 10, task: 00000000fffe8000, ksp: 00000000
fffe7ae0)
[ 1471.117797] Krnl PSW : 0404c00180000000 000000000046ccce (__debug_object_init
+0x35a/0x480)
[ 1471.117804]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:
3
Krnl GPRS: 0000000000000000 00000000fffe8000 000000000000002d 000000000101f708
[ 1471.117811]            000000000046ccca 0000000000000001 0000000000a395d8 070
0000000000000
[ 1471.117814]            0000000000a78750 0000000001a0f298 00000000fffe7cf0 000
00000f8daa938
[ 1471.117818]            0000000001a0f290 00000000007434c0 000000000046ccca 00
00000fffe7a40
[ 1471.117852] Krnl Code: 000000000046ccbe: c02000217617        larl    %r2,89b8
ec
           000000000046ccc4: c0e500139d46       brasl   %r14,6e0750
          #000000000046ccca: a7f40001           brc     15,46cccc
          >000000000046ccce: a7f4ff03           brc     15,46cad4
           000000000046ccd2: a7380000           lhi     %r3,0
           000000000046ccd6: a7f4ffe9           brc     15,46cca8
           000000000046ccda: c02000217622       larl    %r2,89b91e
           000000000046cce0: c0e500139d38       brasl   %r14,6e0750
[ 1471.117884] Call Trace:
[ 1471.117887] ([<000000000046ccca>] __debug_object_init+0x356/0x480)
[ 1471.117891]  [<0000000000146f42>] init_timer_key+0x3a/0x164
[ 1471.117897]  [<0000000000147eac>] timer_fixup_assert_init+0x50/0xa8
[ 1471.117901]  [<000000000046d7a4>] debug_object_assert_init+0x124/0x154
[ 1471.117906]  [<0000000000148676>] try_to_del_timer_sync+0x2e/0x94
[ 1471.117910]  [<000000000014878e>] del_timer_sync+0xb2/0x104
[ 1471.117915]  [<00000000006ea950>] schedule_timeout+0x190/0x37c
[ 1471.117922]  [<00000000001f1118>] rcu_gp_kthread+0x320/0x59c
[ 1471.117927]  [<0000000000164176>] kthread+0xe6/0xec
[ 1471.117934]  [<00000000006f0906>] kernel_thread_starter+0x6/0xc
[ 1471.117938]  [<00000000006f0900>] kernel_thread_starter+0x0/0xc
[ 1471.117943] 1 lock held by rcu_sched/10:
[ 1471.117945]  #0:  (&obj_hash[i].lock){-.-.-.}, at: [<000000000046caba>] __deb
ug_object_init+0x146/0x480
[ 1471.117955] Last Breaking-Event-Address:
[ 1471.117958]  [<000000000046ccca>] __debug_object_init+0x356/0x480
[ 1471.117962] ---[ end trace dd87895f75677362 ]---
[ 1471.117967] ODEBUG: assert_init not available (active state 0) object type: t
imer_list hint: stub_timer+0x0/0x8
[ 1471.117984] ------------[ cut here ]------------
[ 1471.117987] WARNING: at lib/debugobjects.c:260
[ 1471.117990] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F
) vmur(F) xfs(F) libcrc32c(F) dasd_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F
) ctcm(F) qeth(F) qdio(F) ccwgroup(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_l
og(F) dm_mod(F)
[ 1471.118053] CPU: 0 Tainted: GF       W    3.9.3 #2
[ 1471.118075] Process rcu_sched (pid: 10, task: 00000000fffe8000, ksp: 00000000
fffe7ae0)
[ 1471.118079] Krnl PSW : 0704e00180000000 000000000046c84a (debug_print_object+
0xca/0xd8)
[ 1471.118085]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:
3
Krnl GPRS: 0000000000000000 00000000fffe8000 0000000000000063 0000000000000001
[ 1471.118092]            000000000046c846 0000000000000001 000000000086936a 000
0000000a1d300
[ 1471.118095]            0000000001a0f290 07000000006ed3fc 000000000089ba14 000
0000000a395d8
[ 1471.118099]            000000000195f820 00000000fffe7bc8 000000000046c846 000
00000fffe7ac8
[ 1471.118109] Krnl Code: 000000000046c83a: e34410000004        lg      %r4,0(%r
4,%r1)
           000000000046c840: c0e500139f88       brasl   %r14,6e0750
          #000000000046c846: a7f40001           brc     15,46c848
          >000000000046c84a: a7f4ffc2           brc     15,46c7ce
           000000000046c84e: a7290000           lghi    %r2,0
           000000000046c852: a7f4ffd7           brc     15,46c800
           000000000046c856: 0707               bcr     0,%r7
           000000000046c858: ebaff0680024       stmg    %r10,%r15,104(%r15)
[ 1471.118141] Call Trace:
[ 1471.118144] ([<000000000046c846>] debug_print_object+0xc6/0xd8)
[ 1471.118149]  [<000000000046d7ce>] debug_object_assert_init+0x14e/0x154
[ 1471.118153]  [<0000000000148676>] try_to_del_timer_sync+0x2e/0x94
[ 1471.118158]  [<000000000014878e>] del_timer_sync+0xb2/0x104
[ 1471.118163]  [<00000000006ea950>] schedule_timeout+0x190/0x37c
[ 1471.118167]  [<00000000001f1118>] rcu_gp_kthread+0x320/0x59c
[ 1471.118172]  [<0000000000164176>] kthread+0xe6/0xec
[ 1471.118176]  [<00000000006f0906>] kernel_thread_starter+0x6/0xc
[ 1471.118180]  [<00000000006f0900>] kernel_thread_starter+0x0/0xc
[ 1471.118185] no locks held by rcu_sched/10.
[ 1471.118188] Last Breaking-Event-Address:
[ 1471.118190]  [<000000000046c846>] debug_print_object+0xc6/0xd8
[ 1471.118195] ---[ end trace dd87895f75677363 ]---
[ 1471.121980] Unable to handle kernel pointer dereference at virtual kernel add
ress 000003ff8072c000
[ 1471.123714] Oops: 0011 [#1] SMP
[ 1471.123720] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F
) vmur(F) xfs(F) libcrc32c(F) dasd_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F
) ctcm(F) qeth(F) qdio(F) ccwgroup(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_l
og(F) dm_mod(F)
[ 1471.123777] CPU: 0 Tainted: GF       W    3.9.3 #2
[ 1471.123781] Process systemd-journal (pid: 516, task: 00000000f5ad8000, ksp: 0
0000000f544fbd0)
[ 1471.123784] Krnl PSW : 0704e00180000000 000003ff80749cc2 (xfs_vm_page_mkwrite
+0x12/0x1c [xfs])
[ 1471.154773]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:
3
Krnl GPRS: 00000000000015e8 000003ff8072cc30 0000000000000001 0000000000000000
[ 1471.154781]            00000000006ef176 00000000007036b8 00000000f97b7d98 000
003fffb3e7000
[ 1471.154784]            000003fffb3e7000 00000000f8f65a00 00000000f8472738 000
00000f8ffc2c0
[ 1471.154788]            00000000f8472738 000000000070d5e0 000003ff80749cb6 000
00000f544fc28
[ 1471.154802] Krnl Code: 000003ff80749cb6: 1222                ltr     %r2,%r2
           000003ff80749cb8: a784ffd8           brc     8,3ff80749c68
          #000003ff80749cbc: c010ffff17ba       larl    %r1,3ff8072cc30
          >000003ff80749cc2: e31010000004       lg      %r1,0(%r1)
           000003ff80749cc8: e32010000012       lt      %r2,0(%r1)
           000003ff80749cce: a7740032           brc     7,3ff80749d32
           000003ff80749cd2: e31003180004       lg      %r1,792
           000003ff80749cd8: e330101c0012       lt      %r3,28(%r1)
[ 1471.154838] Call Trace:
[ 1471.154841] ([<0000000000261870>] do_wp_page+0x6f8/0xa4c)
[ 1471.154851]  [<0000000000262f2c>] handle_pte_fault+0x65c/0xa10
[ 1471.154856]  [<0000000000264a22>] handle_mm_fault+0x182/0x260
[ 1471.154860]  [<00000000006f21d0>] do_protection_exception+0x1b8/0x3cc
[ 1471.154867]  [<00000000006f0a44>] pgm_check_handler+0x138/0x13c
[ 1471.154871]  [<000000008001d60a>] 0x8001d60a
[ 1471.154894] INFO: lockdep is turned off.
[ 1471.154897] Last Breaking-Event-Address:
[ 1471.154899]  [<00000000001ed7ca>] rcu_lockdep_current_cpu_online+0x6e/0x84
[ 1471.154909]
[ 1471.154913] ---[ end trace dd87895f75677364 ]---
[ 1471.157438] ------------[ cut here ]------------
[ 1471.157446] Kernel BUG at 00000000006eb186 [verbose debug info unavailable]
[ 1471.157508] addressing exception: 0005 [#2] SMP
[ 1471.157514] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F
) vmur(F) xfs(F) libcrc32c(F) dasd_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F
) ctcm(F) qeth(F) qdio(F) ccwgroup(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_l
og(F) dm_mod(F)
[ 1471.157574] CPU: 0 Tainted: GF     D W    3.9.3 #2
[ 1471.157577] Process systemd-journal (pid: 516, task: 00000000f5ad8000, ksp: 0
0000000f544f578)
[ 1471.157580] Krnl PSW : 0404d00180000000 00000000006eb186 (mutex_lock_nested+0
xde/0x36c)
[ 1471.157591]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 EA:
3
Krnl GPRS: 000000000000166e 0000000000000000 00000000ffffffff 0000000000a78630
[ 1471.157597]            0000000000000000 0000000000000000 0000000000000002 000
00000100073f8
[ 1471.157601]            00000000f5ad8000 000000000101f708 0000000000000000 070
0000000000000
[ 1471.157604]            0000000010007388 0000000010007380 00000000006eb170 000
00000f544f658
[ 1471.157616] Krnl Code: 00000000006eb178: a7180000            lhi     %r1,0
           00000000006eb17c: c027ffffffff       xilf    %r2,4294967295
          #00000000006eb182: ba12d008           cs      %r1,%r2,8(%r13)
          >00000000006eb186: 1211               ltr     %r1,%r1
           00000000006eb188: a774011b           brc     7,6eb3be
           00000000006eb18c: e31090000012       lt      %r1,0(%r9)
           00000000006eb192: a7740007           brc     7,6eb1a0
           00000000006eb196: e3d0d0700020       cg      %r13,112(%r13)
[ 1471.157650] Call Trace:
[ 1471.157652] ([<00000000006eb170>] mutex_lock_nested+0xc8/0x36c)
[ 1471.157657]  [<0000000000260e3e>] unmap_single_vma+0x786/0x7d0
[ 1471.157663]  [<000000000026219c>] unmap_vmas+0x50/0x74
[ 1471.157666]  [<000000000026b7aa>] exit_mmap+0x186/0x224
[ 1471.157671]  [<000000000012ef88>] mmput+0x84/0x110
[ 1471.157677]  [<0000000000139fd2>] do_exit+0x2c6/0xce8
[ 1471.157682]  [<0000000000100ef2>] die+0x13e/0x158
[ 1471.157687]  [<000000000011dd6e>] do_no_context+0xba/0xf0
[ 1471.157692]  [<00000000006f2714>] do_dat_exception+0x330/0x390
[ 1471.157697]  [<00000000006f0a44>] pgm_check_handler+0x138/0x13c
[ 1471.157701]  [<000003ff80749cc2>] xfs_vm_page_mkwrite+0x12/0x1c [xfs]
[ 1471.157800] ([<0000000000261870>] do_wp_page+0x6f8/0xa4c)
[ 1471.157805]  [<0000000000262f2c>] handle_pte_fault+0x65c/0xa10
[ 1471.157809]  [<0000000000264a22>] handle_mm_fault+0x182/0x260
[ 1471.157813]  [<00000000006f21d0>] do_protection_exception+0x1b8/0x3cc
[ 1471.157817]  [<00000000006f0a44>] pgm_check_handler+0x138/0x13c
[ 1471.157821]  [<000000008001d60a>] 0x8001d60a
[ 1471.157827] INFO: lockdep is turned off.
[ 1471.157829] Last Breaking-Event-Address:
[ 1471.157832]  [<00000000001af490>] trace_hardirqs_off_caller+0x7c/0xb0
[ 1471.157840]
[ 1471.157857] ---[ end trace dd87895f75677365 ]---
[ 1471.157863] Fixing recursive fault but reboot is needed!
[ 1471.157867] BUG: scheduling while atomic: systemd-journal/516/0x00000002
[ 1471.157870] INFO: lockdep is turned off.
[ 1471.157872] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F
) vmur(F) xfs(F) libcrc32c(F) dasd_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F
) ctcm(F) qeth(F) qdio(F) ccwgroup(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_l
og(F) dm_mod(F)
[ 1471.157928] CPU: 0 Tainted: GF     D W    3.9.3 #2
[ 1471.157931] Process systemd-journal (pid: 516, task: 00000000f5ad8000, ksp: 0
0000000f544f578)
[ 1471.157934]        00000000f544f168 00000000f544f178 0000000000000002 0000000
000000000
       00000000f544f208 00000000f544f180 00000000f544f180 0000000000100a1e
       0000000000000000 0000000000ffb000 000000000000000a 000000000000000a
       00000000f544f1c8 00000000f544f168 0000000000000000 0000000000000000
       00000000f5ad8000 0000000000100a1e 00000000f544f168 00000000f544f1b8
[ 1471.157966] Call Trace:
[ 1471.157968] ([<0000000000100920>] show_trace+0xf0/0x148)
[ 1471.157973]  [<00000000006e0e88>] __schedule_bug+0x80/0x98
[ 1471.157977]  [<00000000006ed9ea>] __schedule+0xc6a/0xcc8
[ 1471.157981]  [<000000000013a99e>] do_exit+0xc92/0xce8
[ 1471.157985]  [<0000000000100ef2>] die+0x13e/0x158
[ 1471.157990]  [<00000000006f02ac>] do_per_trap+0x0/0xb4
[ 1471.157993]  [<00000000006f0a44>] pgm_check_handler+0x138/0x13c
[ 1471.157997]  [<00000000006eb186>] mutex_lock_nested+0xde/0x36c
[ 1471.158002] ([<00000000006eb170>] mutex_lock_nested+0xc8/0x36c)
[ 1471.158006]  [<0000000000260e3e>] unmap_single_vma+0x786/0x7d0
[ 1471.158010]  [<000000000026219c>] unmap_vmas+0x50/0x74
[ 1471.158014]  [<000000000026b7aa>] exit_mmap+0x186/0x224
[ 1471.158018]  [<000000000012ef88>] mmput+0x84/0x110
[ 1471.158021]  [<0000000000139fd2>] do_exit+0x2c6/0xce8
[ 1471.158025]  [<0000000000100ef2>] die+0x13e/0x158
[ 1471.158029]  [<000000000011dd6e>] do_no_context+0xba/0xf0
[ 1471.158033]  [<00000000006f2714>] do_dat_exception+0x330/0x390
[ 1471.158037]  [<00000000006f0a44>] pgm_check_handler+0x138/0x13c
[ 1471.158041]  [<000003ff80749cc2>] xfs_vm_page_mkwrite+0x12/0x1c [xfs]
[ 1471.158070] ([<0000000000261870>] do_wp_page+0x6f8/0xa4c)
[ 1471.158074]  [<0000000000262f2c>] handle_pte_fault+0x65c/0xa10
[ 1471.158078]  [<0000000000264a22>] handle_mm_fault+0x182/0x260
[ 1471.158082]  [<00000000006f21d0>] do_protection_exception+0x1b8/0x3cc
[ 1471.158086]  [<00000000006f0a44>] pgm_check_handler+0x138/0x13c
[ 1471.158090]  [<000000008001d60a>] 0x8001d60a
[ 1471.158094] INFO: lockdep is turned off.
[ 1471.158221] Unable to handle kernel paging request at virtual user address
        (null)
[ 1471.158247] Oops: 0004 [#3] SMP
[ 1471.158251] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F
) vmur(F) xfs(F) libcrc32c(F) dasd_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F
) ctcm(F) qeth(F) qdio(F) ccwgroup(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_l
og(F) dm_mod(F)
[ 1471.158306] CPU: 0 Tainted: GF     D W    3.9.3 #2
[ 1471.158309] Process in:imklog (pid: 765, task: 00000000fc7f2430, ksp: 0000000
0fc36fd50)
[ 1471.158312] Krnl PSW : 0404e00180000000 0000000000183520 (tg_load_down+0x60/0
xb0)
[ 1471.158320]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:
3
Krnl GPRS: 0000000000000040 0000000000000000 0000000000000000 0000000000000008
[ 1471.158327]            0000000000000000 0000000000000000 00000000f9253400 000
0000000aa0854
[ 1471.158330]            0000000000aa0852 00000000001834c0 0000000000170edc 000
0000000000000
[ 1471.158333]            00000000f9187e00 00000000fcd5c800 000000000017a330 000
00000fc36fb48
[ 1471.158343] Krnl Code: 0000000000183512: a7290000            lghi    %r2,0
           0000000000183516: e31310000004       lg      %r1,0(%r3,%r1)
          #000000000018351c: b9040045           lgr     %r4,%r5
          >0000000000183520: e34010980024       stg     %r4,152(%r1)
           0000000000183526: ebbcf0700004       lmg     %r11,%r12,112(%r15)
           000000000018352c: 07fe               bcr     15,%r14
           000000000018352e: eb430003000d       sllg    %r4,%r3,3
           0000000000183534: c05000451512       larl    %r5,a25f58
[ 1471.158377] Call Trace:
[ 1471.158380] ([<000000000018bd96>] load_balance+0x236/0xc7c)
[ 1471.158385]  [<000000000018be16>] load_balance+0x2b6/0xc7c
[ 1471.158389]  [<000000000018d0a2>] idle_balance+0x212/0x494
[ 1471.158393]  [<00000000006ed9ae>] __schedule+0xc2e/0xcc8
[ 1471.158397]  [<00000000006f0c30>] io_reschedule+0xa/0x1a
[ 1471.158402]  [<000003fffd3bea22>] 0x3fffd3bea22
[ 1471.158406] INFO: lockdep is turned off.
[ 1471.158408] Last Breaking-Event-Address:
[ 1471.158411]  [<000000000017a32e>] walk_tg_tree_from+0x46/0x190
[ 1471.158416]
[ 1471.158418] ---[ end trace dd87895f75677366 ]---
[ 1471.158423] BUG: sleeping function called from invalid context at kernel/rwse
m.c:20
[ 1471.158426] in_atomic(): 1, irqs_disabled(): 0, pid: 765, name: in:imklog
[ 1471.158429] INFO: lockdep is turned off.
[ 1471.158432] CPU: 0 Tainted: GF     D W    3.9.3 #2
[ 1471.158435] Process in:imklog (pid: 765, task: 00000000fc7f2430, ksp: 0000000
0fc36fd50)
[ 1471.158438]        00000000fc36f690 00000000fc36f6a0 0000000000000002 0000000
000000000
       00000000fc36f730 00000000fc36f6a8 00000000fc36f6a8 0000000000100a1e
       0000000000000000 00000000fc7f2870 000000000000000a 0404e0010000000a
       00000000fc36f6f0 00000000fc36f690 0000000000000000 0000000000000000
       00000000006fdbc8 0000000000100a1e 00000000fc36f690 00000000fc36f6e0
[ 1471.158470] Call Trace:
[ 1471.158473] ([<0000000000100920>] show_trace+0xf0/0x148)
[ 1471.158477]  [<0000000000175c0a>] __might_sleep+0x17a/0x238
[ 1471.158482]  [<00000000006ec4de>] down_read+0x42/0xe0
[ 1471.158487]  [<000000000014fea0>] exit_signals+0x38/0x144
[ 1471.158492]  [<0000000000139dd6>] do_exit+0xca/0xce8
[ 1471.158496]  [<0000000000100ef2>] die+0x13e/0x158
[ 1471.158500]  [<000000000011dd6e>] do_no_context+0xba/0xf0
[ 1471.158504]  [<00000000006f23de>] do_protection_exception+0x3c6/0x3cc
[ 1471.158508]  [<00000000006f0a44>] pgm_check_handler+0x138/0x13c
[ 1471.158513]  [<0000000000183520>] tg_load_down+0x60/0xb0
[ 1471.158517] ([<000000000018bd96>] load_balance+0x236/0xc7c)
[ 1471.158521]  [<000000000018be16>] load_balance+0x2b6/0xc7c
[ 1471.158525]  [<000000000018d0a2>] idle_balance+0x212/0x494
[ 1471.158529]  [<00000000006ed9ae>] __schedule+0xc2e/0xcc8
[ 1471.158533]  [<00000000006f0c30>] io_reschedule+0xa/0x1a
[ 1471.158537]  [<000003fffd3bea22>] 0x3fffd3bea22
[ 1471.158541] INFO: lockdep is turned off.
[ 1471.158545] note: in:imklog[765] exited with preempt_count 3
[ 1573.704911] Unable to handle kernel pointer dereference at virtual kernel add
ress 00c040077ff00000
[ 1573.705014] Oops: 0038 [#4] SMP
[ 1573.705029] Modules linked in: lockd(F) sunrpc(F) nf_conntrack_netbios_ns(F)
nf_conntrack_broadcast(F) ipt_MASQUERADE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6ta
ble_mangle(F) ip6t_REJECT(F) nf_conntrack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(
F) nf_nat_ipv4(F) nf_nat(F) iptable_mangle(F) ipt_REJECT(F) nf_conntrack_ipv4(F)
 nf_defrag_ipv4(F) xt_conntrack(F) nf_conntrack(F) ebtable_filter(F) ebtables(F)
 ip6table_filter(F) ip6_tables(F)00: HCPGSP2629I The virtual machine is placed i
n CP mode due to a SIGP stop from
 CPU 01.
 iptable_filter(F) ip_tables(F) sg(F) qeth_l2(F) vmur(F) xfs(F) libcrc32c(F) das
d_fba_mod(F) dasd_eckd_mod(F) lcs(F) dasd_mod(F) ctcm(F) qeth(F) qdio(F) ccwgrou
p(F) fsm(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F)
[ 1573.705173] CPU: 1 Tainted: GF     D W    3.9.3 #2
[ 1573.705177] Process attr (pid: 22262, task: 00000000b1190000, ksp: 00000000b0
f43eb0)
[ 1573.705180] Krnl PSW : 0404e00180000000 000000000046c738 (lookup_object+0x20/
0x68)
[ 1573.705193]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:
3
Krnl GPRS: 7440000000000000 00c040077ff000e8 00000000fadd1eb8 0000000000000003
[ 1573.705199]            000000000046d2ba 0000000000000000 0000000084c1a828 000
0000084c1a868
[ 1573.705203]            0000000001964250 04000000001b5d64 0000000000a3bdf8 000
0000001964258
[ 1573.705206]            00000000fadd1eb8 00000000007434f0 000000000046d2cc 000
00000feb0b488
[ 1573.705221] Krnl Code: 000000000046c72c: a7380001            lhi     %r3,1
           000000000046c730: a7f40009           brc     15,46c742
          #000000000046c734: a73a0001           ahi     %r3,1
          >000000000046c738: e32010180020       cg      %r2,24(%r1)
           000000000046c73e: a7840016           brc     8,46c76a
           000000000046c742: e31010000002       ltg     %r1,0(%r1)
           000000000046c748: a774fff6           brc     7,46c734
           000000000046c74c: c010002dcfc0       larl    %r1,a266cc
[ 1573.705254] Call Trace:
[ 1573.705257] ([<000000000046d2ba>] debug_object_deactivate+0xba/0x160)
[ 1573.705263]  [<0000000000168890>] __run_hrtimer+0x58/0x474
[ 1573.705269]  [<0000000000169af2>] hrtimer_interrupt+0x116/0x2b0
[ 1573.705273]  [<0000000000104036>] clock_comparator_work+0x4a/0x54
[ 1573.705279]  [<000000000010d5b4>] do_extint+0x2b4/0x318
[ 1573.705285]  [<00000000006f0d90>] ext_skip+0x40/0x44
[ 1573.705292]  [<000003ff80108ba4>] ipt_do_table+0x298/0x8d0 [ip_tables]
[ 1573.705300] ([<000003ff801089d2>] ipt_do_table+0xc6/0x8d0 [ip_tables])
[ 1573.705305]  [<000003ff80165318>] nf_nat_ipv4_fn+0x1b4/0x354 [iptable_nat]
[ 1573.705310]  [<000003ff80165598>] nf_nat_ipv4_in+0x38/0x98 [iptable_nat]
[ 1573.705314]  [<00000000005d047c>] nf_iterate+0xd4/0x1b0
[ 1573.705903]  [<00000000005d0680>] nf_hook_slow+0x128/0x2cc
[ 1573.705909]  [<00000000005de956>] ip_rcv+0x272/0x360
[ 1573.705914]  [<0000000000592af6>] __netif_receive_skb_core+0xac2/0xe70
[ 1573.705919]  [<00000000005957e4>] netif_receive_skb+0x48/0x260
[ 1573.705924]  [<000003ff80095d16>] qeth_l2_poll+0x30a/0x540 [qeth_l2]
[ 1573.705938]  [<0000000000595f58>] net_rx_action+0x158/0x340
[ 1573.705942]  [<000000000013d8d6>] __do_softirq+0x112/0x42c
[ 1573.705947]  [<000000000013ddf8>] irq_exit+0xc8/0xe8
[ 1573.705951]  [<000000000010d55e>] do_extint+0x25e/0x318
[ 1573.705956]  [<00000000006f0d90>] ext_skip+0x40/0x44
[ 1573.705961]  [<000000000045a634>] memmove+0x14/0x5c
[ 1573.705968] ([<000003ff807d7a10>] __func__.41994+0x10/0xffffffffffffb600 [xfs
])
[ 1573.706104]  [<000003ff8076e6d2>] xfs_attr_leaf_compact+0xee/0x24c [xfs]
[ 1573.706224]  [<000003ff80772036>] xfs_attr_leaf_add+0x10a/0x268 [xfs]
[ 1573.706272]  [<000003ff8076a814>] xfs_attr_leaf_addname+0x11c/0x5a4 [xfs]
[ 1573.706303]  [<000003ff8076b028>] xfs_attr_set_int+0x38c/0x4b8 [xfs]
[ 1573.706333]  [<000003ff8076c9aa>] xfs_attr_set+0xb2/0xb8 [xfs]
[ 1573.706363]  [<000003ff8075d17e>] xfs_xattr_set+0x66/0xa0 [xfs]
[ 1573.706393]  [<00000000002d0a36>] generic_setxattr+0x7e/0x98
[ 1573.706400]  [<00000000002d1430>] __vfs_setxattr_noperm+0x78/0x1dc
[ 1573.706404]  [<00000000002d1652>] vfs_setxattr+0xbe/0xc4
[ 1573.706408]  [<00000000002d17b8>] setxattr+0x160/0x1c4
[ 1573.706412]  [<00000000002d1ba0>] SyS_lsetxattr+0xac/0xe8
[ 1573.706416]  [<00000000006f08b4>] sysc_tracego+0x14/0x1a
[ 1573.706420]  [<000003fffd2c2d1a>] 0x3fffd2c2d1a
[ 1573.706427] INFO: lockdep is turned off.
[ 1573.706430] Last Breaking-Event-Address:
[ 1573.706433]  [<000000000046c748>] lookup_object+0x30/0x68
[ 1573.706439]
[ 1573.706443] Kernel panic - not syncing: Fatal exception in interrupt
01: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 0010F384

----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "linux-s390" <linux-s390@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
> Cc: "LKML" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com, "Steve Best" <sbest@redhat.com>,
> "Hendrik Brueckner" <bhendrik@redhat.com>, "Dave Chinner" <david@fromorbit.com>
> Sent: Thursday, May 23, 2013 12:57:20 PM
> Subject: 3.9.2/3.9.3: stack overrun on s390x and ppc64 (WAS Re: 3.9.2: xfstests triggered panic)
> 
> Original report:
> http://oss.sgi.com/archives/xfs/2013-05/msg00683.html
> 
> Also seen on Power7:
> http://marc.info/?l=linux-kernel&m=136927904900692&w=2
> 
> CAI Qian
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "LKML" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
> > xfs@oss.sgi.com
> > Sent: Thursday, May 23, 2013 11:46:11 AM
> > Subject: Re: 3.9.2: xfstests triggered panic
> > 
> > On Wed, May 22, 2013 at 11:16:56PM -0400, CAI Qian wrote:
> > > ----- Original Message -----
> > > > From: "Dave Chinner" <david@fromorbit.com>
> > > > To: "CAI Qian" <caiqian@redhat.com>
> > > > Cc: "LKML" <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
> > > > xfs@oss.sgi.com
> > > > Sent: Wednesday, May 22, 2013 5:53:00 PM
> > > > Subject: Re: 3.9.2: xfstests triggered panic
> > > > 
> > > > On Wed, May 22, 2013 at 04:39:58AM -0400, CAI Qian wrote:
> > > > > Reproduced on almost all s390x guests by running xfstests.
> > > > > 
> > > > > 14634.396658¨ XFS (dm-1): Mounting Filesystem
> > > > > 14634.525522¨ XFS (dm-1): Ending clean mount
> > > > > 14640.413007¨  <000000000017c6d4>¨ idle_balance+0x1a0/0x340
> > > > > 14640.413010¨  <000000000063303e>¨ __schedule+0xa22/0xaf0
> > > > > 14640.428279¨  <0000000000630da6>¨ schedule_timeout+0x186/0x2c0
> > > > > 14640.428289¨  <00000000001cf864>¨ rcu_gp_kthread+0x1bc/0x298
> > > > > 14640.428300¨  <0000000000158c5a>¨ kthread+0xe6/0xec
> > > > > 14640.428304¨  <0000000000634de6>¨ kernel_thread_starter+0x6/0xc
> > > > > 14640.428308¨  <0000000000634de0>¨ kernel_thread_starter+0x0/0xc
> > > > > 14640.428311¨ Last Breaking-Event-Address:
> > > > > 14640.428314¨  <000000000016bd76>¨ walk_tg_tree_from+0x3a/0xf4
> > > > > 14640.428319¨  list_add corruption. next->prev should be prev
> > > > > (0000000000000918
> > > > > ), but was           (null). (next=          (null)).
> > > > 
> > > > Where's XFS in this? walk_tg_tree_from() is part of the scheduler
> > > > code. This kind of implies a stack corruption....
> > > > 
> > > > > Sometimes, this pops up,
> > > > > [16907.275002] WARNING: at kernel/rcutree.c:1960
> > > > > 
> > > > > or this,
> > > > > 15316.154171¨ XFS (dm-1): Mounting Filesystem
> > > > > 15316.255796¨ XFS (dm-1): Ending clean mount
> > > > > 15320.364246¨            00000000006367a2: e310b0080004        lg
> > > > > %r1,8(%r
> > > > > 11)
> > > > > 15320.364249¨            00000000006367a8: 41101010            la
> > > > > %r1,16(%
> > > > > r1)
> > > > > 15320.364251¨            00000000006367ac: e33010000004        lg
> > > > > %r3,0(%r
> > > > > 1)
> > > > > 15320.364252¨ Call Trace:
> > > > > 15320.364252¨ Last Breaking-Event-Address:
> > > > > 15320.364253¨  � <0000000000000000>¨ Kernel stack overflow.
> > > > > 15320.364308¨ CPU: 0 Tainted: GF       W    3.9.2 #1
> > > > > 15320.364309¨ Process rhts-test-runne (pid: 625, task:
> > > > > 000000003dccc890,
> > > > > ksp: 0
> > > > 
> > > > .... and there you go - a stack overflow. Your kernel stack size is
> > > > too small.
> > > > 
> > > > I'd suggest that you need 16k stacks on s390 - IIRC every function
> > > > call has 128 byte stack frame, and there are call chains 70-80
> > > > functions deep in the storage stack...
> > > Hmm, I am unsure how to set to 16k stack there
> > 
> > Are you build a 64 bit s390 kernel or a 32 bit kernel? 32 bit
> > kernels only have an 8k stack size, 64 bit kernels are 16k (see
> > arch/s390/Makefile).
> > 
> > $ git grep STACK_SIZE arch/s390 |head -2
> > arch/s390/Makefile:STACK_SIZE   := 8192
> > arch/s390/Makefile:STACK_SIZE   := 16384
> > 
> > As it is, the stack frame usage is worse than I thought:
> > 
> > $ git grep STACK_FRAME_OVERHEAD arch/s390 |head -2
> > arch/s390/include/uapi/asm/ptrace.h:#define STACK_FRAME_OVERHEAD 96      /*
> > size of minimum stack frame */
> > arch/s390/include/uapi/asm/ptrace.h:#define STACK_FRAME_OVERHEAD 160
> > /*
> > size of minimum stack frame */
> > 
> > Overhead is 96 bytes for 32 bit and 160 bytes for 64 bit. So 16k
> > stack size is going to have big troubles with a 70-80 function deep
> > call chain.
> > 
> > As for powerpc:
> > 
> > arch/powerpc/include/asm/ppc_asm.h:#define STACKFRAMESIZE 256
> > 
> > Yeah, same issue.
> > 
> > But, seriously, these stack traces are meaningless to anyone not
> > familiar with s390 or power7 - they indicate a problem detected
> > in the idle loop, not where ever the stack overran.
> > 
> > Can you please work with the s390/power7 people to obtain whatever
> > stack it was that overflowed, and we can go from there.
> > 
> > Cheers,
> > 
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
