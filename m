Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3LCIlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:41:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:20937 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3LCIlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:41:31 -0500
X-AuditID: cbfee690-b7f676d00000310d-82-529d99310fac
Date: Tue, 03 Dec 2013 08:41:21 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: [3.13-rc2+] BUG: soft lockup - CPU#3 stuck for 24s!
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20131203083239165@jongman.heo
Msgkey: 20131203083239165@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131129020248524@jongman.heo
X-ParentMTR: 20131129103451609@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <2820932.253101386060080992.JavaMail.weblogic@epml10>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42JZI2JSoGs0c26QwdI5UhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj+CfVgk1LxSruzxZvYJxxR7SLkZNDSEBN4ubnQ4wgtoSAicTs
	uzOZIWwxiQv31rNB1CxllNjyUgym5sm2NqB6LqD4fEaJSxu+gjWzCKhILOhZyARiswnoSHT8
	388KYgsL2Eg8+d0LZosIOErsOPgVaqiixLWli8FsXgFBiZMzn7BALFCR6PzaBBTnAIqrSpxs
	FIQIi0tcmHuJHcLmlZjR/hSqXE5i2tc1UDdLS5yftYER5v7F3x9Dxfkljt3ewQQyEqT3yf1g
	mDG7N39hg7AFJKaeOQjVqilxe/9rJghbW+LNnudMMGN2nVrODNN7f8tcsDgz0CdTuh+yg4xn
	Bupdv0sf3VO8QI9vfv8OHGoSAr0cEr8PX2GcwKg0C0ndLCSjZiGMQlaygJFlFaNoakFyQXFS
	epGJXnFibnFpXrpecn7uJkZgSjj979mEHYz3DlgfYkwGRshEZinR5HxgSskriTc0NjOyMDUx
	NTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBka9H2K9XT2pH56ZVN0N
	uvLtzm7bydXed39c1VEuquxML1k1rdfi6JOHeR+mSNucYJyU5bgnepfEdLkXSy3WOtSWppsd
	O/s2daeY1s4XjlP33l2UNHvKpnV/1vTm/Rd4H9yeIKzq4ST23imyW0Jqe938mRuU5ulWVpWf
	/tv/3EJssfEXnnvzTugosRRnJBpqMRcVJwIAw2p/Xh8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsVy+t/t6bqGM+cGGUxqErS4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRnH
	P6kWbFoqVnF/tngD44w7ol2MnBxCAmoSNz8fYgSxJQRMJJ5sa4OyxSQu3FvP1sXIBVQzn1Hi
	0oavYAkWARWJBT0LmUBsNgEdiY7/+1lBbGEBG4knv3vBbBEBR4kdB7+yQSxQlLi2dDGYzSsg
	KHFy5hMWiAUqEp1fm4DiHEBxVYmTjYIQYXGJC3MvsUPYvBIz2p9ClctJTPu6hhnClpY4P2sD
	3J2Lvz+GivNLHLu9gwlkJEjvk/vBMGN2b/7CBmELSEw9cxCqVVPi9v7XTBC2tsSbPc+ZYMbs
	OrWcGab3/pa5YHFmoE+mdD9kBxnPDNS7fpc+uqd4gR7f/P4d4wRG2VlIUrOQdM9C6EZWsoCR
	ZRWjaGpBckFxUnqFiV5xYm5xaV66XnJ+7iZGcAJ6tmQHY8MF60OMAhyMSjy8HVvnBAmxJpYV
	V+YeYpTgYFYS4Z2fPjdIiDclsbIqtSg/vqg0J7X4EGMyMMYmMkuJJucDk2NeSbyhsbGJmYmp
	pYmFgak5acJK4rwLbiUFCQmkJ5akZqemFqQWwWxh4uCUamBc3fn//KruOf6uaclHHb2k16ms
	ObOJZ3NRTcPir9WfLNN10v+sKfROZDCa6Hby1gqLYr/FPkVFxVtLdlysMLpY0BS55JvHC+cL
	if0Mao8uB26frPnsTLH0Lb8dvyMz17s4PT52lj3WcSLHdtPeEy5/f3ncsbqw4bZSu1cu03et
	W+F96+7ZTuNWYinOSDTUYi4qTgQAJAY2ooQDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB38fm0L022734


Hi, 

I'm running latest Linus git kernel (HEAD dea4f48a0a30), and got following kernel BUG.

FYI, Linux Fedora 19 guest runs on top of VMWare workstation at Windows 7 Host.
It happens intermittently, so git bisect is not doable or difficult...

====================================================================================================
[13162.605685] mptscsih: ioc0: attempting task abort! (sc=e5fc8cc0)
[13162.605719] sd 2:0:0:0: [sda] CDB: 
[13162.605724] Write(10): 2a 00 02 13 e7 c8 00 00 08 00
[13164.668850] BUG: soft lockup - CPU#3 stuck for 24s! [swapper/3:0]
[13164.668855] BUG: soft lockup - CPU#7 stuck for 36s! [ksoftirqd/7:43]
[13164.668860] Modules linked in: nls_utf8 ip6table_filter ip6_tables ebtable_nat
[13164.668867] Modules linked in:
[13164.668868]  nls_utf8
[13164.668869]  ip6table_filter
[13164.668870]  ip6_tables
[13164.668871]  ebtable_nat
[13164.668872]  ebtables
[13164.668873]  ebtables
[13164.668875]  bnep
[13164.668875]  bnep
[13164.668877]  bluetooth
[13164.668878]  bluetooth
[13164.668879]  crc32_pclmul
[13164.668880]  crc32_pclmul
[13164.668881]  crc32c_intel
[13164.668882]  crc32c_intel
[13164.668883]  vmw_balloon
[13164.668884]  vmw_balloon
[13164.668885]  i2c_piix4
[13164.668886]  i2c_piix4
[13164.668887]  microcode
[13164.668887]  microcode
[13164.668888]  vmw_vmci
[13164.668889]  vmw_vmci
[13164.668890]  uinput
[13164.668891]  uinput
[13164.668892]  vmwgfx
[13164.668893]  vmwgfx
[13164.668893]  mptspi
[13164.668894]  mptspi
[13164.668895]  ttm
[13164.668896]  ttm
[13164.668897]  scsi_transport_spi
[13164.668898]  scsi_transport_spi
[13164.668899]  drm
[13164.668900]  drm
[13164.668901]  mptscsih
[13164.668903]  mptscsih
[13164.668904]  mptbase
[13164.668906]  mptbase
[13164.668907]  i2c_core
[13164.668909]  i2c_core
[13164.668912] irq event stamp: 1636953
[13164.668913] irq event stamp: 254417
[13164.668934] hardirqs last  enabled at (254416): 
[13164.668936] hardirqs last  enabled at (1636952): 
[13164.668941] [<c0b0ae60>] restore_all_notrace+0x0/0x18
[13164.668945] [<c0b0ae60>] restore_all_notrace+0x0/0x18
[13164.668942] hardirqs last disabled at (254417): [<c0b0b2ae>] apic_timer_interrupt+0x32/0x40
[13164.668949] hardirqs last disabled at (1636953): 
[13164.668950] softirqs last  enabled at (254218): 
[13179.122235] [<c045c906>] __do_softirq+0x156/0x260
[13179.122242] softirqs last disabled at (254221): [<c045ca4d>] run_ksoftirqd+0x3d/0x70
[13179.124310] CPU: 7 PID: 43 Comm: ksoftirqd/7 Not tainted 3.13.0-rc2+ #48
[13179.124323] ------------[ cut here ]------------
[13179.124348] WARNING: CPU: 3 PID: 0 at kernel/watchdog.c:245 watchdog_overflow_callback+0xac/0xd0()
[13179.124352] Watchdog detected hard LOCKUP on cpu 3
[13179.124359] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13179.124365] task: f3668000 ti: f365e000 task.ti: f365e000
[13179.124370] EIP: 0060:[<c0b0a373>] EFLAGS: 00000282 CPU: 7
[13179.124352] Modules linked in: nls_utf8 ip6table_filter ip6_tables ebtable_nat ebtables bnep bluetooth crc32_pclmul crc32c_intel vmw_balloon i2c_piix4 microcode vmw_vmci uinput vmwgfx mptspi ttm scsi_transport_spi drm mptscsih mptbase i2c_core
[13179.126099] EIP is at _raw_spin_unlock_irqrestore+0x33/0x60
[13179.126103] EAX: 00000282 EBX: 00000282 ECX: 00000000 EDX: 00000000
[13179.126104] ESI: f34346f0 EDI: f3434748 EBP: f365fe38 ESP: f365fe30
[13179.126105]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13179.126106] CR0: 80050033 CR2: b7712000 CR3: 31f25000 CR4: 001407f0
[13179.126156] Stack:
[13179.126159]  00000282 c0bbec34 f365fe90 c08c272e 00000282 c159edb4 00000000 f1f5c900
[13179.126164]  00000002 00000282 f3434748 00002000 f34346f0 00000000 f365fe88 00000010
[13179.126167]  00000036 00000028 00000000 00003036 00003036 0000012c f3434748 00000000
[13179.126171] Call Trace:
[13191.957579]  [<c08c272e>] pcnet32_poll+0x66e/0x7b0
[13194.132312]  [<c09ec1f0>] net_rx_action+0xb0/0x1b0
[13194.132317] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc2+ #48
[13194.132320] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13194.132322]  00000000 00000000 f35c7a64 c0b02432 f35c7aa4

[13194.132330]  f35c7a94 c045798e c0d2454c
[13194.132351]  [<c045c888>] __do_softirq+0xd8/0x260
[13194.132353]  f35c7ac0 00000000 c0d2f544

[13194.132362]  [<c0b0a36f>] ? _raw_spin_unlock_irqrestore+0x2f/0x60
[13194.132356]  000000f5 c04f2f2c c04f2f2c f35c8000 c04f2e80


[13194.132369]  [<c045ca5a>] ? run_ksoftirqd+0x4a/0x70
[13194.132365]  00000000 f35c7aac c04579e3 00000009 f35c7aa4 c0d2454c f35c7ac0

[13194.132374]  f35c7ac4
[13194.132376]  [<c045ca4d>] run_ksoftirqd+0x3d/0x70
[13194.132376] Call Trace:
[13194.132385]  [<c0b02432>] dump_stack+0x48/0x60
[13194.966152]  [<c047e939>] smpboot_thread_fn+0xf9/0x190
[13194.966206] INFO: rcu_sched detected stalls on CPUs/tasks:
[13194.966403]  [<c045798e>] warn_slowpath_common+0x7e/0xa0
[13194.966407]  {
[13194.966412]  [<c04f2f2c>] ? watchdog_overflow_callback+0xac/0xd0
[13194.966417]  [<c04f2f2c>] ? watchdog_overflow_callback+0xac/0xd0
[13194.966418]  0
[13194.966421]  [<c04f2e80>] ? restart_watchdog_hrtimer+0x50/0x50
[13194.966425]  [<c04579e3>] warn_slowpath_fmt+0x33/0x40
[13194.966427]  [<c04f2f2c>] watchdog_overflow_callback+0xac/0xd0
[13194.966429]  5

[13194.966434]  [<c047e840>] ? SyS_setgroups+0x100/0x100


[13194.966437]  [<c0521cad>] __perf_event_overflow+0xad/0x2e0
[13194.966440]  [<c047743c>] kthread+0xac/0xc0


[13194.966444]  [<c0522515>] perf_event_overflow+0x15/0x20
[13195.696917]  [<c0b122f7>] ret_from_kernel_thread+0x1b/0x28

[13195.696927]  [<c0477390>] ? kthread_create_on_node+0x170/0x170
[13195.696929] Code:
[13195.696931]  26
[13195.696932]  00
[13195.696934]  8b 4d
[13195.696935]  7
[13195.696937]  04 89 c6 89
[13195.696938] } 
[13195.696941] (detected by 6, t=69426 jiffies, g=60887, c=60886, q=1606)
[13195.696940]  d3 8d 40 10 ba 01 00 00 00 e8 e2 7d 99 ff 89 f0 e8 8b a8 99 ff f6 c7 02 74 1e e8 a1 53 99 ff 89 d8 50 9d <8d> 74 26 00 64 ff 0d 30 31 f8 c0 5b 5e 5d c3 8d b6 00 00 00 00
[13195.696987] sending NMI to all CPUs:
[13195.697006] NMI backtrace for cpu 6
[13195.697009] CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.13.0-rc2+ #48
[13195.697011] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13195.697012] task: f3529220 ti: f3524000 task.ti: f3524000
[13195.697014] EIP: 0060:[<c043f58d>] EFLAGS: 00200046 CPU: 6
[13195.697020] EIP is at default_send_IPI_mask_logical+0x8d/0xf0
[13195.697022] EAX: 00000c00 EBX: ff000000 ECX: fffff000 EDX: fffff000
[13195.697023] ESI: 00200006 EDI: 00000002 EBP: f3525db8 ESP: f3525da8
[13195.697024]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13195.697025] CR0: 80050033 CR2: b7784000 CR3: 31abb000 CR4: 001407f0
[13195.697074] Stack:
[13195.697076]  00000800 00002710 c0e36580 f75aca00 f3525dc4 c043f6c0 00002710 f3525dd4
[13195.697081]  c043f822 c0d12a1d c0e36580 f3525e1c c04ba15b c0d213b0 00000006 00010f32
[13195.697084]  0000edd7 0000edd6 00000646 00000007 c0e36580 f75aca00 c0eb8a4c 00000646
[13195.697088] Call Trace:
[13195.697091]  [<c043f6c0>] default_send_IPI_all+0x60/0x70
[13195.697093]  [<c043f822>] arch_trigger_all_cpu_backtrace+0x42/0x70
[13195.697098]  [<c04ba15b>] rcu_check_callbacks+0x58b/0x5b0
[13195.697100]  [<c0464b1c>] update_process_times+0x3c/0x60
[13195.697134]  [<c04c5256>] tick_sched_handle.isra.14+0x26/0x60
[13195.697137]  [<c04c5457>] tick_sched_timer+0x37/0x70
[13195.697139]  [<c047a5eb>] __run_hrtimer+0x7b/0x1d0
[13195.697141]  [<c04c5420>] ? tick_sched_do_timer+0x30/0x30
[13195.697143]  [<c047b295>] hrtimer_interrupt+0x1f5/0x2b0
[13195.697147]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13195.697149]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13195.697151]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13195.697155]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13195.697159]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13195.697184]  [<c0418b81>] default_idle+0x21/0xc0
[13195.697188]  [<c0419356>] arch_cpu_idle+0x36/0x40
[13195.697192]  [<c04b1de2>] cpu_startup_entry+0x1f2/0x250
[13195.697195]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13195.697197]  [<c043b8ad>] start_secondary+0x21d/0x2e0
[13195.697198] Code: 00 c3 ff ff f6 c4 10 75 ed c1 e3 18 89 99 10 c3 ff ff 89 f8 09 d0 80 ce 04 83 ff 02 0f 44 c2 8b 15 a4 90 e2 c0 89 82 00 c3 ff ff <f7> c6 00 02 00 00 74 1b e8 76 01 06 00 89 f0 50 9d 8d 74 26 00
[13195.697221] NMI backtrace for cpu 7
[13195.697224] CPU: 7 PID: 43 Comm: ksoftirqd/7 Not tainted 3.13.0-rc2+ #48
[13195.697226] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13195.697227] task: f3668000 ti: f365e000 task.ti: f365e000
[13195.697229] EIP: 0060:[<c0442912>] EFLAGS: 00000002 CPU: 7
[13195.697232] EIP is at native_apic_mem_write+0x12/0x20
[13195.697233] EAX: ffffb380 EBX: f75bb240 ECX: fffff000 EDX: 0000055a
[13195.697234] ESI: 0005112c EDI: 0005112c EBP: f365fd40 ESP: f365fd40
[13195.697235]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13195.697236] CR0: 80050033 CR2: b7712000 CR3: 31f25000 CR4: 001407f0
[13195.697271] Stack:
[13195.697272]  f365fd48 c043cf6b f365fd60 c04c3685 00000000 f75bb240 3e328980 7ffff3fe
[13195.697276]  f365fd70 c04c4db9 00000000 f75bb480 f365fdcc c047b1e2 0000017c 00000000
[13195.697280]  780432d5 f5d325ca 00000bf9 f75bb584 f75bb554 f75bb524 00000002 c9728d51
[13195.697283] Call Trace:
[13195.697286]  [<c043cf6b>] lapic_next_event+0x1b/0x20
[13195.697289]  [<c04c3685>] clockevents_program_event+0x95/0x130
[13195.697291]  [<c04c4db9>] tick_program_event+0x29/0x30
[13195.697293]  [<c047b1e2>] hrtimer_interrupt+0x142/0x2b0
[13195.697296]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13195.697298]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13195.697300]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13195.697303]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13195.697306]  [<c0b0a373>] ? _raw_spin_unlock_irqrestore+0x33/0x60
[13195.697309]  [<c08c272e>] pcnet32_poll+0x66e/0x7b0
[13195.697313]  [<c09ec1f0>] net_rx_action+0xb0/0x1b0
[13195.697315]  [<c045c888>] __do_softirq+0xd8/0x260
[13195.697317]  [<c0b0a36f>] ? _raw_spin_unlock_irqrestore+0x2f/0x60
[13195.697319]  [<c045ca5a>] ? run_ksoftirqd+0x4a/0x70
[13195.697321]  [<c045ca4d>] run_ksoftirqd+0x3d/0x70
[13195.697323]  [<c047e939>] smpboot_thread_fn+0xf9/0x190
[13195.697326]  [<c047e840>] ? SyS_setgroups+0x100/0x100
[13195.697328]  [<c047743c>] kthread+0xac/0xc0
[13195.697331]  [<c0b122f7>] ret_from_kernel_thread+0x1b/0x28
[13195.697333]  [<c0477390>] ? kthread_create_on_node+0x170/0x170
[13195.697334] Code: 00 31 c0 83 c1 02 66 89 41 fe 83 eb 02 eb a5 66 90 66 90 66 90 66 90 66 90 8b 0d a4 90 e2 c0 55 89 e5 8d 84 08 00 c0 ff ff 89 10 <5d> c3 8d b6 00 00 00 00 8d bf 00 00 00 00 8b 15 a4 90 e2 c0 55
[13195.697358] NMI backtrace for cpu 1
[13195.697362] CPU: 1 PID: 393 Comm: rs:main Q:Reg Not tainted 3.13.0-rc2+ #48
[13195.697364] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13195.697366] task: f1830000 ti: f2510000 task.ti: f2510000
[13195.697368] EIP: 0060:[<c0599f82>] EFLAGS: 00010246 CPU: 1
[13195.697374] EIP is at __fd_install+0x32/0x50
[13195.697376] EAX: f191f000 EBX: f2544200 ECX: f6fcaf00 EDX: f191f000
[13195.697378] ESI: 00000008 EDI: f2544240 EBP: f2511f54 ESP: f2511f44
[13195.697380]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13195.697382] CR0: 80050033 CR2: b7564770 CR3: 32d1d000 CR4: 001407f0
[13195.697424] Stack:
[13195.697426]  f6fcaf00 00000008 00000008 f6fcaf00 f2511f60 c0599fc0 f3564000 f2511fa0
[13195.697433]  c057d95c 00000001 00000000 00000000 00000020 f2eb2ccc f6fcaf08 00008000
[13196.049452]  [<c0429ea4>] intel_pmu_handle_irq+0x1f4/0x420
[13196.049455]  00000000 00000024

[13196.116841]  [<c077412f>] ? string.isra.6+0x2f/0xc0
[13196.049461]  00000100

