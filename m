Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab3FQGlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:41:07 -0400
Received: from sam.nabble.com ([216.139.236.26]:34378 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab3FQGlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:41:04 -0400
Date: Sun, 16 Jun 2013 23:40:02 -0700 (PDT)
From: masefee <masefee@163.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1371451202409-668230.post@n7.nabble.com>
Subject: swapper Not tainted 2.6.32.57-tlinux_xenU-1.1.rc6-default
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

*Booting 2.6.32.57.rc6, I get this in my log. 2.6.32.57.rc6 and below were
fine. 
Please contact me if you need further information. Thanks!!*

*System info:*
Linux VM_42_34 2.6.32.57-tlinux_xenU-1.1.rc6-default #1 SMP Wed Oct 31
18:47:46 CST 2012 x86_64 x86_64 x86_64 GNU/Linux
gcc version 4.1.2 20070115 (prerelease) (SUSE Linux Server 10)

*Bug trace:*
kernel: [2558239.288004] BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
kernel: [2558239.288004] CPU 0:
kernel: [2558239.288004] Pid: 0, comm: swapper Not tainted
2.6.32.57-tlinux_xenU-1.1.rc6-default #1 HVM domU
kernel: [2558239.288004] RIP: 0010:[<ffffffff81772994>] 
[<ffffffff81772994>] _spin_lock+0x14/0x20
kernel: [2558239.288004] RSP: 0018:ffff880028203c10  EFLAGS: 00000297
kernel: [2558239.288004] RAX: 000000000000fef7 RBX: ffff880028203c10 RCX:
0000000000000000
kernel: [2558239.288004] RDX: 0000000000000001 RSI: 0000000000000680 RDI:
ffff88017b8ddf80
kernel: [2558239.288004] RBP: ffffffff81012f13 R08: ffff8801c285a540 R09:
ffffffff81e35fa0
kernel: [2558239.288004] R10: 0000000000000002 R11: 000000000001389e R12:
ffff880028203b90
kernel: [2558239.288004] R13: 0000000000000000 R14: ffffffff81e35f90 R15:
ffffffff812ff71a
kernel: [2558239.288004] FS:  0000000000000000(0000)
GS:ffff880028200000(0000) knlGS:0000000000000000
kernel: [2558239.288004] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
kernel: [2558239.288004] CR2: 00007f6b50955020 CR3: 0000000001001000 CR4:
00000000000006f0
kernel: [2558239.288004] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
kernel: [2558239.288004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
kernel: [2558239.288004] Call Trace:
kernel: [2558239.288004]  <IRQ>  [<ffffffff8165c7e1>] ?
dev_queue_xmit+0x3a1/0x430
kernel: [2558239.288004]  [<ffffffff816977ce>] ?
ip_finish_output+0x25e/0x2b0
kernel: [2558239.288004]  [<ffffffff81697b8e>] ? ip_output+0x7e/0xc0
kernel: [2558239.288004]  [<ffffffff81697190>] ? ip_local_out+0x20/0x30
kernel: [2558239.288004]  [<ffffffff81697e50>] ? ip_queue_xmit+0x1e0/0x380
kernel: [2558239.288004]  [<ffffffff810bb611>] ? __kmalloc_node+0x31/0x50
kernel: [2558239.288004]  [<ffffffff816bdf78>] ?
inet_sk_rebuild_header+0x28/0x310
crontab[30001]: (root) LIST (root)
kernel: [2558239.288004]  [<ffffffff816aad9c>] ?
tcp_transmit_skb+0x3cc/0x730
kernel: [2558239.288004]  [<ffffffff8164f5c5>] ? skb_release_data+0x65/0xd0
kernel: [2558239.288004]  [<ffffffff816abc6c>] ?
tcp_retransmit_skb+0x21c/0x5d0
kernel: [2558239.288004]  [<ffffffff816aebb0>] ? tcp_write_timer+0x0/0x1e0
kernel: [2558239.288004]  [<ffffffff816adfb4>] ?
tcp_retransmit_timer+0x134/0x860
kernel: [2558239.288004]  [<ffffffff816aecad>] ? tcp_write_timer+0xfd/0x1e0
kernel: [2558239.288004]  [<ffffffff8105748b>] ?
run_timer_softirq+0x17b/0x1e0
kernel: [2558239.288004]  [<ffffffff810524a3>] ? __do_softirq+0xb3/0x150
kernel: [2558239.288004]  [<ffffffff81e50140>] ? early_idt_handler+0x0/0x71
kernel: [2558239.288004]  [<ffffffff81012dec>] ? call_softirq+0x1c/0x30
kernel: [2558239.288004]  [<ffffffff81014e75>] ? do_softirq+0x65/0xa0
kernel: [2558239.288004]  [<ffffffff810523e7>] ? irq_exit+0x77/0x80
kernel: [2558239.288004]  [<ffffffff812ff71f>] ?
xen_evtchn_do_upcall+0x2f/0x40
kernel: [2558239.288004]  [<ffffffff81012f13>] ?
xen_hvm_callback_vector+0x13/0x20
kernel: [2558239.288004]  <EOI>  [<ffffffff8102fd96>] ?
native_safe_halt+0x6/0x10
kernel: [2558239.288004]  [<ffffffff810669e1>] ?
atomic_notifier_call_chain+0x11/0x20
kernel: [2558239.288004]  [<ffffffff810199b5>] ? default_idle+0x25/0x50
kernel: [2558239.288004]  [<ffffffff81010ce8>] ? cpu_idle+0x58/0x90
kernel: [2558239.288004]  [<ffffffff817310f2>] ? rest_init+0x72/0x80
kernel: [2558239.288004]  [<ffffffff81e50d9f>] ? start_kernel+0x2cf/0x320
kernel: [2558239.288004]  [<ffffffff81e502a4>] ?
x86_64_start_reservations+0x84/0x90
kernel: [2558239.288004]  [<ffffffff81e50000>] ?
early_idt_handlers+0x0/0x140
kernel: [2558239.288004]  [<ffffffff81e503a8>] ?
x86_64_start_kernel+0xf8/0x130
kernel: klogd 1.4.1, ---------- state change ---------- 
kernel: [2558304.812007] BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
kernel: [2558304.812010] CPU 0:
kernel: [2558304.812014] Pid: 0, comm: swapper Not tainted
2.6.32.57-tlinux_xenU-1.1.rc6-default #1 HVM domU
kernel: [2558304.812016] RIP: 0010:[<ffffffff81772996>] 
[<ffffffff81772996>] _spin_lock+0x16/0x20
kernel: [2558304.812023] RSP: 0018:ffff880028203c10  EFLAGS: 00000297
kernel: [2558304.812025] RAX: 000000000000e8e2 RBX: ffff880028203c10 RCX:
0000000000000000
kernel: [2558304.812027] RDX: 0000000000000001 RSI: 0000000000000680 RDI:
ffff88017b8ddf80
kernel: [2558304.812030] RBP: ffffffff81012f13 R08: ffff8801c285a540 R09:
ffffffff81e35fa0
kernel: [2558304.812032] R10: 0000000000000002 R11: 00000000b2b283a7 R12:
ffff880028203b90
kernel: [2558304.812034] R13: 0000000000000000 R14: ffffffff81e35f90 R15:
ffffffff812ff71a
kernel: [2558304.812040] FS:  0000000000000000(0000)
GS:ffff880028200000(0000) knlGS:0000000000000000
kernel: [2558304.812043] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
kernel: [2558304.812045] CR2: 00007f6b50955020 CR3: 0000000001001000 CR4:
00000000000006f0
kernel: [2558304.812048] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
kernel: [2558304.812051] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
kernel: [2558304.812053] Call Trace:
kernel: [2558304.812054]  <IRQ>  [<ffffffff8165c7e1>] ?
dev_queue_xmit+0x3a1/0x430
kernel: [2558304.812062]  [<ffffffff816977ce>] ?
ip_finish_output+0x25e/0x2b0
kernel: [2558304.812066]  [<ffffffff81697b8e>] ? ip_output+0x7e/0xc0
kernel: [2558304.812069]  [<ffffffff81697190>] ? ip_local_out+0x20/0x30
kernel: [2558304.812071]  [<ffffffff81697e50>] ? ip_queue_xmit+0x1e0/0x380
kernel: [2558304.812075]  [<ffffffff8164b3ba>] ? sk_setup_caps+0x1a/0xa0
kernel: [2558304.812079]  [<ffffffff816be24c>] ?
inet_sk_rebuild_header+0x2fc/0x310
kernel: [2558304.812083]  [<ffffffff816aad9c>] ?
tcp_transmit_skb+0x3cc/0x730
kernel: [2558304.812086]  [<ffffffff816abc6c>] ?
tcp_retransmit_skb+0x21c/0x5d0
kernel: [2558304.812089]  [<ffffffff816aebb0>] ? tcp_write_timer+0x0/0x1e0
kernel: [2558304.812092]  [<ffffffff816adfb4>] ?
tcp_retransmit_timer+0x134/0x860
kernel: [2558304.812095]  [<ffffffff816aecad>] ? tcp_write_timer+0xfd/0x1e0
kernel: [2558304.812099]  [<ffffffff8105748b>] ?
run_timer_softirq+0x17b/0x1e0
kernel: [2558304.812102]  [<ffffffff810524a3>] ? __do_softirq+0xb3/0x150
kernel: [2558304.812107]  [<ffffffff81e50140>] ? early_idt_handler+0x0/0x71
kernel: [2558304.812110]  [<ffffffff81012dec>] ? call_softirq+0x1c/0x30
kernel: [2558304.812113]  [<ffffffff81014e75>] ? do_softirq+0x65/0xa0
kernel: [2558304.812115]  [<ffffffff810523e7>] ? irq_exit+0x77/0x80
kernel: [2558304.812119]  [<ffffffff812ff71f>] ?
xen_evtchn_do_upcall+0x2f/0x40
kernel: [2558304.812122]  [<ffffffff81012f13>] ?
xen_hvm_callback_vector+0x13/0x20
kernel: [2558304.812124]  <EOI>  [<ffffffff8102fd96>] ?
native_safe_halt+0x6/0x10
kernel: [2558304.812132]  [<ffffffff810669e1>] ?
atomic_notifier_call_chain+0x11/0x20
kernel: [2558304.812136]  [<ffffffff810199b5>] ? default_idle+0x25/0x50
kernel: [2558304.812139]  [<ffffffff81010ce8>] ? cpu_idle+0x58/0x90
kernel: [2558304.812143]  [<ffffffff817310f2>] ? rest_init+0x72/0x80
kernel: [2558304.812146]  [<ffffffff81e50d9f>] ? start_kernel+0x2cf/0x320
kernel: [2558304.812149]  [<ffffffff81e502a4>] ?
x86_64_start_reservations+0x84/0x90
kernel: [2558304.812152]  [<ffffffff81e50000>] ?
early_idt_handlers+0x0/0x140
kernel: [2558304.812154]  [<ffffffff81e503a8>] ?
x86_64_start_kernel+0xf8/0x130

That's all, thanks!!

Reporter: masefee
E-Mail: masefee@163.com



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/swapper-Not-tainted-2-6-32-57-tlinux-xenU-1-1-rc6-default-tp668230.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