[13196.116853]  [<c07745be>] ? symbol_string.isra.11+0x5e/0xb0
[13196.116858]  [<c0b0ca5c>] perf_event_nmi_handler+0x2c/0x50
[13196.116861]  [<c0b0c0cf>] nmi_handle.isra.2+0x8f/0x200
[13196.116864]  [<c0b0c040>] ? __die+0x110/0x110
[13196.116867]  [<c0b0c345>] do_nmi+0x105/0x410
[13196.116870]  [<c0b0b78f>] nmi_stack_correct+0x2f/0x34
[13196.116873]  [<c07760c3>] ? delay_tsc+0x53/0x90
[13196.116876]  [<c0775fee>] __delay+0xe/0x10
[13196.116885]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.116889]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.116892]  [<c04b0441>] ? vprintk_emit+0x101/0x5c0
[13196.116895]  [<c04b0441>] vprintk_emit+0x101/0x5c0
[13196.116898]  [<c0aff2e5>] printk+0x50/0x52
[13196.116902]  [<c049f0ef>] print_irqtrace_events+0x7f/0xf0
[13196.116904]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.116907]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.116910]  [<c04f2b3a>] watchdog_timer_fn+0x11a/0x170
[13196.116913]  [<c047a5eb>] __run_hrtimer+0x7b/0x1d0
[13196.116916]  [<c04f2a20>] ? watchdog_cleanup+0x10/0x10
[13196.116919]  [<c047b295>] hrtimer_interrupt+0x1f5/0x2b0
[13196.116923]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13196.116927]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13196.116930]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13196.116933]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13196.116936]  [<c077607b>] ? delay_tsc+0xb/0x90
[13196.116939]  [<c0775fee>] __delay+0xe/0x10
[13196.116942]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.116945]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.116949]  [<c0a071bb>] ? dev_watchdog+0x5b/0x240
[13196.116951]  [<c0a071bb>] dev_watchdog+0x5b/0x240
[13196.116954]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.116957]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.116960]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.116963]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.116965]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.116968]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.116970]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.116973]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.116976]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.116977]  <IRQ>  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.116983]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.116986]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.116989]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.116992]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.116995]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.116998]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.117001]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13196.117004]  [<c043b8ad>] ? start_secondary+0x21d/0x2e0
[13196.117007] ---[ end trace 871acfcc55c300a7 ]---
[13196.117021] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 22467.300 msecs
[13196.124929]  00000001 b7564770 00000000 00000001 f2511fac
[13196.124936] Call Trace:
[13196.124944]  [<c0599fc0>] fd_install+0x20/0x30
[13196.574863]  [<c057d95c>] do_sys_open+0x17c/0x1f0
[13196.574876]  [<c057d9f2>] SyS_open+0x22/0x30
[13196.574880]  [<c0b1238d>] sysenter_do_call+0x12/0x38
[13196.574882] Code: ec 04 3e 8d 74 26 00 8d 78 40 89 c3 89 f8 89 d6 89 4d f0 e8 b1 01 57 00 8b 43 04 8b 50 04 8b 0c b2 85 c9 8b 4d f0 75 15 8b 40 04 <89> 0c b0 89 f8 e8 44 03 57 00 83 c4 04 5b 5e 5f 5d c3 0f 0b 8d
[13196.574926] NMI backtrace for cpu 4
[13196.574932] CPU: 4 PID: 342 Comm: irqbalance Tainted: G        W    3.13.0-rc2+ #48
[13196.574934] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.574936] task: f185b660 ti: f1b9c000 task.ti: f1b9c000
[13196.575145] EIP: 0060:[<c0596774>] EFLAGS: 00010046 CPU: 4
[13196.575165] EIP is at inode_init_once+0x34/0x110
[13196.575168] EAX: 00000000 EBX: ce7b0fe0 ECX: 0000007e EDX: 00000218
[13196.575169] ESI: ce7b0fc0 EDI: ce7b1000 EBP: f1b9dce0 ESP: f1b9dcd4
[13196.575171]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.575173] CR0: 80050033 CR2: b777a000 CR3: 32412000 CR4: 001407f0
[13196.575240] Stack:
[13196.575242]  00000000 f3454a00 ce7b0fc0 f1b9dce8 c05d7fd0 f1b9dcf8 c056aff7 f3454a00
[13196.575261]  ce7b1200 f1b9dd18 c056b375 00000000 f44f2600 ce7b0000 f34005c0 f3454a04
[13196.575266]  f3454a00 f1b9dd88 c0b00b8f 801c001c 00000000 001c001c c05d84d9 f3454a04
[13196.575272] Call Trace:
[13196.575281]  [<c05d7fd0>] init_once+0x10/0x20
[13196.575285]  [<c056aff7>] setup_object.isra.51+0x47/0x60
[13196.575288]  [<c056b375>] new_slab+0x165/0x280
[13196.575292]  [<c0b00b8f>] __slab_alloc.constprop.64+0x1ce/0x470
[13196.575295]  [<c05d84d9>] ? proc_alloc_inode+0x19/0x80
[13196.575299]  [<c049f4a7>] ? mark_held_locks+0x87/0xf0
[13196.575302]  [<c056dee3>] kmem_cache_alloc+0x1a3/0x1f0
[13196.575305]  [<c05d84d9>] ? proc_alloc_inode+0x19/0x80
[13196.575308]  [<c05d84d9>] proc_alloc_inode+0x19/0x80
[13196.575311]  [<c0596ca9>] alloc_inode+0x19/0x80
[13196.575314]  [<c059887f>] new_inode_pseudo+0xf/0x50
[13196.575316]  [<c05d8891>] proc_get_inode+0x11/0xe0
[13196.575321]  [<c05dd19b>] proc_lookup_de+0x6b/0xb0
[13196.575324]  [<c05dd1f7>] proc_lookup+0x17/0x20
[13196.575327]  [<c0586df7>] lookup_real+0x17/0x40
[13196.575330]  [<c058c248>] do_last+0x9d8/0x10b0
[13196.575333]  [<c0589125>] ? link_path_walk+0x1e5/0x700
[13196.575336]  [<c058c9d0>] path_openat+0xb0/0x580
[13196.575339]  [<c058d651>] do_filp_open+0x31/0x80
[13196.575343]  [<c057d8ed>] do_sys_open+0x10d/0x1f0
[13196.575376]  [<c05549a0>] ? vm_munmap+0x40/0x50
[13196.575381]  [<c0b123c2>] ? sysenter_exit+0xf/0x1e
[13196.575384]  [<c057d9f2>] SyS_open+0x22/0x30
[13196.575386]  [<c0b1238d>] sysenter_do_call+0x12/0x38
[13196.575387] Code: 8d 74 26 00 ba 18 02 00 00 a8 01 89 c3 89 c7 0f 85 ba 00 00 00 f7 c7 02 00 00 00 0f 85 c6 00 00 00 89 d1 31 c0 c1 e9 02 f6 c2 02 <f3> ab 74 09 31 c0 83 c7 02 66 89 47 fe 83 e2 01 74 03 c6 07 00
[13196.575426] NMI backtrace for cpu 5
[13196.575431] CPU: 5 PID: 1859 Comm: cifsd Tainted: G        W    3.13.0-rc2+ #48
[13196.575433] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.575435] task: ee57ecc0 ti: f3616000 task.ti: f6e7a000
[13196.575483] EIP: 0060:[<c08bf503>] EFLAGS: 00000002 CPU: 5
[13196.575487] EIP is at pcnet32_wio_write_csr+0x13/0x20
[13196.575489] EAX: 00000000 EBX: 00002000 ECX: 00000048 EDX: 00002012
[13196.575504] ESI: c0bbec34 EDI: 0000000e EBP: f3617ed4 ESP: f3617ed0
[13196.575506]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.575508] CR0: 80050033 CR2: b77b9000 CR3: 324f5000 CR4: 001407f0
[13196.575678] Stack:
[13196.575680]  f3434000 f3617f14 c08c0a19 00000036 00000001 00000000 00000001 00000000
[13196.575701]  00000282 f34346f0 f2ffeee8 000000d0 00002000 f1f77240 00004000 ee465940
[13196.575706]  c0bbea80 f3617f4c c09edd61 00000000 f3747cd0 c0bbea80 f3434000 f3747c00
[13196.575783] Call Trace:
[13196.576190]  [<c08c0a19>] pcnet32_start_xmit+0x139/0x1f0
[13196.576195]  [<c09edd61>] dev_hard_start_xmit+0x4c1/0x550
[13196.576199]  [<c0a0768b>] sch_direct_xmit+0xbb/0x2f0
[13196.576202]  [<c09ea9c3>] ? net_tx_action+0xd3/0x1d0
[13196.576205]  [<c0a07913>] __qdisc_run+0x53/0x170
[13196.576208]  [<c09ea9e6>] net_tx_action+0xf6/0x1d0
[13196.576233]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.576237]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.576238]  <IRQ> 

[13196.576242]  [<c045caed>] ? do_softirq+0x6d/0x80
[13196.576246]  [<c0a224d0>] ? ip_finish_output+0x200/0x720
[13196.576249]  [<c045cc78>] ? local_bh_enable+0xb8/0xc0
[13196.576251]  [<c0a224d0>] ? ip_finish_output+0x200/0x720
[13196.576254]  [<c0a236c0>] ? ip_output+0xc0/0x170
[13196.576289]  [<c0a236c0>] ? ip_output+0xc0/0x170
[13196.576294]  [<c0a22b26>] ? ip_local_out+0x26/0x80
[13196.576297]  [<c0a22b26>] ? ip_local_out+0x26/0x80
[13196.576299]  [<c0a22f21>] ? ip_queue_xmit+0x161/0x510
[13196.576302]  [<c0a22dc0>] ? ip_build_and_send_pkt+0x240/0x240
[13196.699343]  [<c09dec37>] ? __skb_clone+0x27/0xf0
[13196.699356]  [<c0a38847>] ? tcp_transmit_skb+0x417/0x7e0
[13196.699360]  [<c09de3a2>] ? __kmalloc_reserve.isra.30+0x22/0x70
[13196.699363]  [<c0a3b0a1>] ? tcp_connect+0x501/0x5e0
[13196.699368]  [<c04bc56d>] ? getnstimeofday+0xd/0x30
[13196.699371]  [<c04bc5e6>] ? ktime_get_real+0x16/0x30
[13196.699375]  [<c09e5f3e>] ? secure_tcp_sequence_number+0x4e/0x80
[13196.699378]  [<c0a3dccf>] ? tcp_v4_connect+0x2df/0x480
[13196.699382]  [<c0a5334e>] ? __inet_stream_connect+0x7e/0x2c0
[13196.699385]  [<c045cc2a>] ? local_bh_enable+0x6a/0xc0
[13196.699388]  [<c09d8940>] ? lock_sock_nested+0x80/0x90
[13196.699391]  [<c0a535ae>] ? inet_stream_connect+0x1e/0x50
[13196.699394]  [<c0a535bf>] ? inet_stream_connect+0x2f/0x50
[13196.699443]  [<c06d4a47>] ? generic_ip_connect+0xa7/0x4b0
[13196.699449]  [<c06d50a5>] ? cifs_reconnect+0x255/0x3e0
[13196.699452]  [<c06d542c>] ? cifs_readv_from_socket+0x1fc/0x290
[13196.699456]  [<c06ef500>] ? cifs_negotiate+0x50/0x50
[13196.699459]  [<c06d5a54>] ? cifs_demultiplex_thread+0x514/0x8d0
[13196.699463]  [<c0b0ae60>] ? restore_all+0xf/0xf
[13196.699466]  [<c06d5540>] ? dequeue_mid+0x50/0x50
[13196.699470]  [<c047743c>] ? kthread+0xac/0xc0
[13196.699474]  [<c0b122f7>] ? ret_from_kernel_thread+0x1b/0x28
[13196.699477]  [<c0477390>] ? kthread_create_on_node+0x170/0x170
[13196.699479] Code: 89 c1 0f b7 c2 8d 51 12 66 ef 8d 51 10 66 ed 5d c3 8d b4 26 00 00 00 00 55 89 e5 53 3e 8d 74 26 00 89 c3 0f b7 c2 8d 53 12 66 ef <8d> 53 10 89 c8 66 ef 5b 5d c3 8d 76 00 55 89 e5 3e 8d 74 26 00
[13196.699521] NMI backtrace for cpu 2
[13196.699527] CPU: 2 PID: 351 Comm: vmtoolsd Tainted: G        W    3.13.0-rc2+ #48
[13196.699529] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.699531] task: f1b91220 ti: f6e6c000 task.ti: f6e6c000
[13196.699533] EIP: 0073:[<b772ccea>] EFLAGS: 00000296 CPU: 2
[13196.699540] EIP is at 0xb772ccea
[13196.699542] EAX: 00000000 EBX: 00000002 ECX: 00830000 EDX: 00010000
[13196.699544] ESI: a08f0e36 EDI: 43280385 EBP: b96f49f0 ESP: bffb18fc
[13196.699545]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b

[13196.699550] NMI backtrace for cpu 0
[13196.699561] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.13.0-rc2+ #48
[13196.699563] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.699566] task: c0e1aa60 ti: f3410000 task.ti: c0e0e000
[13196.699568] EIP: 0060:[<c09014a5>] EFLAGS: 00200006 CPU: 0
[13196.699577] EIP is at uhci_hub_status_data+0xb5/0x200
[13196.699579] EAX: 00001085 EBX: f6cb8400 ECX: 00000002 EDX: 000020d2
[13196.699581] ESI: 00000012 EDI: 00000001 EBP: f3411f08 ESP: f3411ee4
[13196.699582]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.699584] CR0: 80050033 CR2: b6d15000 CR3: 31945000 CR4: 001407f0
[13196.699657] Stack:
[13196.699659]  f6cb85b0 00200282 f6cb85f8 f3411f16 0000080a 00411f30 f6cb8400 f6cb8474
[13196.699666]  00000101 f3411f28 c08da04f c0462ce0 00000000 00200246 00000000 f6cb8474
[13196.699671]  00000101 f3411f30 c08da12d f3411f74 c0462d55 00000000 00000002 00000000
[13196.699676] Call Trace:
[13196.699682]  [<c08da04f>] usb_hcd_poll_rh_status+0x3f/0x110
[13196.699686]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.699705]  [<c08da12d>] rh_timer_func+0xd/0x10
[13196.699709]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.699712]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.699715]  [<c08da120>] ? usb_hcd_poll_rh_status+0x110/0x110
[13196.699718]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.699721]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.699724]  [<c08da120>] ? usb_hcd_poll_rh_status+0x110/0x110
[13196.700278]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.700285]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.700286]  <IRQ> 

[13196.700292]  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.700296]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.700300]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.700304]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.700308]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.700311]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.700315]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.700321]  [<c0af9549>] ? rest_init+0xb9/0xc0
[13196.700324]  [<c0af9490>] ? reciprocal_value+0x30/0x30
[13196.700333]  [<c0ebeb0a>] ? start_kernel+0x3dd/0x3e3
[13196.700336]  [<c0ebe564>] ? repair_env_string+0x51/0x51
[13196.700339]  [<c0ebe38b>] ? i386_start_kernel+0x12e/0x131
[13196.700340] Code: 00 85 c0 0f 8e 54 01 00 00 b9 01 00 00 00 be 10 00 00 00 c6 45 f3 00 8d b4 26 00 00 00 00 8b 93 b4 01 00 00 8d 79 ff 01 f2 66 ed <0f> b7 c0 85 45 ec 75 0f 0f a3 bb 8c 02 00 00 19 ff 85 ff 89 c8
[13196.700378] NMI backtrace for cpu 3
[13196.700382] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.13.0-rc2+ #48
[13196.700384] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.700387] task: f3515aa0 ti: f35c6000 task.ti: f351e000
[13196.700389] EIP: 0060:[<c07760c3>] EFLAGS: 00200006 CPU: 3
[13196.700394] EIP is at delay_tsc+0x53/0x90
[13196.700396] EAX: 3ea3aa41 EBX: 00000001 ECX: 00000000 EDX: 0000e63f
[13196.700398] ESI: 3ea3aa26 EDI: 00000003 EBP: f35c7cd0 ESP: f35c7cc4
[13196.700400]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.700402] CR0: 80050033 CR2: b440b0f0 CR3: 3084b000 CR4: 001407f0
[13196.700410] Stack:
[13196.700411]  c0e35c80 168ce267 00000000 f35c7cd8 c0775fee f35c7cf4 c04a4ac3 a0929140
[13196.700418]  00000000 c0e35c80 f3515aa0 00000000 f35c7d10 c0b0a166 00000000 00000002
[13196.700424]  00000000 c04b0441 f3515aa0 f35c7d50 c04b0441 00000025 00000000 00000000
[13196.700430] Call Trace:
[13196.700435]  [<c0775fee>] __delay+0xe/0x10
[13196.700439]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.700444]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.700448]  [<c04b0441>] ? vprintk_emit+0x101/0x5c0
[13196.700451]  [<c04b0441>] vprintk_emit+0x101/0x5c0
[13196.700455]  [<c0aff2e5>] printk+0x50/0x52
[13196.700459]  [<c049f0ef>] print_irqtrace_events+0x7f/0xf0
[13196.700462]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.700465]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.700468]  [<c04f2b3a>] watchdog_timer_fn+0x11a/0x170
[13196.700472]  [<c047a5eb>] __run_hrtimer+0x7b/0x1d0
[13196.700475]  [<c04f2a20>] ? watchdog_cleanup+0x10/0x10
[13196.700478]  [<c047b295>] hrtimer_interrupt+0x1f5/0x2b0
[13196.700483]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13196.700486]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13196.700490]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13196.700493]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13196.700497]  [<c077607b>] ? delay_tsc+0xb/0x90
[13196.700500]  [<c0775fee>] __delay+0xe/0x10
[13196.700503]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.700507]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.700512]  [<c0a071bb>] ? dev_watchdog+0x5b/0x240
[13196.700515]  [<c0a071bb>] dev_watchdog+0x5b/0x240
[13196.700518]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700522]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.700525]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700528]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700531]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.700534]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.700537]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700541]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.700544]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.700546]  <IRQ> 

[13196.700550]  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.700553]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.700590]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.700595]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.700599]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.700602]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.700606]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.700609]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13196.700612]  [<c043b8ad>] ? start_secondary+0x21d/0x2e0
[13196.700614] Code: c6 eb 20 90 8d 74 26 00 64 ff 0d 30 31 f8 c0 f3 90 64 ff 05 30 31 f8 c0 64 8b 15 10 20 f8 c0 39 d7 75 20 8d 76 00 0f ae e8 0f 31 <8d> 74 26 00 89 c2 29 f2 39 da 72 d1 64 ff 0d 30 31 f8 c0 5b 5e
[13196.700686] [<c0b0b2ae>] apic_timer_interrupt+0x32/0x40
[13196.700689] softirqs last  enabled at (1596432): [<c045bc5f>] _local_bh_enable+0x1f/0x50
[13196.700691] softirqs last disabled at (1596433): [<c04132f5>] do_softirq_own_stack+0x35/0x40
[13196.700697] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.13.0-rc2+ #48
[13196.700698] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.700700] task: f3515aa0 ti: f35c6000 task.ti: f351e000
[13196.700702] EIP: 0060:[<c077607b>] EFLAGS: 00200202 CPU: 3
[13196.700705] EIP is at delay_tsc+0xb/0x90
[13196.700707] EAX: 00000001 EBX: f3747cc0 ECX: 00000001 EDX: 00007877
[13196.700709] ESI: 36c95f73 EDI: 00000000 EBP: f35c7eb4 ESP: f35c7ea8
[13196.700711]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.700712] CR0: 80050033 CR2: b440b0f0 CR3: 3084b000 CR4: 001407f0
[13196.700719] Stack:
[13196.700720]  f3747cc0 36c95f73 00000000 f35c7ebc c0775fee f35c7ed8 c04a4ac3 a0929140
[13196.700726]  00000000 f3747cc0 00000000 00000000 f35c7ef4 c0b0a166 00000000 00000002
[13196.700732]  00000000 c0a071bb f3747c00 f35c7f30 c0a071bb 00200246 00000000 00000002
[13196.700739] Call Trace:
[13196.700743]  [<c0775fee>] __delay+0xe/0x10
[13196.700746]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.700750]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.700753]  [<c0a071bb>] ? dev_watchdog+0x5b/0x240
[13196.700756]  [<c0a071bb>] dev_watchdog+0x5b/0x240
[13196.700759]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700762]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.700766]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700769]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700772]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.700775]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.700779]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700782]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.700785]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.700786]  <IRQ> 

[13196.700790]  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.700794]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.700797]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.700800]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.700804]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.700807]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.700810]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.700813]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13196.700817]  [<c043b8ad>] ? start_secondary+0x21d/0x2e0
[13196.700819] Code: d2 fa 00 00 00 8d 04 80 c1 e0 02 f7 e2 8d 42 01 ff 15 bc 24 e7 c0 5d c3 90 8d b4 26 00 00 00 00 55 89 e5 57 56 53 3e 8d 74 26 00 <64> ff 05 30 31 f8 c0 89 c3 64 8b 3d 10 20 f8 c0 8d 76 00 0f ae
[13217.675940] mptscsih: ioc0: task abort: SUCCESS (rv=2002) (sc=e5fc8cc0)
====================================================================================================

Full dmesg & .config attached below.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0-rc2+ (root@localhost.localdomain) (gcc version 4.8.2 20131017 (Red Hat 4.8.2-1) (GCC) ) #48 SMP Tue Dec 3 10:18:47 KST 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000ca000-0x00000000000cbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfeeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfef0000-0x00000000bfefefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bfeff000-0x00000000bfefffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bff00000-0x00000000bfffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffe0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[    0.000000] Hypervisor detected: VMware
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   1 base 0000000000 mask FF00000000 write-back
[    0.000000]   2 base 0100000000 mask FFC0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 3GB, range: 1GB, type UC
[    0.000000] reg 1, base: 0GB, range: 4GB, type WB
[    0.000000] reg 2, base: 4GB, range: 1GB, type WB
[    0.000000] total RAM covered: 4096M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 4GB, range: 1GB, type WB
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000f6bf0-0x000f6bff] mapped at [c00f6bf0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x371fffff]
[    0.000000]  [mem 0x37000000-0x371fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x36ffffff]
[    0.000000]  [mem 0x34000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37200000-0x375fdfff]
[    0.000000]  [mem 0x37200000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x375fdfff] page 4k
[    0.000000] BRK [0x0161d000, 0x0161dfff] PGTABLE
[    0.000000] BRK [0x0161e000, 0x01620fff] PGTABLE
[    0.000000] BRK [0x01621000, 0x01621fff] PGTABLE
[    0.000000] BRK [0x01622000, 0x01622fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37212000-0x37900fff]
[    0.000000] Allocated new RAMDISK: [mem 0x36b23000-0x372115af]
[    0.000000] Move RAMDISK from [mem 0x37212000-0x379005af] to [mem 0x36b23000-0x372115af]
[    0.000000] ACPI: RSDP 000f6b80 000024 (v02 PTLTD )
[    0.000000] ACPI: XSDT bfef0db3 00005C (v01 INTEL  440BX    06040000 VMW  01324272)
[    0.000000] ACPI: FACP bfefee73 0000F4 (v04 INTEL  440BX    06040000 PTL  000F4240)
[    0.000000] ACPI: DSDT bfef1181 00DCF2 (v01 PTLTD  Custom   06040000 MSFT 03000001)
[    0.000000] ACPI: FACS bfefffc0 000040
[    0.000000] ACPI: BOOT bfef1159 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: APIC bfef10a7 0000B2 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG bfef106b 00003C (v01 PTLTD  $PCITBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SRAT bfef0eaf 000150 (v02 VMWARE MEMPLUG  06040000 VMW  00000001)
[    0.000000] ACPI: HPET bfef0e77 000038 (v01 VMWARE VMW HPET 06040000 VMW  00000001)
[    0.000000] ACPI: WAET bfef0e4f 000028 (v01 VMWARE VMW WAET 06040000 VMW  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 4234MB HIGHMEM available.
[    0.000000] 885MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 375fe000
[    0.000000]   low ram: 0 - 375fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x375fdfff]
[    0.000000]   HighMem  [mem 0x375fe000-0x3fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xbfeeffff]
[    0.000000]   node   0: [mem 0xbff00000-0xbfffffff]
[    0.000000]   node   0: [mem 0x00000000-0x3fffffff]
[    0.000000] On node 0 totalpages: 1048462
[    0.000000] free_area_init_node: node 0, pgdat c0ea2b80, node_mem_map f4323020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1740 pages used for memmap
[    0.000000]   Normal zone: 222718 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8469 pages used for memmap
[    0.000000]   HighMem zone: 821746 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086af01 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000c9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000ca000-0x000cbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000cc000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
[    0.000000] e820: [mem 0xc0000000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages/cpu @f754f000 s38016 r0 d23424 u61440
[    0.000000] pcpu-alloc: s38016 r0 d23424 u61440 alloc=15*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1046690
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.13.0-rc2+ root=UUID=4792463a-a5f2-481e-b975-9e8cc0148332 ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16 selinux=0 rhgb quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] allocated 10485752 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000375fe:00140000)
[    0.000000] Memory: 4115420K/4193848K available (7245K kernel code, 700K rwdata, 3044K rodata, 820K init, 6640K bss, 78428K reserved, 3286984K highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
    pkmap   : 0xff600000 - 0xff800000   (2048 kB)
    vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
      .init : 0xc0ebe000 - 0xc0f8b000   ( 820 kB)
      .data : 0xc0b1376f - 0xc0ebd380   (3751 kB)
      .text : 0xc0400000 - 0xc0b1376f   (7245 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:2304 nr_irqs:744 16
[    0.000000] CPU 0 irqstacks, hard=f340e000 soft=f3410000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 31 of 31 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] TSC freq read from hypervisor : 2693.960 MHz
[    0.000000] tsc: Detected 2693.960 MHz processor
[    0.000003] Calibrating delay loop (skipped) preset value.. 5387.92 BogoMIPS (lpj=2693960)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000064] Security Framework initialized
[    0.000069] SELinux:  Disabled at boot.
[    0.000111] Mount-cache hash table entries: 512
[    0.002298] Initializing cgroup subsys memory
[    0.002320] Initializing cgroup subsys devices
[    0.002332] Initializing cgroup subsys freezer
[    0.002343] Initializing cgroup subsys net_cls
[    0.002345] Initializing cgroup subsys blkio
[    0.002347] Initializing cgroup subsys perf_event
[    0.002417] Disabled fast string operations
[    0.002420] CPU: Physical Processor ID: 0
[    0.002421] CPU: Processor Core ID: 0
[    0.002429] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.002494] mce: CPU supports 0 MCE banks
[    0.002600] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
[    0.003897] Freeing SMP alternatives memory: 28K (c0f8b000 - c0f92000)
[    0.006905] ACPI: Core revision 20131115
[    0.024972] ACPI: All ACPI Tables successfully acquired
[    0.028006] ftrace: allocating 29317 entries in 58 pages
[    0.055912] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.057216] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.067882] smpboot: CPU0: Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz (fam: 06, model: 3a, stepping: 09)
[    0.269850] Performance Events: 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.269880] ... version:                3
[    0.269882] ... bit width:              48
[    0.269883] ... generic registers:      4
[    0.269885] ... value mask:             0000ffffffffffff
[    0.269886] ... max period:             0000ffffffffffff
[    0.269887] ... fixed-purpose events:   3
[    0.269889] ... event mask:             000000070000000f
[    0.272422] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.272770] CPU 1 irqstacks, hard=f354a000 soft=f354c000
[    0.272773] x86: Booting SMP configuration:
[    0.283051] Initializing CPU#1
[    0.284046] Disabled fast string operations
[    0.284595] mce: CPU supports 0 MCE banks
[    0.272775] .... node  #0, CPUs:      #1
[    0.295134] CPU 2 irqstacks, hard=f357c000 soft=f357e000
[    0.305334] Initializing CPU#2
[    0.306342] Disabled fast string operations
[    0.306907] mce: CPU supports 0 MCE banks
[    0.295142]  #2
[    0.307364] CPU 3 irqstacks, hard=f35c4000 soft=f35c6000
[    0.322850] Initializing CPU#3
[    0.323702] Disabled fast string operations
[    0.324266] mce: CPU supports 0 MCE banks
[    0.307368]  #3
[    0.334944] CPU 4 irqstacks, hard=f35ec000 soft=f35ee000
[    0.345187] Initializing CPU#4
[    0.346130] Disabled fast string operations
[    0.346711] mce: CPU supports 0 MCE banks
[    0.334949]  #4
[    0.352356] CPU 5 irqstacks, hard=f3614000 soft=f3616000
[    0.362793] Initializing CPU#5
[    0.363640] Disabled fast string operations
[    0.364181] mce: CPU supports 0 MCE banks
[    0.352360]  #5
[    0.364772] CPU 6 irqstacks, hard=f3644000 soft=f3646000
[    0.374961] Initializing CPU#6
[    0.375954] Disabled fast string operations
[    0.376475] mce: CPU supports 0 MCE banks
[    0.364776]  #6
[    0.377420] CPU 7 irqstacks, hard=f3674000 soft=f3676000
[    0.387679] Initializing CPU#7
[    0.388679] Disabled fast string operations
[    0.389205] mce: CPU supports 0 MCE banks
[    0.377424]  #7
[    0.389324] Skipped synchronization checks as TSC is reliable.
[    0.389402] x86: Booted up 1 node, 8 CPUs
[    0.389404] smpboot: Total of 8 processors activated (43103.36 BogoMIPS)
[    0.463570] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.463633] x86 PAT enabled: cpu 4, old 0x0, new 0x7010600070106
[    0.463694] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
[    0.463751] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
[    0.463799] x86 PAT enabled: cpu 5, old 0x0, new 0x7010600070106
[    0.463858] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
[    0.463915] x86 PAT enabled: cpu 7, old 0x0, new 0x7010600070106
[    0.496743] x86 PAT enabled: cpu 6, old 0x0, new 0x7010600070106
[    0.513278] devtmpfs: initialized
[    0.514200] PM: Registering ACPI NVS region [mem 0xbfeff000-0xbfefffff] (4096 bytes)
[    0.515453] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.515454] pinctrl core: initialized pinctrl subsystem
[    0.515678] RTC time:  4:27:17, date: 12/03/13
[    0.515820] NET: Registered protocol family 16
[    0.516049] cpuidle: using governor ladder
[    0.516050] cpuidle: using governor menu
[    0.516164] ACPI: bus type PCI registered
[    0.516167] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.516340] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.516342] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.516343] PCI: Using MMCONFIG for extended config space
[    0.516344] PCI: Using configuration type 1 for base access
[    0.532267] bio: create slab <bio-0> at 0
[    0.533462] ACPI: Added _OSI(Module Device)
[    0.533468] ACPI: Added _OSI(Processor Device)
[    0.533490] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.533497] ACPI: Added _OSI(Processor Aggregator Device)
[    0.559835] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.616544] ACPI: Interpreter enabled
[    0.616560] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.616564] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131115/hwxface-580)
[    0.616593] ACPI: (supports S0 S1 S4 S5)
[    0.616594] ACPI: Using IOAPIC for interrupt routing
[    0.616635] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.651177] ACPI: No dock devices found.
[    0.688529] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    0.688538] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.688932] acpi PNP0A03:00: _OSC: platform does not support [AER]
[    0.689283] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    0.692492] ACPI: \_SB_.PCI0.EXPL: can't evaluate _ADR (0x5)
[    0.692507] ACPI: \_SB_.PCI0.DMAR: can't evaluate _ADR (0x5)
[    0.692514] ACPI: \_SB_.PCI0.VMGC: can't evaluate _ADR (0x5)
[    0.693963] PCI host bridge to bus 0000:00
[    0.693966] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.693968] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.693969] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.693970] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.693972] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.693973] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.693974] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.693976] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.693977] pci_bus 0000:00: root bus resource [io  0x0d00-0xfeff]
[    0.694035] pci 0000:00:00.0: [8086:7190] type 00 class 0x060000
[    0.694920] pci 0000:00:01.0: [8086:7191] type 01 class 0x060400
[    0.695689] pci 0000:00:07.0: [8086:7110] type 00 class 0x060100
[    0.696761] pci 0000:00:07.1: [8086:7111] type 00 class 0x01018a
[    0.699416] pci 0000:00:07.1: reg 0x20: [io  0x1060-0x106f]
[    0.700938] pci 0000:00:07.3: [8086:7113] type 00 class 0x068000
[    0.703658] pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by PIIX4 ACPI
[    0.703672] pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by PIIX4 SMB
[    0.704205] pci 0000:00:07.7: [15ad:0740] type 00 class 0x088000
[    0.705122] pci 0000:00:07.7: reg 0x10: [io  0x1080-0x10bf]
[    0.705950] pci 0000:00:07.7: reg 0x14: [mem 0xfebfe000-0xfebfffff 64bit]
[    0.710016] pci 0000:00:0f.0: [15ad:0405] type 00 class 0x030000
[    0.751218] pci 0000:00:0f.0: reg 0x10: [io  0x1070-0x107f]
[    0.790762] pci 0000:00:0f.0: reg 0x14: [mem 0xe8000000-0xefffffff pref]
[    0.830672] pci 0000:00:0f.0: reg 0x18: [mem 0xfe000000-0xfe7fffff]
[    0.988983] pci 0000:00:0f.0: reg 0x30: [mem 0x00000000-0x00007fff pref]
[    0.989666] pci 0000:00:10.0: [1000:0030] type 00 class 0x010000
[    0.991340] pci 0000:00:10.0: reg 0x10: [io  0x1400-0x14ff]
[    0.992951] pci 0000:00:10.0: reg 0x14: [mem 0xfeba0000-0xfebbffff 64bit]
[    0.994717] pci 0000:00:10.0: reg 0x1c: [mem 0xfebc0000-0xfebdffff 64bit]
[    0.999058] pci 0000:00:10.0: reg 0x30: [mem 0x00000000-0x00003fff pref]
[    0.999648] pci 0000:00:11.0: [15ad:0790] type 01 class 0x060401
[    1.000570] pci 0000:00:11.0: System wakeup disabled by ACPI
[    1.000817] pci 0000:00:15.0: [15ad:07a0] type 01 class 0x060400
[    1.001623] pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
[    1.002035] pci 0000:00:15.0: System wakeup disabled by ACPI
[    1.002212] pci 0000:00:15.1: [15ad:07a0] type 01 class 0x060400
[    1.003027] pci 0000:00:15.1: PME# supported from D0 D3hot D3cold
[    1.003497] pci 0000:00:15.1: System wakeup disabled by ACPI
[    1.003671] pci 0000:00:15.2: [15ad:07a0] type 01 class 0x060400
[    1.004507] pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
[    1.004942] pci 0000:00:15.2: System wakeup disabled by ACPI
[    1.005103] pci 0000:00:15.3: [15ad:07a0] type 01 class 0x060400
[    1.005937] pci 0000:00:15.3: PME# supported from D0 D3hot D3cold
[    1.006449] pci 0000:00:15.3: System wakeup disabled by ACPI
[    1.006620] pci 0000:00:15.4: [15ad:07a0] type 01 class 0x060400
[    1.007412] pci 0000:00:15.4: PME# supported from D0 D3hot D3cold
[    1.007834] pci 0000:00:15.4: System wakeup disabled by ACPI
[    1.007998] pci 0000:00:15.5: [15ad:07a0] type 01 class 0x060400
[    1.008823] pci 0000:00:15.5: PME# supported from D0 D3hot D3cold
[    1.009218] pci 0000:00:15.5: System wakeup disabled by ACPI
[    1.009501] pci 0000:00:15.6: [15ad:07a0] type 01 class 0x060400
[    1.010235] pci 0000:00:15.6: PME# supported from D0 D3hot D3cold
[    1.010723] pci 0000:00:15.6: System wakeup disabled by ACPI
[    1.010891] pci 0000:00:15.7: [15ad:07a0] type 01 class 0x060400
[    1.011727] pci 0000:00:15.7: PME# supported from D0 D3hot D3cold
[    1.012154] pci 0000:00:15.7: System wakeup disabled by ACPI
[    1.012427] pci 0000:00:16.0: [15ad:07a0] type 01 class 0x060400
[    1.013250] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.013675] pci 0000:00:16.0: System wakeup disabled by ACPI
[    1.013848] pci 0000:00:16.1: [15ad:07a0] type 01 class 0x060400
[    1.014675] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    1.015060] pci 0000:00:16.1: System wakeup disabled by ACPI
[    1.015242] pci 0000:00:16.2: [15ad:07a0] type 01 class 0x060400
[    1.016070] pci 0000:00:16.2: PME# supported from D0 D3hot D3cold
[    1.016545] pci 0000:00:16.2: System wakeup disabled by ACPI
[    1.016717] pci 0000:00:16.3: [15ad:07a0] type 01 class 0x060400
[    1.017596] pci 0000:00:16.3: PME# supported from D0 D3hot D3cold
[    1.017977] pci 0000:00:16.3: System wakeup disabled by ACPI
[    1.018146] pci 0000:00:16.4: [15ad:07a0] type 01 class 0x060400
[    1.018921] pci 0000:00:16.4: PME# supported from D0 D3hot D3cold
[    1.019294] pci 0000:00:16.4: System wakeup disabled by ACPI
[    1.019561] pci 0000:00:16.5: [15ad:07a0] type 01 class 0x060400
[    1.020280] pci 0000:00:16.5: PME# supported from D0 D3hot D3cold
[    1.020983] pci 0000:00:16.5: System wakeup disabled by ACPI
[    1.021186] pci 0000:00:16.6: [15ad:07a0] type 01 class 0x060400
[    1.021967] pci 0000:00:16.6: PME# supported from D0 D3hot D3cold
[    1.022330] pci 0000:00:16.6: System wakeup disabled by ACPI
[    1.022559] pci 0000:00:16.7: [15ad:07a0] type 01 class 0x060400
[    1.023298] pci 0000:00:16.7: PME# supported from D0 D3hot D3cold
[    1.023730] pci 0000:00:16.7: System wakeup disabled by ACPI
[    1.023894] pci 0000:00:17.0: [15ad:07a0] type 01 class 0x060400
[    1.024711] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    1.025096] pci 0000:00:17.0: System wakeup disabled by ACPI
[    1.025268] pci 0000:00:17.1: [15ad:07a0] type 01 class 0x060400
[    1.026036] pci 0000:00:17.1: PME# supported from D0 D3hot D3cold
[    1.026514] pci 0000:00:17.1: System wakeup disabled by ACPI
[    1.026670] pci 0000:00:17.2: [15ad:07a0] type 01 class 0x060400
[    1.027449] pci 0000:00:17.2: PME# supported from D0 D3hot D3cold
[    1.027915] pci 0000:00:17.2: System wakeup disabled by ACPI
[    1.028071] pci 0000:00:17.3: [15ad:07a0] type 01 class 0x060400
[    1.028882] pci 0000:00:17.3: PME# supported from D0 D3hot D3cold
[    1.029268] pci 0000:00:17.3: System wakeup disabled by ACPI
[    1.029475] pci 0000:00:17.4: [15ad:07a0] type 01 class 0x060400
[    1.030218] pci 0000:00:17.4: PME# supported from D0 D3hot D3cold
[    1.030699] pci 0000:00:17.4: System wakeup disabled by ACPI
[    1.030878] pci 0000:00:17.5: [15ad:07a0] type 01 class 0x060400
[    1.031696] pci 0000:00:17.5: PME# supported from D0 D3hot D3cold
[    1.032083] pci 0000:00:17.5: System wakeup disabled by ACPI
[    1.032245] pci 0000:00:17.6: [15ad:07a0] type 01 class 0x060400
[    1.033088] pci 0000:00:17.6: PME# supported from D0 D3hot D3cold
[    1.033548] pci 0000:00:17.6: System wakeup disabled by ACPI
[    1.033719] pci 0000:00:17.7: [15ad:07a0] type 01 class 0x060400
[    1.034530] pci 0000:00:17.7: PME# supported from D0 D3hot D3cold
[    1.034922] pci 0000:00:17.7: System wakeup disabled by ACPI
[    1.035087] pci 0000:00:18.0: [15ad:07a0] type 01 class 0x060400
[    1.035894] pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
[    1.036278] pci 0000:00:18.0: System wakeup disabled by ACPI
[    1.036556] pci 0000:00:18.1: [15ad:07a0] type 01 class 0x060400
[    1.037300] pci 0000:00:18.1: PME# supported from D0 D3hot D3cold
[    1.037787] pci 0000:00:18.1: System wakeup disabled by ACPI
[    1.037950] pci 0000:00:18.2: [15ad:07a0] type 01 class 0x060400
[    1.038791] pci 0000:00:18.2: PME# supported from D0 D3hot D3cold
[    1.039184] pci 0000:00:18.2: System wakeup disabled by ACPI
[    1.039447] pci 0000:00:18.3: [15ad:07a0] type 01 class 0x060400
[    1.040195] pci 0000:00:18.3: PME# supported from D0 D3hot D3cold
[    1.040648] pci 0000:00:18.3: System wakeup disabled by ACPI
[    1.040825] pci 0000:00:18.4: [15ad:07a0] type 01 class 0x060400
[    1.041606] pci 0000:00:18.4: PME# supported from D0 D3hot D3cold
[    1.041996] pci 0000:00:18.4: System wakeup disabled by ACPI
[    1.042156] pci 0000:00:18.5: [15ad:07a0] type 01 class 0x060400
[    1.042951] pci 0000:00:18.5: PME# supported from D0 D3hot D3cold
[    1.043327] pci 0000:00:18.5: System wakeup disabled by ACPI
[    1.043594] pci 0000:00:18.6: [15ad:07a0] type 01 class 0x060400
[    1.044398] pci 0000:00:18.6: PME# supported from D0 D3hot D3cold
[    1.044886] pci 0000:00:18.6: System wakeup disabled by ACPI
[    1.045058] pci 0000:00:18.7: [15ad:07a0] type 01 class 0x060400
[    1.045868] pci 0000:00:18.7: PME# supported from D0 D3hot D3cold
[    1.046256] pci 0000:00:18.7: System wakeup disabled by ACPI
[    1.046907] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.047815] acpiphp: Slot [32] registered
[    1.047877] acpiphp: Slot [33] registered
[    1.047914] acpiphp: Slot [34] registered
[    1.047948] acpiphp: Slot [35] registered
[    1.047981] acpiphp: Slot [36] registered
[    1.048019] acpiphp: Slot [37] registered
[    1.048052] acpiphp: Slot [38] registered
[    1.048088] acpiphp: Slot [39] registered
[    1.048121] acpiphp: Slot [40] registered
[    1.048154] acpiphp: Slot [41] registered
[    1.048186] acpiphp: Slot [42] registered
[    1.048219] acpiphp: Slot [43] registered
[    1.048251] acpiphp: Slot [44] registered
[    1.048283] acpiphp: Slot [45] registered
[    1.048316] acpiphp: Slot [46] registered
[    1.048578] acpiphp: Slot [47] registered
[    1.048624] acpiphp: Slot [48] registered
[    1.048675] acpiphp: Slot [49] registered
[    1.048714] acpiphp: Slot [50] registered
[    1.048750] acpiphp: Slot [51] registered
[    1.048793] acpiphp: Slot [52] registered
[    1.048831] acpiphp: Slot [53] registered
[    1.048868] acpiphp: Slot [54] registered
[    1.048919] acpiphp: Slot [55] registered
[    1.048954] acpiphp: Slot [56] registered
[    1.048987] acpiphp: Slot [57] registered
[    1.049020] acpiphp: Slot [58] registered
[    1.049056] acpiphp: Slot [59] registered
[    1.049088] acpiphp: Slot [60] registered
[    1.049121] acpiphp: Slot [61] registered
[    1.049154] acpiphp: Slot [62] registered
[    1.049186] acpiphp: Slot [63] registered
[    1.049254] pci 0000:02:00.0: [15ad:0774] type 00 class 0x0c0300
[    1.052137] pci 0000:02:00.0: reg 0x20: [io  0x20c0-0x20df]
[    1.053540] pci 0000:02:00.0: System wakeup disabled by ACPI
[    1.053695] pci 0000:02:01.0: [1022:2000] type 00 class 0x020000
[    1.054195] pci 0000:02:01.0: reg 0x10: [io  0x2000-0x207f]
[    1.057385] pci 0000:02:01.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    1.057606] pci 0000:02:01.0: System wakeup disabled by ACPI
[    1.057695] pci 0000:02:02.0: [1274:1371] type 00 class 0x040100
[    1.058226] pci 0000:02:02.0: reg 0x10: [io  0x2080-0x20bf]
[    1.062090] pci 0000:02:02.0: System wakeup disabled by ACPI
[    1.062217] pci 0000:02:03.0: [15ad:0770] type 00 class 0x0c0320
[    1.063066] pci 0000:02:03.0: reg 0x10: [mem 0xfd5ff000-0xfd5fffff]
[    1.067509] pci 0000:02:03.0: System wakeup disabled by ACPI
[    1.067870] pci 0000:00:11.0: PCI bridge to [bus 02] (subtractive decode)
[    1.067896] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
[    1.067919] pci 0000:00:11.0:   bridge window [mem 0xfd500000-0xfdffffff]
[    1.067962] pci 0000:00:11.0:   bridge window [mem 0xe7b00000-0xe7ffffff 64bit pref]
[    1.067965] pci 0000:00:11.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.067966] pci 0000:00:11.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
[    1.067967] pci 0000:00:11.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    1.067969] pci 0000:00:11.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.067970] pci 0000:00:11.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.067971] pci 0000:00:11.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    1.067973] pci 0000:00:11.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.067974] pci 0000:00:11.0:   bridge window [io  0x0d00-0xfeff] (subtractive decode)
[    1.068645] pci 0000:00:15.0: PCI bridge to [bus 03]
[    1.068669] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    1.068693] pci 0000:00:15.0:   bridge window [mem 0xfd400000-0xfd4fffff]
[    1.068736] pci 0000:00:15.0:   bridge window [mem 0xe7a00000-0xe7afffff 64bit pref]
[    1.069209] pci 0000:00:15.1: PCI bridge to [bus 04]
[    1.069232] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
[    1.069255] pci 0000:00:15.1:   bridge window [mem 0xfd000000-0xfd0fffff]
[    1.069298] pci 0000:00:15.1:   bridge window [mem 0xe7600000-0xe76fffff 64bit pref]
[    1.069815] pci 0000:00:15.2: PCI bridge to [bus 05]
[    1.069838] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    1.069860] pci 0000:00:15.2:   bridge window [mem 0xfcc00000-0xfccfffff]
[    1.069903] pci 0000:00:15.2:   bridge window [mem 0xe7200000-0xe72fffff 64bit pref]
[    1.070452] pci 0000:00:15.3: PCI bridge to [bus 06]
[    1.070496] pci 0000:00:15.3:   bridge window [mem 0xfc800000-0xfc8fffff]
[    1.070539] pci 0000:00:15.3:   bridge window [mem 0xe6e00000-0xe6efffff 64bit pref]
[    1.071001] pci 0000:00:15.4: PCI bridge to [bus 07]
[    1.071044] pci 0000:00:15.4:   bridge window [mem 0xfc400000-0xfc4fffff]
[    1.071087] pci 0000:00:15.4:   bridge window [mem 0xe6a00000-0xe6afffff 64bit pref]
[    1.071628] pci 0000:00:15.5: PCI bridge to [bus 08]
[    1.071672] pci 0000:00:15.5:   bridge window [mem 0xfc000000-0xfc0fffff]
[    1.071715] pci 0000:00:15.5:   bridge window [mem 0xe6600000-0xe66fffff 64bit pref]
[    1.072185] pci 0000:00:15.6: PCI bridge to [bus 09]
[    1.072228] pci 0000:00:15.6:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.072271] pci 0000:00:15.6:   bridge window [mem 0xe6200000-0xe62fffff 64bit pref]
[    1.072844] pci 0000:00:15.7: PCI bridge to [bus 0a]
[    1.072888] pci 0000:00:15.7:   bridge window [mem 0xfb800000-0xfb8fffff]
[    1.072932] pci 0000:00:15.7:   bridge window [mem 0xe5e00000-0xe5efffff 64bit pref]
[    1.073465] pci 0000:00:16.0: PCI bridge to [bus 0b]
[    1.073489] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
[    1.073512] pci 0000:00:16.0:   bridge window [mem 0xfd300000-0xfd3fffff]
[    1.073554] pci 0000:00:16.0:   bridge window [mem 0xe7900000-0xe79fffff 64bit pref]
[    1.074023] pci 0000:00:16.1: PCI bridge to [bus 0c]
[    1.074046] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
[    1.074068] pci 0000:00:16.1:   bridge window [mem 0xfcf00000-0xfcffffff]
[    1.074109] pci 0000:00:16.1:   bridge window [mem 0xe7500000-0xe75fffff 64bit pref]
[    1.074657] pci 0000:00:16.2: PCI bridge to [bus 0d]
[    1.074679] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
[    1.074701] pci 0000:00:16.2:   bridge window [mem 0xfcb00000-0xfcbfffff]
[    1.074743] pci 0000:00:16.2:   bridge window [mem 0xe7100000-0xe71fffff 64bit pref]
[    1.161600] pci 0000:00:16.3: PCI bridge to [bus 0e]
[    1.161755] pci 0000:00:16.3:   bridge window [mem 0xfc700000-0xfc7fffff]
[    1.161893] pci 0000:00:16.3:   bridge window [mem 0xe6d00000-0xe6dfffff 64bit pref]
[    1.163757] pci 0000:00:16.4: PCI bridge to [bus 0f]
[    1.163893] pci 0000:00:16.4:   bridge window [mem 0xfc300000-0xfc3fffff]
[    1.164018] pci 0000:00:16.4:   bridge window [mem 0xe6900000-0xe69fffff 64bit pref]
[    1.165578] pci 0000:00:16.5: PCI bridge to [bus 10]
[    1.165784] pci 0000:00:16.5:   bridge window [mem 0xfbf00000-0xfbffffff]
[    1.165910] pci 0000:00:16.5:   bridge window [mem 0xe6500000-0xe65fffff 64bit pref]
[    1.167450] pci 0000:00:16.6: PCI bridge to [bus 11]
[    1.167611] pci 0000:00:16.6:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    1.167710] pci 0000:00:16.6:   bridge window [mem 0xe6100000-0xe61fffff 64bit pref]
[    1.168788] pci 0000:00:16.7: PCI bridge to [bus 12]
[    1.168883] pci 0000:00:16.7:   bridge window [mem 0xfb700000-0xfb7fffff]
[    1.168977] pci 0000:00:16.7:   bridge window [mem 0xe5d00000-0xe5dfffff 64bit pref]
[    1.170177] pci 0000:00:17.0: PCI bridge to [bus 13]
[    1.170231] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
[    1.170282] pci 0000:00:17.0:   bridge window [mem 0xfd200000-0xfd2fffff]
[    1.170474] pci 0000:00:17.0:   bridge window [mem 0xe7800000-0xe78fffff 64bit pref]
[    1.171668] pci 0000:00:17.1: PCI bridge to [bus 14]
[    1.171719] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
[    1.171768] pci 0000:00:17.1:   bridge window [mem 0xfce00000-0xfcefffff]
[    1.171862] pci 0000:00:17.1:   bridge window [mem 0xe7400000-0xe74fffff 64bit pref]
[    1.172940] pci 0000:00:17.2: PCI bridge to [bus 15]
[    1.172989] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
[    1.173038] pci 0000:00:17.2:   bridge window [mem 0xfca00000-0xfcafffff]
[    1.173132] pci 0000:00:17.2:   bridge window [mem 0xe7000000-0xe70fffff 64bit pref]
[    1.174208] pci 0000:00:17.3: PCI bridge to [bus 16]
[    1.174317] pci 0000:00:17.3:   bridge window [mem 0xfc600000-0xfc6fffff]
[    1.174450] pci 0000:00:17.3:   bridge window [mem 0xe6c00000-0xe6cfffff 64bit pref]
[    1.175593] pci 0000:00:17.4: PCI bridge to [bus 17]
[    1.175687] pci 0000:00:17.4:   bridge window [mem 0xfc200000-0xfc2fffff]
[    1.175781] pci 0000:00:17.4:   bridge window [mem 0xe6800000-0xe68fffff 64bit pref]
[    1.176985] pci 0000:00:17.5: PCI bridge to [bus 18]
[    1.177079] pci 0000:00:17.5:   bridge window [mem 0xfbe00000-0xfbefffff]
[    1.177173] pci 0000:00:17.5:   bridge window [mem 0xe6400000-0xe64fffff 64bit pref]
[    1.178272] pci 0000:00:17.6: PCI bridge to [bus 19]
[    1.178391] pci 0000:00:17.6:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.178537] pci 0000:00:17.6:   bridge window [mem 0xe6000000-0xe60fffff 64bit pref]
[    1.179776] pci 0000:00:17.7: PCI bridge to [bus 1a]
[    1.179872] pci 0000:00:17.7:   bridge window [mem 0xfb600000-0xfb6fffff]
[    1.179966] pci 0000:00:17.7:   bridge window [mem 0xe5c00000-0xe5cfffff 64bit pref]
[    1.181072] pci 0000:00:18.0: PCI bridge to [bus 1b]
[    1.181123] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
[    1.181172] pci 0000:00:18.0:   bridge window [mem 0xfd100000-0xfd1fffff]
[    1.181266] pci 0000:00:18.0:   bridge window [mem 0xe7700000-0xe77fffff 64bit pref]
[    1.205098] pci 0000:00:18.1: PCI bridge to [bus 1c]
[    1.205134] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
[    1.205166] pci 0000:00:18.1:   bridge window [mem 0xfcd00000-0xfcdfffff]
[    1.205226] pci 0000:00:18.1:   bridge window [mem 0xe7300000-0xe73fffff 64bit pref]
[    1.205981] pci 0000:00:18.2: PCI bridge to [bus 1d]
[    1.206042] pci 0000:00:18.2:   bridge window [mem 0xfc900000-0xfc9fffff]
[    1.206102] pci 0000:00:18.2:   bridge window [mem 0xe6f00000-0xe6ffffff 64bit pref]
[    1.206793] pci 0000:00:18.3: PCI bridge to [bus 1e]
[    1.206853] pci 0000:00:18.3:   bridge window [mem 0xfc500000-0xfc5fffff]
[    1.206914] pci 0000:00:18.3:   bridge window [mem 0xe6b00000-0xe6bfffff 64bit pref]
[    1.207609] pci 0000:00:18.4: PCI bridge to [bus 1f]
[    1.207669] pci 0000:00:18.4:   bridge window [mem 0xfc100000-0xfc1fffff]
[    1.207730] pci 0000:00:18.4:   bridge window [mem 0xe6700000-0xe67fffff 64bit pref]
[    1.208433] pci 0000:00:18.5: PCI bridge to [bus 20]
[    1.208499] pci 0000:00:18.5:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    1.208559] pci 0000:00:18.5:   bridge window [mem 0xe6300000-0xe63fffff 64bit pref]
[    1.209217] pci 0000:00:18.6: PCI bridge to [bus 21]
[    1.209277] pci 0000:00:18.6:   bridge window [mem 0xfb900000-0xfb9fffff]
[    1.209357] pci 0000:00:18.6:   bridge window [mem 0xe5f00000-0xe5ffffff 64bit pref]
[    1.210049] pci 0000:00:18.7: PCI bridge to [bus 22]
[    1.210109] pci 0000:00:18.7:   bridge window [mem 0xfb500000-0xfb5fffff]
[    1.210170] pci 0000:00:18.7:   bridge window [mem 0xe5b00000-0xe5bfffff 64bit pref]
[    1.213481] pci_bus 0000:00: on NUMA node 0
[    1.213881] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 14 15)
[    1.214070] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
[    1.214255] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
[    1.214521] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 14 15)
[    1.272784] ACPI: Enabled 2 GPEs in block 00 to 0F
[    1.272795] ACPI: \_SB_.PCI0: notify handler is installed
[    1.273169] Found 1 acpi root devices
[    1.273831] vgaarb: device added: PCI:0000:00:0f.0,decodes=io+mem,owns=io+mem,locks=none
[    1.273851] vgaarb: loaded
[    1.273852] vgaarb: bridge control possible 0000:00:0f.0
[    1.274564] SCSI subsystem initialized
[    1.274915] libata version 3.00 loaded.
[    1.274948] ACPI: bus type USB registered
[    1.275005] usbcore: registered new interface driver usbfs
[    1.275019] usbcore: registered new interface driver hub
[    1.275183] usbcore: registered new device driver usb
[    1.275900] Advanced Linux Sound Architecture Driver Initialized.
[    1.275911] PCI: Using ACPI for IRQ routing
[    1.307852] PCI: pci_cache_line_size set to 64 bytes
[    1.308901] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    1.308912] e820: reserve RAM buffer [mem 0xbfef0000-0xbfffffff]
[    1.309243] NetLabel: Initializing
[    1.309244] NetLabel:  domain hash size = 128
[    1.309245] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.309274] NetLabel:  unlabeled traffic allowed by default
[    1.309591] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
[    1.309603] hpet0: 16 comparators, 64-bit 14.318180 MHz counter
[    1.406713] Switched to clocksource hpet
[    1.479065] pnp: PnP ACPI init
[    1.479106] ACPI: bus type PNP registered
[    1.479454] system 00:00: [io  0x1000-0x103f] could not be reserved
[    1.479457] system 00:00: [io  0x1040-0x104f] has been reserved
[    1.479459] system 00:00: [io  0x0cf0-0x0cf1] has been reserved
[    1.479501] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.479514] pnp 00:01: [dma 4]
[    1.479543] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.479576] pnp 00:02: Plug and Play ACPI device, IDs PNP0001 (active)
[    1.479646] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.479723] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.479765] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.479802] pnp 00:06: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.480094] system 00:07: [mem 0xfed00000-0xfed003ff] has been reserved
[    1.480098] system 00:07: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    1.483293] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.483628] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.483939] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.484194] pnp 00:0b: [dma 2]
[    1.484252] pnp 00:0b: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.484591] system 00:0c: [io  0xfce0-0xfcff] has been reserved
[    1.484594] system 00:0c: [mem 0xf0000000-0xf7ffffff] has been reserved
[    1.484597] system 00:0c: [mem 0xfe800000-0xfe9fffff] has been reserved
[    1.484600] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.491567] pnp: PnP ACPI: found 13 devices
[    1.491570] ACPI: bus type PNP unregistered
[    1.534323] pci 0000:00:15.3: bridge window [io  0x1000-0x0fff] to [bus 06] add_size 1000
[    1.534340] pci 0000:00:15.4: bridge window [io  0x1000-0x0fff] to [bus 07] add_size 1000
[    1.534358] pci 0000:00:15.5: bridge window [io  0x1000-0x0fff] to [bus 08] add_size 1000
[    1.534375] pci 0000:00:15.6: bridge window [io  0x1000-0x0fff] to [bus 09] add_size 1000
[    1.534393] pci 0000:00:15.7: bridge window [io  0x1000-0x0fff] to [bus 0a] add_size 1000
[    1.534410] pci 0000:00:16.3: bridge window [io  0x1000-0x0fff] to [bus 0e] add_size 1000
[    1.534428] pci 0000:00:16.4: bridge window [io  0x1000-0x0fff] to [bus 0f] add_size 1000
[    1.534446] pci 0000:00:16.5: bridge window [io  0x1000-0x0fff] to [bus 10] add_size 1000
[    1.534463] pci 0000:00:16.6: bridge window [io  0x1000-0x0fff] to [bus 11] add_size 1000
[    1.534481] pci 0000:00:16.7: bridge window [io  0x1000-0x0fff] to [bus 12] add_size 1000
[    1.534498] pci 0000:00:17.3: bridge window [io  0x1000-0x0fff] to [bus 16] add_size 1000
[    1.534516] pci 0000:00:17.4: bridge window [io  0x1000-0x0fff] to [bus 17] add_size 1000
[    1.534533] pci 0000:00:17.5: bridge window [io  0x1000-0x0fff] to [bus 18] add_size 1000
[    1.534551] pci 0000:00:17.6: bridge window [io  0x1000-0x0fff] to [bus 19] add_size 1000
[    1.534568] pci 0000:00:17.7: bridge window [io  0x1000-0x0fff] to [bus 1a] add_size 1000
[    1.534586] pci 0000:00:18.2: bridge window [io  0x1000-0x0fff] to [bus 1d] add_size 1000
[    1.534604] pci 0000:00:18.3: bridge window [io  0x1000-0x0fff] to [bus 1e] add_size 1000
[    1.534621] pci 0000:00:18.4: bridge window [io  0x1000-0x0fff] to [bus 1f] add_size 1000
[    1.534639] pci 0000:00:18.5: bridge window [io  0x1000-0x0fff] to [bus 20] add_size 1000
[    1.534656] pci 0000:00:18.6: bridge window [io  0x1000-0x0fff] to [bus 21] add_size 1000
[    1.534674] pci 0000:00:18.7: bridge window [io  0x1000-0x0fff] to [bus 22] add_size 1000
[    1.534685] pci 0000:00:15.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534687] pci 0000:00:15.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534689] pci 0000:00:15.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534691] pci 0000:00:15.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534693] pci 0000:00:15.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534694] pci 0000:00:16.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534696] pci 0000:00:16.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534698] pci 0000:00:16.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534700] pci 0000:00:16.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534702] pci 0000:00:16.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534703] pci 0000:00:17.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534705] pci 0000:00:17.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534707] pci 0000:00:17.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534709] pci 0000:00:17.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534710] pci 0000:00:17.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534712] pci 0000:00:18.2: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534714] pci 0000:00:18.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534716] pci 0000:00:18.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534718] pci 0000:00:18.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534719] pci 0000:00:18.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534721] pci 0000:00:18.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.534728] pci 0000:00:0f.0: BAR 6: assigned [mem 0xc0000000-0xc0007fff pref]
[    1.534732] pci 0000:00:10.0: BAR 6: assigned [mem 0xc0008000-0xc000bfff pref]
[    1.534736] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
[    1.534754] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
[    1.534761] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
[    1.534764] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
[    1.534767] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
[    1.534770] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
[    1.534773] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
[    1.534776] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
[    1.534779] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
[    1.534782] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
[    1.534785] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
[    1.534787] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
[    1.534790] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
[    1.534793] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
[    1.534796] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
[    1.534799] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
[    1.534802] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
[    1.534805] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
[    1.534808] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
[    1.534811] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
[    1.534814] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
[    1.534829] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
[    1.534832] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
[    1.534835] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
[    1.534838] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
[    1.534841] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
[    1.534845] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
[    1.534848] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
[    1.534851] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
[    1.534854] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
[    1.534857] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
[    1.534860] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
[    1.534863] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
[    1.534867] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
[    1.534870] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
[    1.534873] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
[    1.534876] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
[    1.534879] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
[    1.534882] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
[    1.534886] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
[    1.534889] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
[    1.534892] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
[    1.534899] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.534917] pci 0000:02:01.0: BAR 6: assigned [mem 0xe7b00000-0xe7b0ffff pref]
[    1.534920] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.534934] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
[    1.534951] pci 0000:00:11.0:   bridge window [mem 0xfd500000-0xfdffffff]
[    1.534969] pci 0000:00:11.0:   bridge window [mem 0xe7b00000-0xe7ffffff 64bit pref]
[    1.534986] pci 0000:00:15.0: PCI bridge to [bus 03]
[    1.535000] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
[    1.535017] pci 0000:00:15.0:   bridge window [mem 0xfd400000-0xfd4fffff]
[    1.535035] pci 0000:00:15.0:   bridge window [mem 0xe7a00000-0xe7afffff 64bit pref]
[    1.535052] pci 0000:00:15.1: PCI bridge to [bus 04]
[    1.535067] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
[    1.535085] pci 0000:00:15.1:   bridge window [mem 0xfd000000-0xfd0fffff]
[    1.535102] pci 0000:00:15.1:   bridge window [mem 0xe7600000-0xe76fffff 64bit pref]
[    1.535120] pci 0000:00:15.2: PCI bridge to [bus 05]
[    1.535134] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
[    1.535151] pci 0000:00:15.2:   bridge window [mem 0xfcc00000-0xfccfffff]
[    1.535169] pci 0000:00:15.2:   bridge window [mem 0xe7200000-0xe72fffff 64bit pref]
[    1.535186] pci 0000:00:15.3: PCI bridge to [bus 06]
[    1.535204] pci 0000:00:15.3:   bridge window [mem 0xfc800000-0xfc8fffff]
[    1.535222] pci 0000:00:15.3:   bridge window [mem 0xe6e00000-0xe6efffff 64bit pref]
[    1.535279] pci 0000:00:15.4: PCI bridge to [bus 07]
[    1.535297] pci 0000:00:15.4:   bridge window [mem 0xfc400000-0xfc4fffff]
[    1.535315] pci 0000:00:15.4:   bridge window [mem 0xe6a00000-0xe6afffff 64bit pref]
[    1.535332] pci 0000:00:15.5: PCI bridge to [bus 08]
[    1.535350] pci 0000:00:15.5:   bridge window [mem 0xfc000000-0xfc0fffff]
[    1.535367] pci 0000:00:15.5:   bridge window [mem 0xe6600000-0xe66fffff 64bit pref]
[    1.535385] pci 0000:00:15.6: PCI bridge to [bus 09]
[    1.535402] pci 0000:00:15.6:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.535420] pci 0000:00:15.6:   bridge window [mem 0xe6200000-0xe62fffff 64bit pref]
[    1.535438] pci 0000:00:15.7: PCI bridge to [bus 0a]
[    1.535455] pci 0000:00:15.7:   bridge window [mem 0xfb800000-0xfb8fffff]
[    1.535473] pci 0000:00:15.7:   bridge window [mem 0xe5e00000-0xe5efffff 64bit pref]
[    1.535490] pci 0000:00:16.0: PCI bridge to [bus 0b]
[    1.535504] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
[    1.535522] pci 0000:00:16.0:   bridge window [mem 0xfd300000-0xfd3fffff]
[    1.535539] pci 0000:00:16.0:   bridge window [mem 0xe7900000-0xe79fffff 64bit pref]
[    1.535557] pci 0000:00:16.1: PCI bridge to [bus 0c]
[    1.535571] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
[    1.535588] pci 0000:00:16.1:   bridge window [mem 0xfcf00000-0xfcffffff]
[    1.535606] pci 0000:00:16.1:   bridge window [mem 0xe7500000-0xe75fffff 64bit pref]
[    1.535624] pci 0000:00:16.2: PCI bridge to [bus 0d]
[    1.535637] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
[    1.535655] pci 0000:00:16.2:   bridge window [mem 0xfcb00000-0xfcbfffff]
[    1.535673] pci 0000:00:16.2:   bridge window [mem 0xe7100000-0xe71fffff 64bit pref]
[    1.535690] pci 0000:00:16.3: PCI bridge to [bus 0e]
[    1.535708] pci 0000:00:16.3:   bridge window [mem 0xfc700000-0xfc7fffff]
[    1.535725] pci 0000:00:16.3:   bridge window [mem 0xe6d00000-0xe6dfffff 64bit pref]
[    1.535743] pci 0000:00:16.4: PCI bridge to [bus 0f]
[    1.535760] pci 0000:00:16.4:   bridge window [mem 0xfc300000-0xfc3fffff]
[    1.535778] pci 0000:00:16.4:   bridge window [mem 0xe6900000-0xe69fffff 64bit pref]
[    1.535796] pci 0000:00:16.5: PCI bridge to [bus 10]
[    1.535813] pci 0000:00:16.5:   bridge window [mem 0xfbf00000-0xfbffffff]
[    1.535831] pci 0000:00:16.5:   bridge window [mem 0xe6500000-0xe65fffff 64bit pref]
[    1.535848] pci 0000:00:16.6: PCI bridge to [bus 11]
[    1.535866] pci 0000:00:16.6:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    1.535883] pci 0000:00:16.6:   bridge window [mem 0xe6100000-0xe61fffff 64bit pref]
[    1.535901] pci 0000:00:16.7: PCI bridge to [bus 12]
[    1.535918] pci 0000:00:16.7:   bridge window [mem 0xfb700000-0xfb7fffff]
[    1.535936] pci 0000:00:16.7:   bridge window [mem 0xe5d00000-0xe5dfffff 64bit pref]
[    1.535954] pci 0000:00:17.0: PCI bridge to [bus 13]
[    1.535968] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
[    1.535985] pci 0000:00:17.0:   bridge window [mem 0xfd200000-0xfd2fffff]
[    1.536003] pci 0000:00:17.0:   bridge window [mem 0xe7800000-0xe78fffff 64bit pref]
[    1.536020] pci 0000:00:17.1: PCI bridge to [bus 14]
[    1.536034] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
[    1.536052] pci 0000:00:17.1:   bridge window [mem 0xfce00000-0xfcefffff]
[    1.536069] pci 0000:00:17.1:   bridge window [mem 0xe7400000-0xe74fffff 64bit pref]
[    1.536087] pci 0000:00:17.2: PCI bridge to [bus 15]
[    1.536101] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
[    1.536119] pci 0000:00:17.2:   bridge window [mem 0xfca00000-0xfcafffff]
[    1.536136] pci 0000:00:17.2:   bridge window [mem 0xe7000000-0xe70fffff 64bit pref]
[    1.536154] pci 0000:00:17.3: PCI bridge to [bus 16]
[    1.536171] pci 0000:00:17.3:   bridge window [mem 0xfc600000-0xfc6fffff]
[    1.536189] pci 0000:00:17.3:   bridge window [mem 0xe6c00000-0xe6cfffff 64bit pref]
[    1.536206] pci 0000:00:17.4: PCI bridge to [bus 17]
[    1.536224] pci 0000:00:17.4:   bridge window [mem 0xfc200000-0xfc2fffff]
[    1.536242] pci 0000:00:17.4:   bridge window [mem 0xe6800000-0xe68fffff 64bit pref]
[    1.536292] pci 0000:00:17.5: PCI bridge to [bus 18]
[    1.536309] pci 0000:00:17.5:   bridge window [mem 0xfbe00000-0xfbefffff]
[    1.536327] pci 0000:00:17.5:   bridge window [mem 0xe6400000-0xe64fffff 64bit pref]
[    1.536344] pci 0000:00:17.6: PCI bridge to [bus 19]
[    1.536362] pci 0000:00:17.6:   bridge window [mem 0xfba00000-0xfbafffff]
[    1.536379] pci 0000:00:17.6:   bridge window [mem 0xe6000000-0xe60fffff 64bit pref]
[    1.536397] pci 0000:00:17.7: PCI bridge to [bus 1a]
[    1.536414] pci 0000:00:17.7:   bridge window [mem 0xfb600000-0xfb6fffff]
[    1.536432] pci 0000:00:17.7:   bridge window [mem 0xe5c00000-0xe5cfffff 64bit pref]
[    1.536450] pci 0000:00:18.0: PCI bridge to [bus 1b]
[    1.536464] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
[    1.536481] pci 0000:00:18.0:   bridge window [mem 0xfd100000-0xfd1fffff]
[    1.536499] pci 0000:00:18.0:   bridge window [mem 0xe7700000-0xe77fffff 64bit pref]
[    1.536516] pci 0000:00:18.1: PCI bridge to [bus 1c]
[    1.536530] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
[    1.536548] pci 0000:00:18.1:   bridge window [mem 0xfcd00000-0xfcdfffff]
[    1.536565] pci 0000:00:18.1:   bridge window [mem 0xe7300000-0xe73fffff 64bit pref]
[    1.536583] pci 0000:00:18.2: PCI bridge to [bus 1d]
[    1.536601] pci 0000:00:18.2:   bridge window [mem 0xfc900000-0xfc9fffff]
[    1.536618] pci 0000:00:18.2:   bridge window [mem 0xe6f00000-0xe6ffffff 64bit pref]
[    1.536636] pci 0000:00:18.3: PCI bridge to [bus 1e]
[    1.536653] pci 0000:00:18.3:   bridge window [mem 0xfc500000-0xfc5fffff]
[    1.536671] pci 0000:00:18.3:   bridge window [mem 0xe6b00000-0xe6bfffff 64bit pref]
[    1.536688] pci 0000:00:18.4: PCI bridge to [bus 1f]
[    1.536706] pci 0000:00:18.4:   bridge window [mem 0xfc100000-0xfc1fffff]
[    1.536724] pci 0000:00:18.4:   bridge window [mem 0xe6700000-0xe67fffff 64bit pref]
[    1.536741] pci 0000:00:18.5: PCI bridge to [bus 20]
[    1.536759] pci 0000:00:18.5:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    1.536776] pci 0000:00:18.5:   bridge window [mem 0xe6300000-0xe63fffff 64bit pref]
[    1.536794] pci 0000:00:18.6: PCI bridge to [bus 21]
[    1.536811] pci 0000:00:18.6:   bridge window [mem 0xfb900000-0xfb9fffff]
[    1.536829] pci 0000:00:18.6:   bridge window [mem 0xe5f00000-0xe5ffffff 64bit pref]
[    1.536846] pci 0000:00:18.7: PCI bridge to [bus 22]
[    1.536864] pci 0000:00:18.7:   bridge window [mem 0xfb500000-0xfb5fffff]
[    1.536882] pci 0000:00:18.7:   bridge window [mem 0xe5b00000-0xe5bfffff 64bit pref]
[    1.536899] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    1.536902] pci_bus 0000:00: resource 5 [mem 0x000cc000-0x000cffff]
[    1.536904] pci_bus 0000:00: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.536905] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.536907] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.536909] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.536911] pci_bus 0000:00: resource 10 [io  0x0000-0x0cf7]
[    1.536913] pci_bus 0000:00: resource 11 [io  0x0d00-0xfeff]
[    1.536915] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
[    1.536917] pci_bus 0000:02: resource 1 [mem 0xfd500000-0xfdffffff]
[    1.536918] pci_bus 0000:02: resource 2 [mem 0xe7b00000-0xe7ffffff 64bit pref]
[    1.536920] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
[    1.536922] pci_bus 0000:02: resource 5 [mem 0x000cc000-0x000cffff]
[    1.536924] pci_bus 0000:02: resource 6 [mem 0x000d0000-0x000d3fff]
[    1.536925] pci_bus 0000:02: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.536927] pci_bus 0000:02: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.536929] pci_bus 0000:02: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.536931] pci_bus 0000:02: resource 10 [io  0x0000-0x0cf7]
[    1.536932] pci_bus 0000:02: resource 11 [io  0x0d00-0xfeff]
[    1.536934] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.536936] pci_bus 0000:03: resource 1 [mem 0xfd400000-0xfd4fffff]
[    1.536938] pci_bus 0000:03: resource 2 [mem 0xe7a00000-0xe7afffff 64bit pref]
[    1.536940] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
[    1.536942] pci_bus 0000:04: resource 1 [mem 0xfd000000-0xfd0fffff]
[    1.536944] pci_bus 0000:04: resource 2 [mem 0xe7600000-0xe76fffff 64bit pref]
[    1.536945] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    1.536947] pci_bus 0000:05: resource 1 [mem 0xfcc00000-0xfccfffff]
[    1.536949] pci_bus 0000:05: resource 2 [mem 0xe7200000-0xe72fffff 64bit pref]
[    1.536951] pci_bus 0000:06: resource 1 [mem 0xfc800000-0xfc8fffff]
[    1.536953] pci_bus 0000:06: resource 2 [mem 0xe6e00000-0xe6efffff 64bit pref]
[    1.536955] pci_bus 0000:07: resource 1 [mem 0xfc400000-0xfc4fffff]
[    1.536956] pci_bus 0000:07: resource 2 [mem 0xe6a00000-0xe6afffff 64bit pref]
[    1.536958] pci_bus 0000:08: resource 1 [mem 0xfc000000-0xfc0fffff]
[    1.536960] pci_bus 0000:08: resource 2 [mem 0xe6600000-0xe66fffff 64bit pref]
[    1.536962] pci_bus 0000:09: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    1.536964] pci_bus 0000:09: resource 2 [mem 0xe6200000-0xe62fffff 64bit pref]
[    1.536966] pci_bus 0000:0a: resource 1 [mem 0xfb800000-0xfb8fffff]
[    1.536967] pci_bus 0000:0a: resource 2 [mem 0xe5e00000-0xe5efffff 64bit pref]
[    1.536969] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
[    1.536971] pci_bus 0000:0b: resource 1 [mem 0xfd300000-0xfd3fffff]
[    1.536973] pci_bus 0000:0b: resource 2 [mem 0xe7900000-0xe79fffff 64bit pref]
[    1.536975] pci_bus 0000:0c: resource 0 [io  0x9000-0x9fff]
[    1.536976] pci_bus 0000:0c: resource 1 [mem 0xfcf00000-0xfcffffff]
[    1.536978] pci_bus 0000:0c: resource 2 [mem 0xe7500000-0xe75fffff 64bit pref]
[    1.536980] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
[    1.536982] pci_bus 0000:0d: resource 1 [mem 0xfcb00000-0xfcbfffff]
[    1.536984] pci_bus 0000:0d: resource 2 [mem 0xe7100000-0xe71fffff 64bit pref]
[    1.536986] pci_bus 0000:0e: resource 1 [mem 0xfc700000-0xfc7fffff]
[    1.536987] pci_bus 0000:0e: resource 2 [mem 0xe6d00000-0xe6dfffff 64bit pref]
[    1.536989] pci_bus 0000:0f: resource 1 [mem 0xfc300000-0xfc3fffff]
[    1.536991] pci_bus 0000:0f: resource 2 [mem 0xe6900000-0xe69fffff 64bit pref]
[    1.536993] pci_bus 0000:10: resource 1 [mem 0xfbf00000-0xfbffffff]
[    1.536995] pci_bus 0000:10: resource 2 [mem 0xe6500000-0xe65fffff 64bit pref]
[    1.536997] pci_bus 0000:11: resource 1 [mem 0xfbb00000-0xfbbfffff]
[    1.536998] pci_bus 0000:11: resource 2 [mem 0xe6100000-0xe61fffff 64bit pref]
[    1.537000] pci_bus 0000:12: resource 1 [mem 0xfb700000-0xfb7fffff]
[    1.537002] pci_bus 0000:12: resource 2 [mem 0xe5d00000-0xe5dfffff 64bit pref]
[    1.537004] pci_bus 0000:13: resource 0 [io  0x6000-0x6fff]
[    1.537006] pci_bus 0000:13: resource 1 [mem 0xfd200000-0xfd2fffff]
[    1.537007] pci_bus 0000:13: resource 2 [mem 0xe7800000-0xe78fffff 64bit pref]
[    1.537009] pci_bus 0000:14: resource 0 [io  0xa000-0xafff]
[    1.537011] pci_bus 0000:14: resource 1 [mem 0xfce00000-0xfcefffff]
[    1.537013] pci_bus 0000:14: resource 2 [mem 0xe7400000-0xe74fffff 64bit pref]
[    1.537015] pci_bus 0000:15: resource 0 [io  0xe000-0xefff]
[    1.537017] pci_bus 0000:15: resource 1 [mem 0xfca00000-0xfcafffff]
[    1.537018] pci_bus 0000:15: resource 2 [mem 0xe7000000-0xe70fffff 64bit pref]
[    1.537020] pci_bus 0000:16: resource 1 [mem 0xfc600000-0xfc6fffff]
[    1.537022] pci_bus 0000:16: resource 2 [mem 0xe6c00000-0xe6cfffff 64bit pref]
[    1.537024] pci_bus 0000:17: resource 1 [mem 0xfc200000-0xfc2fffff]
[    1.537026] pci_bus 0000:17: resource 2 [mem 0xe6800000-0xe68fffff 64bit pref]
[    1.537028] pci_bus 0000:18: resource 1 [mem 0xfbe00000-0xfbefffff]
[    1.537029] pci_bus 0000:18: resource 2 [mem 0xe6400000-0xe64fffff 64bit pref]
[    1.537031] pci_bus 0000:19: resource 1 [mem 0xfba00000-0xfbafffff]
[    1.537033] pci_bus 0000:19: resource 2 [mem 0xe6000000-0xe60fffff 64bit pref]
[    1.537035] pci_bus 0000:1a: resource 1 [mem 0xfb600000-0xfb6fffff]
[    1.537037] pci_bus 0000:1a: resource 2 [mem 0xe5c00000-0xe5cfffff 64bit pref]
[    1.537039] pci_bus 0000:1b: resource 0 [io  0x7000-0x7fff]
[    1.537040] pci_bus 0000:1b: resource 1 [mem 0xfd100000-0xfd1fffff]
[    1.537042] pci_bus 0000:1b: resource 2 [mem 0xe7700000-0xe77fffff 64bit pref]
[    1.537044] pci_bus 0000:1c: resource 0 [io  0xb000-0xbfff]
[    1.537046] pci_bus 0000:1c: resource 1 [mem 0xfcd00000-0xfcdfffff]
[    1.537048] pci_bus 0000:1c: resource 2 [mem 0xe7300000-0xe73fffff 64bit pref]
[    1.537050] pci_bus 0000:1d: resource 1 [mem 0xfc900000-0xfc9fffff]
[    1.537051] pci_bus 0000:1d: resource 2 [mem 0xe6f00000-0xe6ffffff 64bit pref]
[    1.537053] pci_bus 0000:1e: resource 1 [mem 0xfc500000-0xfc5fffff]
[    1.537055] pci_bus 0000:1e: resource 2 [mem 0xe6b00000-0xe6bfffff 64bit pref]
[    1.537057] pci_bus 0000:1f: resource 1 [mem 0xfc100000-0xfc1fffff]
[    1.537059] pci_bus 0000:1f: resource 2 [mem 0xe6700000-0xe67fffff 64bit pref]
[    1.537061] pci_bus 0000:20: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    1.537063] pci_bus 0000:20: resource 2 [mem 0xe6300000-0xe63fffff 64bit pref]
[    1.537065] pci_bus 0000:21: resource 1 [mem 0xfb900000-0xfb9fffff]
[    1.537066] pci_bus 0000:21: resource 2 [mem 0xe5f00000-0xe5ffffff 64bit pref]
[    1.537068] pci_bus 0000:22: resource 1 [mem 0xfb500000-0xfb5fffff]
[    1.537070] pci_bus 0000:22: resource 2 [mem 0xe5b00000-0xe5bfffff 64bit pref]
[    1.537088] NET: Registered protocol family 2
[    1.537365] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    1.538372] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    1.540295] TCP: Hash tables configured (established 8192 bind 8192)
[    1.540313] TCP: reno registered
[    1.540326] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    1.540343] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    1.540361] NET: Registered protocol family 1
[    1.540782] RPC: Registered named UNIX socket transport module.
[    1.540785] RPC: Registered udp transport module.
[    1.540787] RPC: Registered tcp transport module.
[    1.540788] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.540795] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.540812] pci 0000:00:0f.0: Boot video device
[    1.542311] PCI: CLS 32 bytes, default 64
[    1.542329] Unpacking initramfs...
[    1.778340] Freeing initrd memory: 7100K (f6b23000 - f7212000)
[    1.778375] Simple Boot Flag at 0x36 set to 0x80
[    1.800282] Switched to clocksource tsc
[    1.801972] apm: BIOS not found.
[    1.808353] Initialise system trusted keyring
[    1.808372] audit: initializing netlink socket (disabled)
[    1.808390] type=2000 audit(1386044837.993:1): initialized
[    1.819652] bounce pool size: 64 pages
[    1.819670] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.821422] VFS: Disk quotas dquot_6.5.2
[    1.821441] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.823367] NFS: Registering the id_resolver key type
[    1.823385] Key type id_resolver registered
[    1.823402] Key type id_legacy registered
[    1.823415] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.823434] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.824076] msgmni has been set to 1631
[    1.826690] alg: No test for stdrng (krng)
[    1.826729] NET: Registered protocol family 38
[    1.826748] Key type asymmetric registered
[    1.826767] Asymmetric key parser 'x509' registered
[    1.826786] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.827065] io scheduler noop registered
[    1.827077] io scheduler deadline registered
[    1.827096] io scheduler cfq registered (default)
[    1.827211] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
[    1.827230] pcieport 0000:00:15.1: irq 41 for MSI/MSI-X
[    1.827249] pcieport 0000:00:15.2: irq 42 for MSI/MSI-X
[    1.827268] pcieport 0000:00:15.3: irq 43 for MSI/MSI-X
[    1.827288] pcieport 0000:00:15.4: irq 44 for MSI/MSI-X
[    1.827307] pcieport 0000:00:15.5: irq 45 for MSI/MSI-X
[    1.827326] pcieport 0000:00:15.6: irq 46 for MSI/MSI-X
[    1.827345] pcieport 0000:00:15.7: irq 47 for MSI/MSI-X
[    1.827364] pcieport 0000:00:16.0: irq 48 for MSI/MSI-X
[    1.828229] pcieport 0000:00:16.1: irq 49 for MSI/MSI-X
[    1.828248] pcieport 0000:00:16.2: irq 50 for MSI/MSI-X
[    1.828267] pcieport 0000:00:16.3: irq 51 for MSI/MSI-X
[    1.828286] pcieport 0000:00:16.4: irq 52 for MSI/MSI-X
[    1.828305] pcieport 0000:00:16.5: irq 53 for MSI/MSI-X
[    1.828324] pcieport 0000:00:16.6: irq 54 for MSI/MSI-X
[    1.828344] pcieport 0000:00:16.7: irq 55 for MSI/MSI-X
[    1.829258] pcieport 0000:00:17.0: irq 56 for MSI/MSI-X
[    1.829277] pcieport 0000:00:17.1: irq 57 for MSI/MSI-X
[    1.829296] pcieport 0000:00:17.2: irq 58 for MSI/MSI-X
[    1.829315] pcieport 0000:00:17.3: irq 59 for MSI/MSI-X
[    1.829334] pcieport 0000:00:17.4: irq 60 for MSI/MSI-X
[    1.829353] pcieport 0000:00:17.5: irq 61 for MSI/MSI-X
[    1.829372] pcieport 0000:00:17.6: irq 62 for MSI/MSI-X
[    1.829392] pcieport 0000:00:17.7: irq 63 for MSI/MSI-X
[    1.829411] pcieport 0000:00:18.0: irq 64 for MSI/MSI-X
[    1.829430] pcieport 0000:00:18.1: irq 65 for MSI/MSI-X
[    1.829449] pcieport 0000:00:18.2: irq 66 for MSI/MSI-X
[    1.829468] pcieport 0000:00:18.3: irq 67 for MSI/MSI-X
[    1.829487] pcieport 0000:00:18.4: irq 68 for MSI/MSI-X
[    1.829506] pcieport 0000:00:18.5: irq 69 for MSI/MSI-X
[    1.829526] pcieport 0000:00:18.6: irq 70 for MSI/MSI-X
[    1.829545] pcieport 0000:00:18.7: irq 71 for MSI/MSI-X
[    1.829564] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.829583] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.829602] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.829621] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.829640] pcieport 0000:00:15.2: Signaling PME through PCIe PME interrupt
[    1.829660] pcie_pme 0000:00:15.2:pcie01: service driver pcie_pme loaded
[    1.829679] pcieport 0000:00:15.3: Signaling PME through PCIe PME interrupt
[    1.829698] pcie_pme 0000:00:15.3:pcie01: service driver pcie_pme loaded
[    1.829717] pcieport 0000:00:15.4: Signaling PME through PCIe PME interrupt
[    1.829736] pcie_pme 0000:00:15.4:pcie01: service driver pcie_pme loaded
[    1.829755] pcieport 0000:00:15.5: Signaling PME through PCIe PME interrupt
[    1.829774] pcie_pme 0000:00:15.5:pcie01: service driver pcie_pme loaded
[    1.829794] pcieport 0000:00:15.6: Signaling PME through PCIe PME interrupt
[    1.829813] pcie_pme 0000:00:15.6:pcie01: service driver pcie_pme loaded
[    1.829832] pcieport 0000:00:15.7: Signaling PME through PCIe PME interrupt
[    1.829851] pcie_pme 0000:00:15.7:pcie01: service driver pcie_pme loaded
[    1.829870] pcieport 0000:00:16.0: Signaling PME through PCIe PME interrupt
[    1.829889] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme loaded
[    1.829908] pcieport 0000:00:16.1: Signaling PME through PCIe PME interrupt
[    1.829928] pcie_pme 0000:00:16.1:pcie01: service driver pcie_pme loaded
[    1.829947] pcieport 0000:00:16.2: Signaling PME through PCIe PME interrupt
[    1.829966] pcie_pme 0000:00:16.2:pcie01: service driver pcie_pme loaded
[    1.829985] pcieport 0000:00:16.3: Signaling PME through PCIe PME interrupt
[    1.830004] pcie_pme 0000:00:16.3:pcie01: service driver pcie_pme loaded
[    1.830023] pcieport 0000:00:16.4: Signaling PME through PCIe PME interrupt
[    1.830042] pcie_pme 0000:00:16.4:pcie01: service driver pcie_pme loaded
[    1.830058] pcieport 0000:00:16.5: Signaling PME through PCIe PME interrupt
[    1.830071] pcie_pme 0000:00:16.5:pcie01: service driver pcie_pme loaded
[    1.830083] pcieport 0000:00:16.6: Signaling PME through PCIe PME interrupt
[    1.830094] pcie_pme 0000:00:16.6:pcie01: service driver pcie_pme loaded
[    1.830252] pcieport 0000:00:16.7: Signaling PME through PCIe PME interrupt
[    1.830271] pcie_pme 0000:00:16.7:pcie01: service driver pcie_pme loaded
[    1.830291] pcieport 0000:00:17.0: Signaling PME through PCIe PME interrupt
[    1.830310] pcie_pme 0000:00:17.0:pcie01: service driver pcie_pme loaded
[    1.830329] pcieport 0000:00:17.1: Signaling PME through PCIe PME interrupt
[    1.830348] pcie_pme 0000:00:17.1:pcie01: service driver pcie_pme loaded
[    1.830367] pcieport 0000:00:17.2: Signaling PME through PCIe PME interrupt
[    1.830386] pcie_pme 0000:00:17.2:pcie01: service driver pcie_pme loaded
[    1.830405] pcieport 0000:00:17.3: Signaling PME through PCIe PME interrupt
[    1.830425] pcie_pme 0000:00:17.3:pcie01: service driver pcie_pme loaded
[    1.830444] pcieport 0000:00:17.4: Signaling PME through PCIe PME interrupt
[    1.830463] pcie_pme 0000:00:17.4:pcie01: service driver pcie_pme loaded
[    1.830482] pcieport 0000:00:17.5: Signaling PME through PCIe PME interrupt
[    1.830501] pcie_pme 0000:00:17.5:pcie01: service driver pcie_pme loaded
[    1.830520] pcieport 0000:00:17.6: Signaling PME through PCIe PME interrupt
[    1.830539] pcie_pme 0000:00:17.6:pcie01: service driver pcie_pme loaded
[    1.830559] pcieport 0000:00:17.7: Signaling PME through PCIe PME interrupt
[    1.830578] pcie_pme 0000:00:17.7:pcie01: service driver pcie_pme loaded
[    1.830597] pcieport 0000:00:18.0: Signaling PME through PCIe PME interrupt
[    1.830616] pcie_pme 0000:00:18.0:pcie01: service driver pcie_pme loaded
[    1.830635] pcieport 0000:00:18.1: Signaling PME through PCIe PME interrupt
[    1.830654] pcie_pme 0000:00:18.1:pcie01: service driver pcie_pme loaded
[    1.830673] pcieport 0000:00:18.2: Signaling PME through PCIe PME interrupt
[    1.830693] pcie_pme 0000:00:18.2:pcie01: service driver pcie_pme loaded
[    1.830712] pcieport 0000:00:18.3: Signaling PME through PCIe PME interrupt
[    1.830731] pcie_pme 0000:00:18.3:pcie01: service driver pcie_pme loaded
[    1.830750] pcieport 0000:00:18.4: Signaling PME through PCIe PME interrupt
[    1.830769] pcie_pme 0000:00:18.4:pcie01: service driver pcie_pme loaded
[    1.830788] pcieport 0000:00:18.5: Signaling PME through PCIe PME interrupt
[    1.830807] pcie_pme 0000:00:18.5:pcie01: service driver pcie_pme loaded
[    1.830827] pcieport 0000:00:18.6: Signaling PME through PCIe PME interrupt
[    1.830846] pcie_pme 0000:00:18.6:pcie01: service driver pcie_pme loaded
[    1.830865] pcieport 0000:00:18.7: Signaling PME through PCIe PME interrupt
[    1.830884] pcie_pme 0000:00:18.7:pcie01: service driver pcie_pme loaded
[    1.830903] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.831199] kobject: 'pciehp_dummy' (f2c71c00): kobject_release, parent f2f48ce8 (delayed)
[    1.831218] pciehp 0000:00:15.0:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.831473] pciehp 0000:00:15.0:pcie04: service driver pciehp loaded
[    1.831492] pciehp 0000:00:15.1:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.831664] pciehp 0000:00:15.1:pcie04: service driver pciehp loaded
[    1.831683] pciehp 0000:00:15.2:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.831881] pciehp 0000:00:15.2:pcie04: service driver pciehp loaded
[    1.831900] pciehp 0000:00:15.3:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.832101] pciehp 0000:00:15.3:pcie04: service driver pciehp loaded
[    1.832109] pciehp 0000:00:15.4:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.832281] pciehp 0000:00:15.4:pcie04: service driver pciehp loaded
[    1.832300] pciehp 0000:00:15.5:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.832488] pciehp 0000:00:15.5:pcie04: service driver pciehp loaded
[    1.832508] pciehp 0000:00:15.6:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.832676] pciehp 0000:00:15.6:pcie04: service driver pciehp loaded
[    1.832695] pciehp 0000:00:15.7:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.832880] pciehp 0000:00:15.7:pcie04: service driver pciehp loaded
[    1.832899] pciehp 0000:00:16.0:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.833074] pciehp 0000:00:16.0:pcie04: service driver pciehp loaded
[    1.833093] pciehp 0000:00:16.1:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.833254] pciehp 0000:00:16.1:pcie04: service driver pciehp loaded
[    1.833273] pciehp 0000:00:16.2:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.833450] pciehp 0000:00:16.2:pcie04: service driver pciehp loaded
[    1.833470] pciehp 0000:00:16.3:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.833643] pciehp 0000:00:16.3:pcie04: service driver pciehp loaded
[    1.833663] pciehp 0000:00:16.4:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.833829] pciehp 0000:00:16.4:pcie04: service driver pciehp loaded
[    1.833849] pciehp 0000:00:16.5:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.834061] pciehp 0000:00:16.5:pcie04: service driver pciehp loaded
[    1.834081] pciehp 0000:00:16.6:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.834314] pciehp 0000:00:16.6:pcie04: service driver pciehp loaded
[    1.834334] pciehp 0000:00:16.7:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.834528] pciehp 0000:00:16.7:pcie04: service driver pciehp loaded
[    1.834547] pciehp 0000:00:17.0:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.834738] pciehp 0000:00:17.0:pcie04: service driver pciehp loaded
[    1.834757] pciehp 0000:00:17.1:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.834944] pciehp 0000:00:17.1:pcie04: service driver pciehp loaded
[    1.834963] pciehp 0000:00:17.2:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.835215] pciehp 0000:00:17.2:pcie04: service driver pciehp loaded
[    1.835235] pciehp 0000:00:17.3:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.835547] pciehp 0000:00:17.3:pcie04: service driver pciehp loaded
[    1.835567] pciehp 0000:00:17.4:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.835739] pciehp 0000:00:17.4:pcie04: service driver pciehp loaded
[    1.835758] pciehp 0000:00:17.5:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.835962] pciehp 0000:00:17.5:pcie04: service driver pciehp loaded
[    1.835982] pciehp 0000:00:17.6:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.836248] pciehp 0000:00:17.6:pcie04: service driver pciehp loaded
[    1.836268] pciehp 0000:00:17.7:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.836422] pciehp 0000:00:17.7:pcie04: service driver pciehp loaded
[    1.836442] pciehp 0000:00:18.0:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.836649] pciehp 0000:00:18.0:pcie04: service driver pciehp loaded
[    1.836668] pciehp 0000:00:18.1:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.836876] pciehp 0000:00:18.1:pcie04: service driver pciehp loaded
[    1.836896] pciehp 0000:00:18.2:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.837092] pciehp 0000:00:18.2:pcie04: service driver pciehp loaded
[    1.837101] pciehp 0000:00:18.3:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.837291] pciehp 0000:00:18.3:pcie04: service driver pciehp loaded
[    1.837310] pciehp 0000:00:18.4:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.837482] pciehp 0000:00:18.4:pcie04: service driver pciehp loaded
[    1.837501] pciehp 0000:00:18.5:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.837675] pciehp 0000:00:18.5:pcie04: service driver pciehp loaded
[    1.837694] pciehp 0000:00:18.6:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.837849] pciehp 0000:00:18.6:pcie04: service driver pciehp loaded
[    1.837869] pciehp 0000:00:18.7:pcie04: HPC vendor_id 15ad device_id 7a0 ss_vid 15ad ss_did 7a0
[    1.838019] pciehp 0000:00:18.7:pcie04: service driver pciehp loaded
[    1.838038] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.838214] intel_idle: does not run on family 6 model 58
[    1.838314] ACPI: AC Adapter [ACAD] (on-line)
[    1.838356] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.838376] ACPI: Power Button [PWRF]
[    1.838883] GHES: HEST is not enabled!
[    1.839028] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.860265] 00:09: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.881289] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.882504] Non-volatile memory driver v1.3
[    1.882517] Linux agpgart interface v0.103
[    1.882536] kobject: 'agpgart-amd64' (f3689100): kobject_release, parent f371c268 (delayed)
[    1.882556] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
[    1.883738] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
[    1.884831] loop: module loaded
[    1.884851] ata_piix 0000:00:07.1: version 2.13
[    1.885349] scsi0 : ata_piix
[    1.885492] scsi1 : ata_piix
[    1.885511] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1060 irq 14
[    1.885522] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1068 irq 15
[    1.885687] libphy: Fixed MDIO Bus: probed
[    1.885696] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    1.886247] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:ac:82:6a assigned IRQ 19
[    1.886286] pcnet32: eth0: registered as PCnet/PCI II 79C970A
[    1.886306] pcnet32: 1 cards_found
[    1.886317] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    1.886455] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.886472] ehci-pci: EHCI PCI platform driver
[    1.886491] ehci-pci 0000:02:03.0: EHCI Host Controller
[    1.886649] ehci-pci 0000:02:03.0: new USB bus registered, assigned bus number 1
[    1.886668] ehci-pci 0000:02:03.0: cache line size of 32 is not supported
[    1.886688] ehci-pci 0000:02:03.0: irq 17, io mem 0xfd5ff000
[    1.892213] ehci-pci 0000:02:03.0: USB 2.0 started, EHCI 1.00
[    1.892342] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.892345] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.892347] usb usb1: Product: EHCI Host Controller
[    1.892349] usb usb1: Manufacturer: Linux 3.13.0-rc2+ ehci_hcd
[    1.892350] usb usb1: SerialNumber: 0000:02:03.0
[    1.892596] hub 1-0:1.0: USB hub found
[    1.892646] hub 1-0:1.0: 6 ports detected
[    1.892809] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.892812] ohci-pci: OHCI PCI platform driver
[    1.892831] uhci_hcd: USB Universal Host Controller Interface driver
[    1.893194] uhci_hcd 0000:02:00.0: UHCI Host Controller
[    1.893314] uhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
[    1.893358] uhci_hcd 0000:02:00.0: irq 18, io base 0x000020c0
[    1.893445] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.893447] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.893449] usb usb2: Product: UHCI Host Controller
[    1.893451] usb usb2: Manufacturer: Linux 3.13.0-rc2+ uhci_hcd
[    1.893453] usb usb2: SerialNumber: 0000:02:00.0
[    1.893629] hub 2-0:1.0: USB hub found
[    1.893670] hub 2-0:1.0: 2 ports detected
[    1.893785] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
[    1.894129] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.894134] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.894357] mousedev: PS/2 mouse device common for all mice
[    1.915199] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.915262] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.916233] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.916515] device-mapper: uevent: version 1.0.3
[    1.916618] kobject: 'input2' (f6cc3a14): kobject_release, parent   (null) (delayed)
[    1.916728] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    1.918355] hidraw: raw HID events driver (C) Jiri Kosina
[    1.918398] usbcore: registered new interface driver usbhid
[    1.918400] usbhid: USB HID core driver
[    2.048342] ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max UDMA/33
[    2.048940] ata2.00: configured for UDMA/33
[    2.050604] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
[    2.051145] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.051149] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.051352] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.051524] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    2.121522] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    2.195342] usb 2-1: new full-speed USB device number 2 using uhci_hcd
[    2.736823] drop_monitor: Initializing network drop monitor service
[    2.736982] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.738987] TCP: cubic registered
[    2.738991] Initializing XFRM netlink socket
[    2.739025] NET: Registered protocol family 10
[    2.739058] mip6: Mobile IPv6
[    2.739072] NET: Registered protocol family 17
[    2.739106] Key type dns_resolver registered
[    2.739281] Using IPI No-Shortcut mode
[    2.739751] Loading compiled-in X.509 certificates
[    2.741960] Loaded X.509 cert 'Magrathea: Glacier signing key: 37853588187d92995ae631c6537391d553565fd8'
[    2.741993] registered taskstats version 1
[    2.754374]   Magic number: 9:608:463
[    2.754553] rtc_cmos 00:03: setting system clock to 2013-12-03 04:27:20 UTC (1386044840)
[    2.754587] PM: Hibernation image not present or could not be loaded.
[    2.754612] ALSA device list:
[    2.754615]   #0: Ensoniq AudioPCI ENS1371 at 0x2080, irq 16
[    2.755213] Freeing unused kernel memory: 820K (c0ebe000 - c0f8b000)
[    2.755583] Write protecting the kernel text: 7248k
[    2.755797] Write protecting the kernel read-only data: 3048k
[    2.755801] NX-protecting the kernel data: 5040k
[    2.759970] systemd[1]: systemd 204 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    2.760004] systemd[1]: Detected virtualization 'vmware'.
[    2.760020] systemd[1]: Running in initial RAM disk.
[    2.760053] systemd[1]: Set hostname to <localhost.localdomain>.
[    2.761023] random: systemd urandom read with 5 bits of entropy available
[    2.763233] systemd[1]: Expecting device dev-disk-by\x2duuid-4792463a\x2da5f2\x2d481e\x2db975\x2d9e8cc0148332.device...
[    2.763255] systemd[1]: Expecting device dev-disk-by\x2duuid-f8e06d20\x2dea72\x2d4a1e\x2d8c25\x2dde384b51a5c4.device...
[    2.763271] systemd[1]: Expecting device dev-disk-by\x2duuid-ca6fb71d\x2d3bd8\x2d4a84\x2dbc0a\x2dc89e72cc44c3.device...
[    2.763286] systemd[1]: Starting Timers.
[    2.763302] systemd[1]: Reached target Timers.
[    2.763345] systemd[1]: Starting udev Kernel Socket.
[    2.763404] systemd[1]: Listening on udev Kernel Socket.
[    2.763444] systemd[1]: Starting udev Control Socket.
[    2.763504] systemd[1]: Listening on udev Control Socket.
[    2.763519] systemd[1]: Starting Journal Socket.
[    2.763597] systemd[1]: Listening on Journal Socket.
[    2.763640] systemd[1]: Started dracut cmdline hook.
[    2.763916] systemd[1]: Starting dracut pre-udev hook...
[    2.764296] systemd[1]: Started Load Kernel Modules.
[    2.764331] systemd[1]: Starting Sockets.
[    2.764351] systemd[1]: Reached target Sockets.
[    2.764364] systemd[1]: Starting Journal Service...
[    2.765273] systemd[1]: Started Journal Service.
[    2.765680] systemd[1]: Starting Setup Virtual Console...
[    2.766092] systemd[1]: Starting Swap.
[    2.766152] systemd[1]: Reached target Swap.
[    2.766166] systemd[1]: Starting Local File Systems.
[    2.766182] systemd[1]: Reached target Local File Systems.
[    2.770895] systemd-journald[116]: Vacuuming done, freed 0 bytes
[    2.786544] systemd-udevd[138]: starting version 204
[    2.893318] Fusion MPT base driver 3.04.20
[    2.893334] Copyright (c) 1999-2008 LSI Corporation
[    2.904947] [drm] Initialized drm 1.1.0 20060810
[    2.905653] usb 2-1: New USB device found, idVendor=0e0f, idProduct=0003
[    2.905657] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.905661] usb 2-1: Product: VMware Virtual USB Mouse
[    2.905664] usb 2-1: Manufacturer: VMware
[    2.908200] Fusion MPT SPI Host driver 3.04.20
[    2.909856] mptbase: ioc0: Initiating bringup
[    2.915751] input: VMware VMware Virtual USB Mouse as /devices/pci0000:00/0000:00:11.0/0000:02:00.0/usb2/2-1/2-1:1.0/input/input4
[    2.917569] hid-generic 0003:0E0F:0003.0001: input,hidraw0: USB HID v1.10 Mouse [VMware VMware Virtual USB Mouse] on usb-0000:02:00.0-1/input0
[    2.933317] ioc0: LSI53C1030 B0: Capabilities={Initiator}
[    2.979082] scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
[    3.007981] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[    3.008078] scsi target2:0:0: Beginning Domain Validation
[    3.008454] [drm] DMA map mode: Using physical TTM page addresses.
[    3.008548] [drm] Capabilities:
[    3.008550] [drm]   Rect copy.
[    3.008551] [drm]   Cursor.
[    3.008552] [drm]   Cursor bypass.
[    3.008553] [drm]   Cursor bypass 2.
[    3.008555] [drm]   8bit emulation.
[    3.008556] [drm]   Alpha cursor.
[    3.008557] [drm]   3D.
[    3.008558] [drm]   Extended Fifo.
[    3.008559] [drm]   Multimon.
[    3.008560] [drm]   Pitchlock.
[    3.008562] [drm]   Irq mask.
[    3.008563] [drm]   Display Topology.
[    3.008564] [drm]   GMR.
[    3.008565] [drm]   Traces.
[    3.008566] [drm]   GMR2.
[    3.008567] [drm]   Screen Object 2.
[    3.008569] [drm] Max GMR ids is 64
[    3.008570] [drm] Max GMR descriptors is 4096
[    3.008571] [drm] Max number of GMR pages is 196608
[    3.008572] [drm] Max dedicated hypervisor surface memory is 786432 kiB
[    3.008574] [drm] VRAM at 0xe8000000 size is 131072 kiB
[    3.008575] [drm] MMIO at 0xfe000000 size is 2048 kiB
[    3.008613] [drm] global init.
[    3.008999] [TTM] Zone  kernel: Available graphics memory: 418192 kiB
[    3.009002] [TTM] Zone highmem: Available graphics memory: 2061684 kiB
[    3.009003] [TTM] Initializing pool allocator
[    3.009016] [TTM] Initializing DMA pool allocator
[    3.009501] scsi target2:0:0: Domain Validation skipping write tests
[    3.009504] scsi target2:0:0: Ending Domain Validation
[    3.009539] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.009556] [drm] No driver support for vblank timestamp query.
[    3.009561] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
[    3.009773] kobject: '2:0:0:1' (f2609398): kobject_release, parent   (null) (delayed)
[    3.009773] [drm] Screen objects system initialized
[    3.009825] [drm] width 1280
[    3.009825] [drm] height 768
[    3.009826] [drm] bpp 32
[    3.009826] kobject: '2:0:1:0' (f260a398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:2:0' (f260b398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:3:0' (f260c398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:4:0' (f260d398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:5:0' (f260e398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:6:0' (f260f398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:8:0' (f2648398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:9:0' (f2649398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:10:0' (f264a398): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:11:0' (f264bb98): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:12:0' (f264cb98): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:13:0' (f264db98): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:14:0' (f264eb98): kobject_release, parent   (null) (delayed)
[    3.009827] kobject: '2:0:15:0' (f264fb98): kobject_release, parent   (null) (delayed)
[    3.009827] sd 2:0:0:0: [sda] 335544320 512-byte logical blocks: (171 GB/160 GiB)
[    3.009827] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    3.009827] sd 2:0:0:0: [sda] Write Protect is off
[    3.009827] sd 2:0:0:0: [sda] Mode Sense: 61 00 00 00
[    3.009827] sd 2:0:0:0: [sda] Cache data unavailable
[    3.009827] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    3.009827] sd 2:0:0:0: [sda] Cache data unavailable
[    3.009827] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    3.010113] [drm] Fifo max 0x00200000 min 0x00001000 cap 0x0000077f
[    3.017571] fbcon: svgadrmfb (fb0) is primary device
[    3.020202] usb 2-2: new full-speed USB device number 3 using uhci_hcd
[    3.024962]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    3.026409] sd 2:0:0:0: [sda] Cache data unavailable
[    3.026412] sd 2:0:0:0: [sda] Assuming drive cache: write through
[    3.026479] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.041065] Console: switching to colour frame buffer device 160x48
[    3.041861] [drm] Initialized vmwgfx 2.4.0 20120209 for 0000:00:0f.0 on minor 0
[    3.139919] usb 2-2: New USB device found, idVendor=0e0f, idProduct=0002
[    3.139924] usb 2-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.139927] usb 2-2: Product: VMware Virtual USB Hub
[    3.144016] hub 2-2:1.0: USB hub found
[    3.144924] hub 2-2:1.0: 7 ports detected
[    3.361911] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.487831] systemd-journald[116]: Received SIGTERM
[    3.530509] random: nonblocking pool is initialized
[    4.010870] kobject: '2:0:0:1' (f26090f8): kobject_release, parent   (null) (delayed)
[    4.010939] kobject: '2:0:1:0' (f260a0f8): kobject_release, parent   (null) (delayed)
[    4.010949] kobject: '2:0:2:0' (f260b0f8): kobject_release, parent   (null) (delayed)
[    4.010957] kobject: '2:0:3:0' (f260c0f8): kobject_release, parent   (null) (delayed)
[    4.010964] kobject: '2:0:4:0' (f260d0f8): kobject_release, parent   (null) (delayed)
[    4.010971] kobject: '2:0:5:0' (f260e0f8): kobject_release, parent   (null) (delayed)
[    4.010978] kobject: '2:0:6:0' (f260f0f8): kobject_release, parent   (null) (delayed)
[    4.010985] kobject: '2:0:8:0' (f26480f8): kobject_release, parent   (null) (delayed)
[    4.010992] kobject: '2:0:9:0' (f26490f8): kobject_release, parent   (null) (delayed)
[    4.010999] kobject: '2:0:10:0' (f264a0f8): kobject_release, parent   (null) (delayed)
[    4.011006] kobject: '2:0:11:0' (f264b8f8): kobject_release, parent   (null) (delayed)
[    4.011013] kobject: '2:0:12:0' (f264c8f8): kobject_release, parent   (null) (delayed)
[    4.011020] kobject: '2:0:13:0' (f264d8f8): kobject_release, parent   (null) (delayed)
[    4.011027] kobject: '2:0:14:0' (f264e8f8): kobject_release, parent   (null) (delayed)
[    4.011034] kobject: '2:0:15:0' (f264f8f8): kobject_release, parent   (null) (delayed)
[    4.317821] LVM: Logical Volume autoactivation enabled.
[    4.317833] LVM: Activation generator successfully completed.
[    5.012502] kobject: '(null)' (f2610c40): kobject_release, parent   (null) (delayed)
[    5.012528] kobject: '(null)' (f2611470): kobject_release, parent   (null) (delayed)
[    5.012575] kobject: 'target2:0:1' (f35cd41c): kobject_release, parent   (null) (delayed)
[    5.012640] kobject: '(null)' (f2611ca0): kobject_release, parent   (null) (delayed)
[    5.012652] kobject: 'target2:0:2' (f35cdc1c): kobject_release, parent   (null) (delayed)
[    5.012671] kobject: '(null)' (f26124d0): kobject_release, parent   (null) (delayed)
[    5.012680] kobject: 'target2:0:3' (f35ce41c): kobject_release, parent   (null) (delayed)
[    5.012698] kobject: '(null)' (f2612d00): kobject_release, parent   (null) (delayed)
[    5.012706] kobject: 'target2:0:4' (f35cec1c): kobject_release, parent   (null) (delayed)
[    5.012724] kobject: '(null)' (f2613530): kobject_release, parent   (null) (delayed)
[    5.012732] kobject: 'target2:0:5' (f35cf41c): kobject_release, parent   (null) (delayed)
[    5.012749] kobject: '(null)' (f2613d60): kobject_release, parent   (null) (delayed)
[    5.012757] kobject: 'target2:0:6' (f35cfc1c): kobject_release, parent   (null) (delayed)
[    5.012773] kobject: '(null)' (f2614590): kobject_release, parent   (null) (delayed)
[    5.012781] kobject: 'target2:0:8' (f35c8c1c): kobject_release, parent   (null) (delayed)
[    5.012797] kobject: '(null)' (f2614dc0): kobject_release, parent   (null) (delayed)
[    5.012805] kobject: 'target2:0:9' (f265041c): kobject_release, parent   (null) (delayed)
[    5.012821] kobject: '(null)' (f26155f0): kobject_release, parent   (null) (delayed)
[    5.012829] kobject: 'target2:0:10' (f2650c1c): kobject_release, parent   (null) (delayed)
[    5.012845] kobject: '(null)' (f2615e20): kobject_release, parent   (null) (delayed)
[    5.012853] kobject: 'target2:0:11' (f265141c): kobject_release, parent   (null) (delayed)
[    5.012868] kobject: '(null)' (f2616650): kobject_release, parent   (null) (delayed)
[    5.012875] kobject: 'target2:0:12' (f2651c1c): kobject_release, parent   (null) (delayed)
[    5.012891] kobject: '(null)' (f2616e80): kobject_release, parent   (null) (delayed)
[    5.012898] kobject: 'target2:0:13' (f265241c): kobject_release, parent   (null) (delayed)
[    5.012913] kobject: '(null)' (f26176b0): kobject_release, parent   (null) (delayed)
[    5.012920] kobject: 'target2:0:14' (f2652c1c): kobject_release, parent   (null) (delayed)
[    5.012935] kobject: '(null)' (f2658410): kobject_release, parent   (null) (delayed)
[    5.012943] kobject: 'target2:0:15' (f265341c): kobject_release, parent   (null) (delayed)
[    6.014173] kobject: '(null)' (f36b4408): kobject_release, parent   (null) (delayed)
[    6.014236] kobject: '(null)' (f36b4a08): kobject_release, parent   (null) (delayed)
[    6.014251] kobject: 'target2:0:1' (f35cd01c): kobject_release, parent   (null) (delayed)
[    6.014264] kobject: '(null)' (f36b5208): kobject_release, parent   (null) (delayed)
[    6.014276] kobject: 'target2:0:2' (f35cd81c): kobject_release, parent   (null) (delayed)
[    6.014289] kobject: '(null)' (f36b5608): kobject_release, parent   (null) (delayed)
[    6.014301] kobject: 'target2:0:3' (f35ce01c): kobject_release, parent   (null) (delayed)
[    6.014313] kobject: '(null)' (f36b5e08): kobject_release, parent   (null) (delayed)
[    6.014325] kobject: 'target2:0:4' (f35ce81c): kobject_release, parent   (null) (delayed)
[    6.014337] kobject: '(null)' (f36b6408): kobject_release, parent   (null) (delayed)
[    6.014349] kobject: 'target2:0:5' (f35cf01c): kobject_release, parent   (null) (delayed)
[    6.014361] kobject: '(null)' (f36b6a08): kobject_release, parent   (null) (delayed)
[    6.014373] kobject: 'target2:0:6' (f35cf81c): kobject_release, parent   (null) (delayed)
[    6.014385] kobject: '(null)' (f36b7008): kobject_release, parent   (null) (delayed)
[    6.014397] kobject: 'target2:0:8' (f35c881c): kobject_release, parent   (null) (delayed)
[    6.014408] kobject: '(null)' (f36b7c08): kobject_release, parent   (null) (delayed)
[    6.014420] kobject: 'target2:0:9' (f265001c): kobject_release, parent   (null) (delayed)
[    6.014433] kobject: '(null)' (f253fc08): kobject_release, parent   (null) (delayed)
[    6.014444] kobject: 'target2:0:10' (f265081c): kobject_release, parent   (null) (delayed)
[    6.014456] kobject: '(null)' (f253f608): kobject_release, parent   (null) (delayed)
[    6.014468] kobject: 'target2:0:11' (f265101c): kobject_release, parent   (null) (delayed)
[    6.014480] kobject: '(null)' (f253f008): kobject_release, parent   (null) (delayed)
[    6.014491] kobject: 'target2:0:12' (f265181c): kobject_release, parent   (null) (delayed)
[    6.014503] kobject: '(null)' (f253ea08): kobject_release, parent   (null) (delayed)
[    6.014515] kobject: 'target2:0:13' (f265201c): kobject_release, parent   (null) (delayed)
[    6.014526] kobject: '(null)' (f253e408): kobject_release, parent   (null) (delayed)
[    6.014548] kobject: 'target2:0:14' (f265281c): kobject_release, parent   (null) (delayed)
[    6.014561] kobject: '(null)' (f253dc08): kobject_release, parent   (null) (delayed)
[    6.014574] kobject: 'target2:0:15' (f265301c): kobject_release, parent   (null) (delayed)
[    6.121055] systemd-journald[244]: Vacuuming done, freed 0 bytes
[    6.431223] systemd-udevd[262]: starting version 204
[    6.448081] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.331906] vmw_vmci 0000:00:07.7: Found VMCI PCI device at 0x11080, irq 16
[    9.332050] vmw_vmci 0000:00:07.7: Using capabilities 0xc
[    9.340235] vmw_vmci 0000:00:07.7: irq 72 for MSI/MSI-X
[    9.340306] vmw_vmci 0000:00:07.7: irq 73 for MSI/MSI-X
[    9.340663] microcode: CPU0 sig=0x306a9, pf=0x1, revision=0x17
[    9.340740] Guest personality initialized and is active
[    9.340784] piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
[    9.440462] VMCI host device registered (name=vmci, major=10, minor=59)
[    9.440466] Initialized host personality
[   12.289555] microcode: CPU1 sig=0x306a9, pf=0x1, revision=0x17
[   12.289883] microcode: CPU2 sig=0x306a9, pf=0x1, revision=0x17
[   12.290161] microcode: CPU3 sig=0x306a9, pf=0x1, revision=0x17
[   12.290437] microcode: CPU4 sig=0x306a9, pf=0x1, revision=0x17
[   12.290702] microcode: CPU5 sig=0x306a9, pf=0x1, revision=0x17
[   12.290882] microcode: CPU6 sig=0x306a9, pf=0x1, revision=0x17
[   12.291308] microcode: CPU7 sig=0x306a9, pf=0x1, revision=0x17
[   12.292442] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   13.632624] alg: No test for crc32 (crc32-pclmul)
[   15.993774] systemd-udevd[274]: renamed network interface eth0 to eno16777736
[   16.740512] Adding 4095996k swap on /dev/sda3.  Priority:-1 extents:1 across:4095996k FS
[   17.692702] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   18.180699] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   18.787477] systemd-journald[244]: Received request to flush runtime journal from PID 1
[   19.339976] systemd[1]: Socket service avahi-daemon.service not loaded, refusing.
[   22.517071] type=1305 audit(1386044860.266:2): audit_pid=328 old=0 auid=4294967295 ses=4294967295 res=1
[   33.251006] systemd-logind[360]: Watching system buttons on /dev/input/event0 (Power Button)
[   38.657904] sda2: WRITE SAME failed. Manually zeroing.
[   47.237000] pcnet32 0000:02:01.0 eno16777736: link up
[   54.136956] Bluetooth: Core ver 2.17
[   54.137125] NET: Registered protocol family 31
[   54.137128] Bluetooth: HCI device and connection manager initialized
[   54.137197] Bluetooth: HCI socket layer initialized
[   54.137200] Bluetooth: L2CAP socket layer initialized
[   54.137209] Bluetooth: SCO socket layer initialized
[   54.287248] NFSD: starting 90-second grace period (net c0e96200)
[   55.873070] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   55.873073] Bluetooth: BNEP filters: protocol multicast
[   55.874422] Bluetooth: BNEP socket layer initialized
[   78.443157] Ebtables v2.0 registered
[   78.812814] ip6_tables: (C) 2000-2006 Netfilter Core Team
[10586.641763] perf samples too long (1066934 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[10586.642000] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 165.770 msecs
[10587.273883] [sched_delayed] sched: RT throttling activated
[10676.579775] perf samples too long (1058744 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[10684.646290] perf samples too long (1050570 > 10000), lowering kernel.perf_event_max_sample_rate to 13000
[10692.717781] perf samples too long (1042462 > 19230), lowering kernel.perf_event_max_sample_rate to 7000
[10700.765025] perf samples too long (1034420 > 35714), lowering kernel.perf_event_max_sample_rate to 4000
[10708.870513] perf samples too long (1026441 > 62500), lowering kernel.perf_event_max_sample_rate to 2000
[10716.915204] perf samples too long (1018527 > 125000), lowering kernel.perf_event_max_sample_rate to 1000
[13125.554344] CIFS VFS: Server 10.89.16.209 has not responded in 120 seconds. Reconnecting...
[13162.605685] mptscsih: ioc0: attempting task abort! (sc=e5fc8cc0)
[13162.605719] sd 2:0:0:0: [sda] CDB: 
[13162.605724] Write(10): 2a 00 02 13 e7 c8 00 00 08 00
[13164.668850] BUG: soft lockup - CPU#3 stuck for 24s! [swapper/3:0]
[13164.668855] BUG: soft lockup - CPU#7 stuck for 36s! [ksoftirqd/7:43]
[13164.668860] Modules linked in: nls_utf8 ip6table_filter ip6_tables ebtable_nat
[13164.668867] Modules linked in:
[13164.668868]  nls_utf8
[13164.668869]  ip6table_filter
[13164.668870]  ip6_tables
[13164.668871]  ebtable_nat
[13164.668872]  ebtables
[13164.668873]  ebtables
[13164.668875]  bnep
[13164.668875]  bnep
[13164.668877]  bluetooth
[13164.668878]  bluetooth
[13164.668879]  crc32_pclmul
[13164.668880]  crc32_pclmul
[13164.668881]  crc32c_intel
[13164.668882]  crc32c_intel
[13164.668883]  vmw_balloon
[13164.668884]  vmw_balloon
[13164.668885]  i2c_piix4
[13164.668886]  i2c_piix4
[13164.668887]  microcode
[13164.668887]  microcode
[13164.668888]  vmw_vmci
[13164.668889]  vmw_vmci
[13164.668890]  uinput
[13164.668891]  uinput
[13164.668892]  vmwgfx
[13164.668893]  vmwgfx
[13164.668893]  mptspi
[13164.668894]  mptspi
[13164.668895]  ttm
[13164.668896]  ttm
[13164.668897]  scsi_transport_spi
[13164.668898]  scsi_transport_spi
[13164.668899]  drm
[13164.668900]  drm
[13164.668901]  mptscsih
[13164.668903]  mptscsih
[13164.668904]  mptbase
[13164.668906]  mptbase
[13164.668907]  i2c_core
[13164.668909]  i2c_core
[13164.668912] irq event stamp: 1636953
[13164.668913] irq event stamp: 254417
[13164.668934] hardirqs last  enabled at (254416): 
[13164.668936] hardirqs last  enabled at (1636952): 
[13164.668941] [<c0b0ae60>] restore_all_notrace+0x0/0x18
[13164.668945] [<c0b0ae60>] restore_all_notrace+0x0/0x18
[13164.668942] hardirqs last disabled at (254417): [<c0b0b2ae>] apic_timer_interrupt+0x32/0x40
[13164.668949] hardirqs last disabled at (1636953): 
[13164.668950] softirqs last  enabled at (254218): 
[13179.122235] [<c045c906>] __do_softirq+0x156/0x260
[13179.122242] softirqs last disabled at (254221): [<c045ca4d>] run_ksoftirqd+0x3d/0x70
[13179.124310] CPU: 7 PID: 43 Comm: ksoftirqd/7 Not tainted 3.13.0-rc2+ #48
[13179.124323] ------------[ cut here ]------------
[13179.124348] WARNING: CPU: 3 PID: 0 at kernel/watchdog.c:245 watchdog_overflow_callback+0xac/0xd0()
[13179.124352] Watchdog detected hard LOCKUP on cpu 3
[13179.124359] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13179.124365] task: f3668000 ti: f365e000 task.ti: f365e000
[13179.124370] EIP: 0060:[<c0b0a373>] EFLAGS: 00000282 CPU: 7
[13179.124352] Modules linked in: nls_utf8 ip6table_filter ip6_tables ebtable_nat ebtables bnep bluetooth crc32_pclmul crc32c_intel vmw_balloon i2c_piix4 microcode vmw_vmci uinput vmwgfx mptspi ttm scsi_transport_spi drm mptscsih mptbase i2c_core
[13179.126099] EIP is at _raw_spin_unlock_irqrestore+0x33/0x60
[13179.126103] EAX: 00000282 EBX: 00000282 ECX: 00000000 EDX: 00000000
[13179.126104] ESI: f34346f0 EDI: f3434748 EBP: f365fe38 ESP: f365fe30
[13179.126105]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13179.126106] CR0: 80050033 CR2: b7712000 CR3: 31f25000 CR4: 001407f0
[13179.126156] Stack:
[13179.126159]  00000282 c0bbec34 f365fe90 c08c272e 00000282 c159edb4 00000000 f1f5c900
[13179.126164]  00000002 00000282 f3434748 00002000 f34346f0 00000000 f365fe88 00000010
[13179.126167]  00000036 00000028 00000000 00003036 00003036 0000012c f3434748 00000000
[13179.126171] Call Trace:
[13191.957579]  [<c08c272e>] pcnet32_poll+0x66e/0x7b0
[13194.132312]  [<c09ec1f0>] net_rx_action+0xb0/0x1b0
[13194.132317] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc2+ #48
[13194.132320] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13194.132322]  00000000 00000000 f35c7a64 c0b02432 f35c7aa4

[13194.132330]  f35c7a94 c045798e c0d2454c
[13194.132351]  [<c045c888>] __do_softirq+0xd8/0x260
[13194.132353]  f35c7ac0 00000000 c0d2f544

[13194.132362]  [<c0b0a36f>] ? _raw_spin_unlock_irqrestore+0x2f/0x60
[13194.132356]  000000f5 c04f2f2c c04f2f2c f35c8000 c04f2e80


[13194.132369]  [<c045ca5a>] ? run_ksoftirqd+0x4a/0x70
[13194.132365]  00000000 f35c7aac c04579e3 00000009 f35c7aa4 c0d2454c f35c7ac0

[13194.132374]  f35c7ac4
[13194.132376]  [<c045ca4d>] run_ksoftirqd+0x3d/0x70
[13194.132376] Call Trace:
[13194.132385]  [<c0b02432>] dump_stack+0x48/0x60
[13194.966152]  [<c047e939>] smpboot_thread_fn+0xf9/0x190
[13194.966206] INFO: rcu_sched detected stalls on CPUs/tasks:
[13194.966403]  [<c045798e>] warn_slowpath_common+0x7e/0xa0
[13194.966407]  {
[13194.966412]  [<c04f2f2c>] ? watchdog_overflow_callback+0xac/0xd0
[13194.966417]  [<c04f2f2c>] ? watchdog_overflow_callback+0xac/0xd0
[13194.966418]  0
[13194.966421]  [<c04f2e80>] ? restart_watchdog_hrtimer+0x50/0x50
[13194.966425]  [<c04579e3>] warn_slowpath_fmt+0x33/0x40
[13194.966427]  [<c04f2f2c>] watchdog_overflow_callback+0xac/0xd0
[13194.966429]  5

[13194.966434]  [<c047e840>] ? SyS_setgroups+0x100/0x100


[13194.966437]  [<c0521cad>] __perf_event_overflow+0xad/0x2e0
[13194.966440]  [<c047743c>] kthread+0xac/0xc0


[13194.966444]  [<c0522515>] perf_event_overflow+0x15/0x20
[13195.696917]  [<c0b122f7>] ret_from_kernel_thread+0x1b/0x28

[13195.696927]  [<c0477390>] ? kthread_create_on_node+0x170/0x170
[13195.696929] Code:
[13195.696931]  26
[13195.696932]  00
[13195.696934]  8b 4d
[13195.696935]  7
[13195.696937]  04 89 c6 89
[13195.696938] } 
[13195.696941] (detected by 6, t=69426 jiffies, g=60887, c=60886, q=1606)
[13195.696940]  d3 8d 40 10 ba 01 00 00 00 e8 e2 7d 99 ff 89 f0 e8 8b a8 99 ff f6 c7 02 74 1e e8 a1 53 99 ff 89 d8 50 9d <8d> 74 26 00 64 ff 0d 30 31 f8 c0 5b 5e 5d c3 8d b6 00 00 00 00
[13195.696987] sending NMI to all CPUs:
[13195.697006] NMI backtrace for cpu 6
[13195.697009] CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.13.0-rc2+ #48
[13195.697011] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13195.697012] task: f3529220 ti: f3524000 task.ti: f3524000
[13195.697014] EIP: 0060:[<c043f58d>] EFLAGS: 00200046 CPU: 6
[13195.697020] EIP is at default_send_IPI_mask_logical+0x8d/0xf0
[13195.697022] EAX: 00000c00 EBX: ff000000 ECX: fffff000 EDX: fffff000
[13195.697023] ESI: 00200006 EDI: 00000002 EBP: f3525db8 ESP: f3525da8
[13195.697024]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13195.697025] CR0: 80050033 CR2: b7784000 CR3: 31abb000 CR4: 001407f0
[13195.697074] Stack:
[13195.697076]  00000800 00002710 c0e36580 f75aca00 f3525dc4 c043f6c0 00002710 f3525dd4
[13195.697081]  c043f822 c0d12a1d c0e36580 f3525e1c c04ba15b c0d213b0 00000006 00010f32
[13195.697084]  0000edd7 0000edd6 00000646 00000007 c0e36580 f75aca00 c0eb8a4c 00000646
[13195.697088] Call Trace:
[13195.697091]  [<c043f6c0>] default_send_IPI_all+0x60/0x70
[13195.697093]  [<c043f822>] arch_trigger_all_cpu_backtrace+0x42/0x70
[13195.697098]  [<c04ba15b>] rcu_check_callbacks+0x58b/0x5b0
[13195.697100]  [<c0464b1c>] update_process_times+0x3c/0x60
[13195.697134]  [<c04c5256>] tick_sched_handle.isra.14+0x26/0x60
[13195.697137]  [<c04c5457>] tick_sched_timer+0x37/0x70
[13195.697139]  [<c047a5eb>] __run_hrtimer+0x7b/0x1d0
[13195.697141]  [<c04c5420>] ? tick_sched_do_timer+0x30/0x30
[13195.697143]  [<c047b295>] hrtimer_interrupt+0x1f5/0x2b0
[13195.697147]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13195.697149]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13195.697151]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13195.697155]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13195.697159]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13195.697184]  [<c0418b81>] default_idle+0x21/0xc0
[13195.697188]  [<c0419356>] arch_cpu_idle+0x36/0x40
[13195.697192]  [<c04b1de2>] cpu_startup_entry+0x1f2/0x250
[13195.697195]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13195.697197]  [<c043b8ad>] start_secondary+0x21d/0x2e0
[13195.697198] Code: 00 c3 ff ff f6 c4 10 75 ed c1 e3 18 89 99 10 c3 ff ff 89 f8 09 d0 80 ce 04 83 ff 02 0f 44 c2 8b 15 a4 90 e2 c0 89 82 00 c3 ff ff <f7> c6 00 02 00 00 74 1b e8 76 01 06 00 89 f0 50 9d 8d 74 26 00
[13195.697221] NMI backtrace for cpu 7
[13195.697224] CPU: 7 PID: 43 Comm: ksoftirqd/7 Not tainted 3.13.0-rc2+ #48
[13195.697226] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13195.697227] task: f3668000 ti: f365e000 task.ti: f365e000
[13195.697229] EIP: 0060:[<c0442912>] EFLAGS: 00000002 CPU: 7
[13195.697232] EIP is at native_apic_mem_write+0x12/0x20
[13195.697233] EAX: ffffb380 EBX: f75bb240 ECX: fffff000 EDX: 0000055a
[13195.697234] ESI: 0005112c EDI: 0005112c EBP: f365fd40 ESP: f365fd40
[13195.697235]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13195.697236] CR0: 80050033 CR2: b7712000 CR3: 31f25000 CR4: 001407f0
[13195.697271] Stack:
[13195.697272]  f365fd48 c043cf6b f365fd60 c04c3685 00000000 f75bb240 3e328980 7ffff3fe
[13195.697276]  f365fd70 c04c4db9 00000000 f75bb480 f365fdcc c047b1e2 0000017c 00000000
[13195.697280]  780432d5 f5d325ca 00000bf9 f75bb584 f75bb554 f75bb524 00000002 c9728d51
[13195.697283] Call Trace:
[13195.697286]  [<c043cf6b>] lapic_next_event+0x1b/0x20
[13195.697289]  [<c04c3685>] clockevents_program_event+0x95/0x130
[13195.697291]  [<c04c4db9>] tick_program_event+0x29/0x30
[13195.697293]  [<c047b1e2>] hrtimer_interrupt+0x142/0x2b0
[13195.697296]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13195.697298]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13195.697300]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13195.697303]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13195.697306]  [<c0b0a373>] ? _raw_spin_unlock_irqrestore+0x33/0x60
[13195.697309]  [<c08c272e>] pcnet32_poll+0x66e/0x7b0
[13195.697313]  [<c09ec1f0>] net_rx_action+0xb0/0x1b0
[13195.697315]  [<c045c888>] __do_softirq+0xd8/0x260
[13195.697317]  [<c0b0a36f>] ? _raw_spin_unlock_irqrestore+0x2f/0x60
[13195.697319]  [<c045ca5a>] ? run_ksoftirqd+0x4a/0x70
[13195.697321]  [<c045ca4d>] run_ksoftirqd+0x3d/0x70
[13195.697323]  [<c047e939>] smpboot_thread_fn+0xf9/0x190
[13195.697326]  [<c047e840>] ? SyS_setgroups+0x100/0x100
[13195.697328]  [<c047743c>] kthread+0xac/0xc0
[13195.697331]  [<c0b122f7>] ret_from_kernel_thread+0x1b/0x28
[13195.697333]  [<c0477390>] ? kthread_create_on_node+0x170/0x170
[13195.697334] Code: 00 31 c0 83 c1 02 66 89 41 fe 83 eb 02 eb a5 66 90 66 90 66 90 66 90 66 90 8b 0d a4 90 e2 c0 55 89 e5 8d 84 08 00 c0 ff ff 89 10 <5d> c3 8d b6 00 00 00 00 8d bf 00 00 00 00 8b 15 a4 90 e2 c0 55
[13195.697358] NMI backtrace for cpu 1
[13195.697362] CPU: 1 PID: 393 Comm: rs:main Q:Reg Not tainted 3.13.0-rc2+ #48
[13195.697364] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13195.697366] task: f1830000 ti: f2510000 task.ti: f2510000
[13195.697368] EIP: 0060:[<c0599f82>] EFLAGS: 00010246 CPU: 1
[13195.697374] EIP is at __fd_install+0x32/0x50
[13195.697376] EAX: f191f000 EBX: f2544200 ECX: f6fcaf00 EDX: f191f000
[13195.697378] ESI: 00000008 EDI: f2544240 EBP: f2511f54 ESP: f2511f44
[13195.697380]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13195.697382] CR0: 80050033 CR2: b7564770 CR3: 32d1d000 CR4: 001407f0
[13195.697424] Stack:
[13195.697426]  f6fcaf00 00000008 00000008 f6fcaf00 f2511f60 c0599fc0 f3564000 f2511fa0
[13195.697433]  c057d95c 00000001 00000000 00000000 00000020 f2eb2ccc f6fcaf08 00008000
[13196.049452]  [<c0429ea4>] intel_pmu_handle_irq+0x1f4/0x420
[13196.049455]  00000000 00000024

[13196.116841]  [<c077412f>] ? string.isra.6+0x2f/0xc0
[13196.049461]  00000100

[13196.116853]  [<c07745be>] ? symbol_string.isra.11+0x5e/0xb0
[13196.116858]  [<c0b0ca5c>] perf_event_nmi_handler+0x2c/0x50
[13196.116861]  [<c0b0c0cf>] nmi_handle.isra.2+0x8f/0x200
[13196.116864]  [<c0b0c040>] ? __die+0x110/0x110
[13196.116867]  [<c0b0c345>] do_nmi+0x105/0x410
[13196.116870]  [<c0b0b78f>] nmi_stack_correct+0x2f/0x34
[13196.116873]  [<c07760c3>] ? delay_tsc+0x53/0x90
[13196.116876]  [<c0775fee>] __delay+0xe/0x10
[13196.116885]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.116889]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.116892]  [<c04b0441>] ? vprintk_emit+0x101/0x5c0
[13196.116895]  [<c04b0441>] vprintk_emit+0x101/0x5c0
[13196.116898]  [<c0aff2e5>] printk+0x50/0x52
[13196.116902]  [<c049f0ef>] print_irqtrace_events+0x7f/0xf0
[13196.116904]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.116907]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.116910]  [<c04f2b3a>] watchdog_timer_fn+0x11a/0x170
[13196.116913]  [<c047a5eb>] __run_hrtimer+0x7b/0x1d0
[13196.116916]  [<c04f2a20>] ? watchdog_cleanup+0x10/0x10
[13196.116919]  [<c047b295>] hrtimer_interrupt+0x1f5/0x2b0
[13196.116923]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13196.116927]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13196.116930]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13196.116933]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13196.116936]  [<c077607b>] ? delay_tsc+0xb/0x90
[13196.116939]  [<c0775fee>] __delay+0xe/0x10
[13196.116942]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.116945]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.116949]  [<c0a071bb>] ? dev_watchdog+0x5b/0x240
[13196.116951]  [<c0a071bb>] dev_watchdog+0x5b/0x240
[13196.116954]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.116957]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.116960]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.116963]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.116965]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.116968]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.116970]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.116973]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.116976]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.116977]  <IRQ>  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.116983]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.116986]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.116989]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.116992]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.116995]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.116998]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.117001]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13196.117004]  [<c043b8ad>] ? start_secondary+0x21d/0x2e0
[13196.117007] ---[ end trace 871acfcc55c300a7 ]---
[13196.117021] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 22467.300 msecs
[13196.124929]  00000001 b7564770 00000000 00000001 f2511fac
[13196.124936] Call Trace:
[13196.124944]  [<c0599fc0>] fd_install+0x20/0x30
[13196.574863]  [<c057d95c>] do_sys_open+0x17c/0x1f0
[13196.574876]  [<c057d9f2>] SyS_open+0x22/0x30
[13196.574880]  [<c0b1238d>] sysenter_do_call+0x12/0x38
[13196.574882] Code: ec 04 3e 8d 74 26 00 8d 78 40 89 c3 89 f8 89 d6 89 4d f0 e8 b1 01 57 00 8b 43 04 8b 50 04 8b 0c b2 85 c9 8b 4d f0 75 15 8b 40 04 <89> 0c b0 89 f8 e8 44 03 57 00 83 c4 04 5b 5e 5f 5d c3 0f 0b 8d
[13196.574926] NMI backtrace for cpu 4
[13196.574932] CPU: 4 PID: 342 Comm: irqbalance Tainted: G        W    3.13.0-rc2+ #48
[13196.574934] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.574936] task: f185b660 ti: f1b9c000 task.ti: f1b9c000
[13196.575145] EIP: 0060:[<c0596774>] EFLAGS: 00010046 CPU: 4
[13196.575165] EIP is at inode_init_once+0x34/0x110
[13196.575168] EAX: 00000000 EBX: ce7b0fe0 ECX: 0000007e EDX: 00000218
[13196.575169] ESI: ce7b0fc0 EDI: ce7b1000 EBP: f1b9dce0 ESP: f1b9dcd4
[13196.575171]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.575173] CR0: 80050033 CR2: b777a000 CR3: 32412000 CR4: 001407f0
[13196.575240] Stack:
[13196.575242]  00000000 f3454a00 ce7b0fc0 f1b9dce8 c05d7fd0 f1b9dcf8 c056aff7 f3454a00
[13196.575261]  ce7b1200 f1b9dd18 c056b375 00000000 f44f2600 ce7b0000 f34005c0 f3454a04
[13196.575266]  f3454a00 f1b9dd88 c0b00b8f 801c001c 00000000 001c001c c05d84d9 f3454a04
[13196.575272] Call Trace:
[13196.575281]  [<c05d7fd0>] init_once+0x10/0x20
[13196.575285]  [<c056aff7>] setup_object.isra.51+0x47/0x60
[13196.575288]  [<c056b375>] new_slab+0x165/0x280
[13196.575292]  [<c0b00b8f>] __slab_alloc.constprop.64+0x1ce/0x470
[13196.575295]  [<c05d84d9>] ? proc_alloc_inode+0x19/0x80
[13196.575299]  [<c049f4a7>] ? mark_held_locks+0x87/0xf0
[13196.575302]  [<c056dee3>] kmem_cache_alloc+0x1a3/0x1f0
[13196.575305]  [<c05d84d9>] ? proc_alloc_inode+0x19/0x80
[13196.575308]  [<c05d84d9>] proc_alloc_inode+0x19/0x80
[13196.575311]  [<c0596ca9>] alloc_inode+0x19/0x80
[13196.575314]  [<c059887f>] new_inode_pseudo+0xf/0x50
[13196.575316]  [<c05d8891>] proc_get_inode+0x11/0xe0
[13196.575321]  [<c05dd19b>] proc_lookup_de+0x6b/0xb0
[13196.575324]  [<c05dd1f7>] proc_lookup+0x17/0x20
[13196.575327]  [<c0586df7>] lookup_real+0x17/0x40
[13196.575330]  [<c058c248>] do_last+0x9d8/0x10b0
[13196.575333]  [<c0589125>] ? link_path_walk+0x1e5/0x700
[13196.575336]  [<c058c9d0>] path_openat+0xb0/0x580
[13196.575339]  [<c058d651>] do_filp_open+0x31/0x80
[13196.575343]  [<c057d8ed>] do_sys_open+0x10d/0x1f0
[13196.575376]  [<c05549a0>] ? vm_munmap+0x40/0x50
[13196.575381]  [<c0b123c2>] ? sysenter_exit+0xf/0x1e
[13196.575384]  [<c057d9f2>] SyS_open+0x22/0x30
[13196.575386]  [<c0b1238d>] sysenter_do_call+0x12/0x38
[13196.575387] Code: 8d 74 26 00 ba 18 02 00 00 a8 01 89 c3 89 c7 0f 85 ba 00 00 00 f7 c7 02 00 00 00 0f 85 c6 00 00 00 89 d1 31 c0 c1 e9 02 f6 c2 02 <f3> ab 74 09 31 c0 83 c7 02 66 89 47 fe 83 e2 01 74 03 c6 07 00
[13196.575426] NMI backtrace for cpu 5
[13196.575431] CPU: 5 PID: 1859 Comm: cifsd Tainted: G        W    3.13.0-rc2+ #48
[13196.575433] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.575435] task: ee57ecc0 ti: f3616000 task.ti: f6e7a000
[13196.575483] EIP: 0060:[<c08bf503>] EFLAGS: 00000002 CPU: 5
[13196.575487] EIP is at pcnet32_wio_write_csr+0x13/0x20
[13196.575489] EAX: 00000000 EBX: 00002000 ECX: 00000048 EDX: 00002012
[13196.575504] ESI: c0bbec34 EDI: 0000000e EBP: f3617ed4 ESP: f3617ed0
[13196.575506]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.575508] CR0: 80050033 CR2: b77b9000 CR3: 324f5000 CR4: 001407f0
[13196.575678] Stack:
[13196.575680]  f3434000 f3617f14 c08c0a19 00000036 00000001 00000000 00000001 00000000
[13196.575701]  00000282 f34346f0 f2ffeee8 000000d0 00002000 f1f77240 00004000 ee465940
[13196.575706]  c0bbea80 f3617f4c c09edd61 00000000 f3747cd0 c0bbea80 f3434000 f3747c00
[13196.575783] Call Trace:
[13196.576190]  [<c08c0a19>] pcnet32_start_xmit+0x139/0x1f0
[13196.576195]  [<c09edd61>] dev_hard_start_xmit+0x4c1/0x550
[13196.576199]  [<c0a0768b>] sch_direct_xmit+0xbb/0x2f0
[13196.576202]  [<c09ea9c3>] ? net_tx_action+0xd3/0x1d0
[13196.576205]  [<c0a07913>] __qdisc_run+0x53/0x170
[13196.576208]  [<c09ea9e6>] net_tx_action+0xf6/0x1d0
[13196.576233]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.576237]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.576238]  <IRQ> 

[13196.576242]  [<c045caed>] ? do_softirq+0x6d/0x80
[13196.576246]  [<c0a224d0>] ? ip_finish_output+0x200/0x720
[13196.576249]  [<c045cc78>] ? local_bh_enable+0xb8/0xc0
[13196.576251]  [<c0a224d0>] ? ip_finish_output+0x200/0x720
[13196.576254]  [<c0a236c0>] ? ip_output+0xc0/0x170
[13196.576289]  [<c0a236c0>] ? ip_output+0xc0/0x170
[13196.576294]  [<c0a22b26>] ? ip_local_out+0x26/0x80
[13196.576297]  [<c0a22b26>] ? ip_local_out+0x26/0x80
[13196.576299]  [<c0a22f21>] ? ip_queue_xmit+0x161/0x510
[13196.576302]  [<c0a22dc0>] ? ip_build_and_send_pkt+0x240/0x240
[13196.699343]  [<c09dec37>] ? __skb_clone+0x27/0xf0
[13196.699356]  [<c0a38847>] ? tcp_transmit_skb+0x417/0x7e0
[13196.699360]  [<c09de3a2>] ? __kmalloc_reserve.isra.30+0x22/0x70
[13196.699363]  [<c0a3b0a1>] ? tcp_connect+0x501/0x5e0
[13196.699368]  [<c04bc56d>] ? getnstimeofday+0xd/0x30
[13196.699371]  [<c04bc5e6>] ? ktime_get_real+0x16/0x30
[13196.699375]  [<c09e5f3e>] ? secure_tcp_sequence_number+0x4e/0x80
[13196.699378]  [<c0a3dccf>] ? tcp_v4_connect+0x2df/0x480
[13196.699382]  [<c0a5334e>] ? __inet_stream_connect+0x7e/0x2c0
[13196.699385]  [<c045cc2a>] ? local_bh_enable+0x6a/0xc0
[13196.699388]  [<c09d8940>] ? lock_sock_nested+0x80/0x90
[13196.699391]  [<c0a535ae>] ? inet_stream_connect+0x1e/0x50
[13196.699394]  [<c0a535bf>] ? inet_stream_connect+0x2f/0x50
[13196.699443]  [<c06d4a47>] ? generic_ip_connect+0xa7/0x4b0
[13196.699449]  [<c06d50a5>] ? cifs_reconnect+0x255/0x3e0
[13196.699452]  [<c06d542c>] ? cifs_readv_from_socket+0x1fc/0x290
[13196.699456]  [<c06ef500>] ? cifs_negotiate+0x50/0x50
[13196.699459]  [<c06d5a54>] ? cifs_demultiplex_thread+0x514/0x8d0
[13196.699463]  [<c0b0ae60>] ? restore_all+0xf/0xf
[13196.699466]  [<c06d5540>] ? dequeue_mid+0x50/0x50
[13196.699470]  [<c047743c>] ? kthread+0xac/0xc0
[13196.699474]  [<c0b122f7>] ? ret_from_kernel_thread+0x1b/0x28
[13196.699477]  [<c0477390>] ? kthread_create_on_node+0x170/0x170
[13196.699479] Code: 89 c1 0f b7 c2 8d 51 12 66 ef 8d 51 10 66 ed 5d c3 8d b4 26 00 00 00 00 55 89 e5 53 3e 8d 74 26 00 89 c3 0f b7 c2 8d 53 12 66 ef <8d> 53 10 89 c8 66 ef 5b 5d c3 8d 76 00 55 89 e5 3e 8d 74 26 00
[13196.699521] NMI backtrace for cpu 2
[13196.699527] CPU: 2 PID: 351 Comm: vmtoolsd Tainted: G        W    3.13.0-rc2+ #48
[13196.699529] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.699531] task: f1b91220 ti: f6e6c000 task.ti: f6e6c000
[13196.699533] EIP: 0073:[<b772ccea>] EFLAGS: 00000296 CPU: 2
[13196.699540] EIP is at 0xb772ccea
[13196.699542] EAX: 00000000 EBX: 00000002 ECX: 00830000 EDX: 00010000
[13196.699544] ESI: a08f0e36 EDI: 43280385 EBP: b96f49f0 ESP: bffb18fc
[13196.699545]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b

[13196.699550] NMI backtrace for cpu 0
[13196.699561] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.13.0-rc2+ #48
[13196.699563] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.699566] task: c0e1aa60 ti: f3410000 task.ti: c0e0e000
[13196.699568] EIP: 0060:[<c09014a5>] EFLAGS: 00200006 CPU: 0
[13196.699577] EIP is at uhci_hub_status_data+0xb5/0x200
[13196.699579] EAX: 00001085 EBX: f6cb8400 ECX: 00000002 EDX: 000020d2
[13196.699581] ESI: 00000012 EDI: 00000001 EBP: f3411f08 ESP: f3411ee4
[13196.699582]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.699584] CR0: 80050033 CR2: b6d15000 CR3: 31945000 CR4: 001407f0
[13196.699657] Stack:
[13196.699659]  f6cb85b0 00200282 f6cb85f8 f3411f16 0000080a 00411f30 f6cb8400 f6cb8474
[13196.699666]  00000101 f3411f28 c08da04f c0462ce0 00000000 00200246 00000000 f6cb8474
[13196.699671]  00000101 f3411f30 c08da12d f3411f74 c0462d55 00000000 00000002 00000000
[13196.699676] Call Trace:
[13196.699682]  [<c08da04f>] usb_hcd_poll_rh_status+0x3f/0x110
[13196.699686]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.699705]  [<c08da12d>] rh_timer_func+0xd/0x10
[13196.699709]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.699712]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.699715]  [<c08da120>] ? usb_hcd_poll_rh_status+0x110/0x110
[13196.699718]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.699721]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.699724]  [<c08da120>] ? usb_hcd_poll_rh_status+0x110/0x110
[13196.700278]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.700285]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.700286]  <IRQ> 

[13196.700292]  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.700296]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.700300]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.700304]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.700308]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.700311]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.700315]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.700321]  [<c0af9549>] ? rest_init+0xb9/0xc0
[13196.700324]  [<c0af9490>] ? reciprocal_value+0x30/0x30
[13196.700333]  [<c0ebeb0a>] ? start_kernel+0x3dd/0x3e3
[13196.700336]  [<c0ebe564>] ? repair_env_string+0x51/0x51
[13196.700339]  [<c0ebe38b>] ? i386_start_kernel+0x12e/0x131
[13196.700340] Code: 00 85 c0 0f 8e 54 01 00 00 b9 01 00 00 00 be 10 00 00 00 c6 45 f3 00 8d b4 26 00 00 00 00 8b 93 b4 01 00 00 8d 79 ff 01 f2 66 ed <0f> b7 c0 85 45 ec 75 0f 0f a3 bb 8c 02 00 00 19 ff 85 ff 89 c8
[13196.700378] NMI backtrace for cpu 3
[13196.700382] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.13.0-rc2+ #48
[13196.700384] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.700387] task: f3515aa0 ti: f35c6000 task.ti: f351e000
[13196.700389] EIP: 0060:[<c07760c3>] EFLAGS: 00200006 CPU: 3
[13196.700394] EIP is at delay_tsc+0x53/0x90
[13196.700396] EAX: 3ea3aa41 EBX: 00000001 ECX: 00000000 EDX: 0000e63f
[13196.700398] ESI: 3ea3aa26 EDI: 00000003 EBP: f35c7cd0 ESP: f35c7cc4
[13196.700400]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.700402] CR0: 80050033 CR2: b440b0f0 CR3: 3084b000 CR4: 001407f0
[13196.700410] Stack:
[13196.700411]  c0e35c80 168ce267 00000000 f35c7cd8 c0775fee f35c7cf4 c04a4ac3 a0929140
[13196.700418]  00000000 c0e35c80 f3515aa0 00000000 f35c7d10 c0b0a166 00000000 00000002
[13196.700424]  00000000 c04b0441 f3515aa0 f35c7d50 c04b0441 00000025 00000000 00000000
[13196.700430] Call Trace:
[13196.700435]  [<c0775fee>] __delay+0xe/0x10
[13196.700439]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.700444]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.700448]  [<c04b0441>] ? vprintk_emit+0x101/0x5c0
[13196.700451]  [<c04b0441>] vprintk_emit+0x101/0x5c0
[13196.700455]  [<c0aff2e5>] printk+0x50/0x52
[13196.700459]  [<c049f0ef>] print_irqtrace_events+0x7f/0xf0
[13196.700462]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.700465]  [<c0b0b2ae>] ? apic_timer_interrupt+0x32/0x40
[13196.700468]  [<c04f2b3a>] watchdog_timer_fn+0x11a/0x170
[13196.700472]  [<c047a5eb>] __run_hrtimer+0x7b/0x1d0
[13196.700475]  [<c04f2a20>] ? watchdog_cleanup+0x10/0x10
[13196.700478]  [<c047b295>] hrtimer_interrupt+0x1f5/0x2b0
[13196.700483]  [<c043d6ff>] local_apic_timer_interrupt+0x2f/0x60
[13196.700486]  [<c045ccc1>] ? irq_enter+0x41/0x80
[13196.700490]  [<c043d8d3>] smp_apic_timer_interrupt+0x33/0x50
[13196.700493]  [<c0b0b2b5>] apic_timer_interrupt+0x39/0x40
[13196.700497]  [<c077607b>] ? delay_tsc+0xb/0x90
[13196.700500]  [<c0775fee>] __delay+0xe/0x10
[13196.700503]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.700507]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.700512]  [<c0a071bb>] ? dev_watchdog+0x5b/0x240
[13196.700515]  [<c0a071bb>] dev_watchdog+0x5b/0x240
[13196.700518]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700522]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.700525]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700528]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700531]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.700534]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.700537]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700541]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.700544]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.700546]  <IRQ> 

[13196.700550]  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.700553]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.700590]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.700595]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.700599]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.700602]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.700606]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.700609]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13196.700612]  [<c043b8ad>] ? start_secondary+0x21d/0x2e0
[13196.700614] Code: c6 eb 20 90 8d 74 26 00 64 ff 0d 30 31 f8 c0 f3 90 64 ff 05 30 31 f8 c0 64 8b 15 10 20 f8 c0 39 d7 75 20 8d 76 00 0f ae e8 0f 31 <8d> 74 26 00 89 c2 29 f2 39 da 72 d1 64 ff 0d 30 31 f8 c0 5b 5e
[13196.700686] [<c0b0b2ae>] apic_timer_interrupt+0x32/0x40
[13196.700689] softirqs last  enabled at (1596432): [<c045bc5f>] _local_bh_enable+0x1f/0x50
[13196.700691] softirqs last disabled at (1596433): [<c04132f5>] do_softirq_own_stack+0x35/0x40
[13196.700697] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.13.0-rc2+ #48
[13196.700698] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[13196.700700] task: f3515aa0 ti: f35c6000 task.ti: f351e000
[13196.700702] EIP: 0060:[<c077607b>] EFLAGS: 00200202 CPU: 3
[13196.700705] EIP is at delay_tsc+0xb/0x90
[13196.700707] EAX: 00000001 EBX: f3747cc0 ECX: 00000001 EDX: 00007877
[13196.700709] ESI: 36c95f73 EDI: 00000000 EBP: f35c7eb4 ESP: f35c7ea8
[13196.700711]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[13196.700712] CR0: 80050033 CR2: b440b0f0 CR3: 3084b000 CR4: 001407f0
[13196.700719] Stack:
[13196.700720]  f3747cc0 36c95f73 00000000 f35c7ebc c0775fee f35c7ed8 c04a4ac3 a0929140
[13196.700726]  00000000 f3747cc0 00000000 00000000 f35c7ef4 c0b0a166 00000000 00000002
[13196.700732]  00000000 c0a071bb f3747c00 f35c7f30 c0a071bb 00200246 00000000 00000002
[13196.700739] Call Trace:
[13196.700743]  [<c0775fee>] __delay+0xe/0x10
[13196.700746]  [<c04a4ac3>] do_raw_spin_lock+0x73/0x150
[13196.700750]  [<c0b0a166>] _raw_spin_lock+0x46/0x50
[13196.700753]  [<c0a071bb>] ? dev_watchdog+0x5b/0x240
[13196.700756]  [<c0a071bb>] dev_watchdog+0x5b/0x240
[13196.700759]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700762]  [<c0462d55>] call_timer_fn+0x75/0x160
[13196.700766]  [<c0462ce0>] ? process_timeout+0x10/0x10
[13196.700769]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700772]  [<c0463a42>] run_timer_softirq+0x192/0x230
[13196.700775]  [<c045c838>] ? __do_softirq+0x88/0x260
[13196.700779]  [<c0a07160>] ? dev_graft_qdisc+0x70/0x70
[13196.700782]  [<c045c888>] __do_softirq+0xd8/0x260
[13196.700785]  [<c045c7b0>] ? cpu_callback+0x190/0x190
[13196.700786]  <IRQ> 

[13196.700790]  [<c045cdad>] ? irq_exit+0xad/0xc0
[13196.700794]  [<c043d8d8>] ? smp_apic_timer_interrupt+0x38/0x50
[13196.700797]  [<c0b0b2b5>] ? apic_timer_interrupt+0x39/0x40
[13196.700800]  [<c0448d05>] ? native_safe_halt+0x5/0x10
[13196.700804]  [<c0418b81>] ? default_idle+0x21/0xc0
[13196.700807]  [<c0419356>] ? arch_cpu_idle+0x36/0x40
[13196.700810]  [<c04b1de2>] ? cpu_startup_entry+0x1f2/0x250
[13196.700813]  [<c043d17b>] ? setup_APIC_timer+0xab/0x130
[13196.700817]  [<c043b8ad>] ? start_secondary+0x21d/0x2e0
[13196.700819] Code: d2 fa 00 00 00 8d 04 80 c1 e0 02 f7 e2 8d 42 01 ff 15 bc 24 e7 c0 5d c3 90 8d b4 26 00 00 00 00 55 89 e5 57 56 53 3e 8d 74 26 00 <64> ff 05 30 31 f8 c0 89 c3 64 8b 3d 10 20 f8 c0 8d 76 00 0f ae
[13217.675940] mptscsih: ioc0: task abort: SUCCESS (rv=2002) (sc=e5fc8cc0)


#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.13.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=m
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
# CONFIG_MEMCG_SWAP_ENABLED is not set
CONFIG_MEMCG_KMEM=y
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_STA2X11 is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_32_IRIS is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=64
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x400000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x400000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
CONFIG_APM_CPU_IDLE=y
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_NET_IP_TUNNEL is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=m
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_NF_NAT_TFTP=m
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set
# CONFIG_NETFILTER_XT_CONNMARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_HL is not set
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NETMAP is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_REDIRECT is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TPROXY is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_RPFILTER is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT_IPV4=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
# CONFIG_IP6_NF_MATCH_HL is not set
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
# CONFIG_IP6_NF_TARGET_SYNPROXY is not set
CONFIG_IP6_NF_MANGLE=m
# CONFIG_IP6_NF_RAW is not set
# CONFIG_IP6_NF_SECURITY is not set
CONFIG_NF_NAT_IPV6=m
# CONFIG_IP6_NF_TARGET_MASQUERADE is not set
# CONFIG_IP6_NF_TARGET_NPT is not set
CONFIG_BRIDGE_NF_EBTABLES=m
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
# CONFIG_BRIDGE_EBT_802_3 is not set
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
# CONFIG_BRIDGE_EBT_IP is not set
# CONFIG_BRIDGE_EBT_IP6 is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
# CONFIG_BRIDGE_EBT_SNAT is not set
# CONFIG_BRIDGE_EBT_LOG is not set
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_ATMEL_PWM is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LAN is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_PCNET32=y
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_SH_ETH is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
# CONFIG_XEN_NETDEV_BACKEND is not set
CONFIG_VMXNET3=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_KGDB_NMI is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_ATMEL is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_EXYNOS is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
# CONFIG_PINCONF is not set
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_X86_PKG_TEMP_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_TTM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ACPI=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SELFBALLOONING=y
CONFIG_XEN_SCRUB_PAGES=y
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
# CONFIG_XEN_PCIDEV_BACKEND is not set
CONFIG_XEN_PRIVCMD=m
# CONFIG_XEN_ACPI_PROCESSOR is not set
CONFIG_XEN_HAVE_PVMMU=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_DEBUG is not set
# CONFIG_COMMON_CLK_SI5351 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
CONFIG_DEVFREQ_GOV_PERFORMANCE=m
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=y
CONFIG_PNFS_BLOCK=y
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
# CONFIG_NFSD_V4_SECURITY_LABEL is not set
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
CONFIG_KDB_CONTINUE_CATASTROPHIC=0
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_KVM_DEVICE_ASSIGNMENT=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y



ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
