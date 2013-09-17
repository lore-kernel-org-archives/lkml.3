Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3IQC7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 22:59:12 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57923 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3IQC7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 22:59:10 -0400
MIME-Version: 1.0
Date: Tue, 17 Sep 2013 10:59:09 +0800
Message-ID: <CADkPA2C8KR_iCHvQK0Vkv8dZK--w_VUfcTCq7NSEaVb=-fjZXw@mail.gmail.com>
Subject: Kernel panic
From: zhang xintao <zhang.kvm@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-279.el6.x86_64 #1 SMP Thu Sep 12 12:59:17 CST 2013 x86_64
x86_64 x86_64 GNU/Linux
==========================
PID: 2621   TASK: ffff881fe10d2aa0  CPU: 14  COMMAND: "qemu-kvm"
 #0 [ffff880028307b00] machine_kexec at ffffffff8103281b
 #1 [ffff880028307b60] crash_kexec at ffffffff810ba322
 #2 [ffff880028307c30] panic at ffffffff814fce74
 #3 [ffff880028307cb0] watchdog_overflow_callback at ffffffff810daf7d
 #4 [ffff880028307cd0] __perf_event_overflow at ffffffff8110dbbd
 #5 [ffff880028307d70] perf_event_overflow at ffffffff8110e174
 #6 [ffff880028307d80] intel_pmu_handle_irq at ffffffff8101e976
 #7 [ffff880028307e90] perf_event_nmi_handler at ffffffff81501519
 #8 [ffff880028307ea0] notifier_call_chain at ffffffff81503065
 #9 [ffff880028307ee0] atomic_notifier_call_chain at ffffffff815030ca
#10 [ffff880028307ef0] notify_die at ffffffff81097d6e
#11 [ffff880028307f20] do_nmi at ffffffff81500ce3
#12 [ffff880028307f50] nmi at ffffffff815005f0
    [exception RIP: _spin_lock+33]
    RIP: ffffffff814ffe61  RSP: ffff8800283033d0  RFLAGS: 00000097
    RAX: 0000000000008dbb  RBX: 0000000000016680  RCX: 00000000000000c1
    RDX: 0000000000008db4  RSI: ffff880028303438  RDI: ffff880028336680
    RBP: ffff8800283033d0   R8: 00000000000000c1   R9: 0000000000000005
    R10: 0000000000000000  R11: 0000000000000001  R12: ffff880bf2fd0080
    R13: ffff880028303438  R14: ffff880028336680  R15: 0000000000000001
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <NMI exception stack> ---
#13 [ffff8800283033d0] _spin_lock at ffffffff814ffe61
#14 [ffff8800283033d8] task_rq_lock at ffffffff8105350d
#15 [ffff880028303408] try_to_wake_up at ffffffff8105bfbc
#16 [ffff880028303478] default_wake_function at ffffffff8105c372
#17 [ffff880028303488] pollwake at ffffffff8118fbd6
#18 [ffff8800283034c8] __wake_up_common at ffffffff8104e189
#19 [ffff880028303518] __wake_up at ffffffff81053268
#20 [ffff880028303558] tun_net_xmit at ffffffffa0156495 [tun]
#21 [ffff880028303588] dev_hard_start_xmit at ffffffff8143ad9c
#22 [ffff8800283035e8] sch_direct_xmit at ffffffff814588ea
#23 [ffff880028303638] __qdisc_run at ffffffff814589bb
#24 [ffff880028303668] dev_queue_xmit at ffffffff8143f4c3
#25 [ffff8800283036b8] br_dev_queue_push_xmit at ffffffffa03796bc [bridge]
#26 [ffff8800283036d8] br_nf_dev_queue_xmit at ffffffffa037f378 [bridge]
#27 [ffff8800283036e8] br_nf_post_routing at ffffffffa037fe10 [bridge]
#28 [ffff880028303738] nf_iterate at ffffffff814662b9
#29 [ffff880028303788] nf_hook_slow at ffffffff81466474
#30 [ffff880028303808] br_forward_finish at ffffffffa0379733 [bridge]
#31 [ffff880028303838] br_nf_forward_finish at ffffffffa037f9b8 [bridge]
#32 [ffff880028303878] br_nf_forward_ip at ffffffffa0380ea8 [bridge]
#33 [ffff8800283038d8] nf_iterate at ffffffff814662b9
#34 [ffff880028303928] nf_hook_slow at ffffffff81466474
#35 [ffff8800283039a8] __br_forward at ffffffffa03797c2 [bridge]
#36 [ffff8800283039d8] deliver_clone at ffffffffa037939e [bridge]
#37 [ffff880028303a08] br_flood at ffffffffa03795b9 [bridge]
#38 [ffff880028303a48] br_flood_forward at ffffffffa0379625 [bridge]
#39 [ffff880028303a58] br_handle_frame_finish at ffffffffa037a7ae [bridge]
#40 [ffff880028303aa8] br_nf_pre_routing_finish at ffffffffa0380318 [bridge]
#41 [ffff880028303b48] br_nf_pre_routing at ffffffffa038088f [bridge]
#42 [ffff880028303b98] nf_iterate at ffffffff814662b9
#43 [ffff880028303be8] nf_hook_slow at ffffffff81466474
#44 [ffff880028303c68] br_handle_frame at ffffffffa037a95c [bridge]
#45 [ffff880028303ca8] __netif_receive_skb at ffffffff8143a509
#46 [ffff880028303d08] netif_receive_skb at ffffffff8143c708
#47 [ffff880028303d48] napi_skb_finish at ffffffff8143c810
#48 [ffff880028303d68] napi_gro_receive at ffffffff8143ed49
#49 [ffff880028303d88] ixgbe_receive_skb at ffffffffa00df9df [ixgbe]
#50 [ffff880028303d98] ixgbe_poll at ffffffffa00e0dda [ixgbe]
#51 [ffff880028303e68] net_rx_action at ffffffff8143ee63
#52 [ffff880028303ec8] __do_softirq at ffffffff81073b81
#53 [ffff880028303f38] call_softirq at ffffffff8100c24c
#54 [ffff880028303f50] do_softirq at ffffffff8100de85
#55 [ffff880028303f70] irq_exit at ffffffff81073965
#56 [ffff880028303f80] do_IRQ at ffffffff81505835
--- <IRQ stack> ---
#57 [ffff881e47ce3a48] ret_from_intr at ffffffff8100ba53
    [exception RIP: x86_emulate_insn+9030]
    RIP: ffffffffa01c69f6  RSP: ffff881e47ce3af8  RFLAGS: 00000202
    RAX: 0000000000000000  RBX: ffff881e47ce3b88  RCX: 0000000000000010
    RDX: ffff881c26cbc5c0  RSI: 0000000000000003  RDI: ffff881c26cbc5c0
    RBP: ffffffff8100ba4e   R8: 0000000000000001   R9: ffffffffa01b3bf0
    R10: 0000000000000000  R11: 0000000000000000  R12: ffffffffa01ae2c6
    R13: ffff881e47ce3a98  R14: 0000000000000000  R15: ffff881c26cbc5c0
    ORIG_RAX: ffffffffffffff86  CS: 0010  SS: 0018
#58 [ffff881e47ce3b90] x86_emulate_instruction at ffffffffa01b47ab [kvm]
#59 [ffff881e47ce3bf0] kvm_mmu_page_fault at ffffffffa01be6d2 [kvm]
#60 [ffff881e47ce3c30] handle_ept_violation at ffffffffa020548a [kvm_intel]
#61 [ffff881e47ce3c70] vmx_handle_exit at ffffffffa0208cc7 [kvm_intel]
#62 [ffff881e47ce3cb0] kvm_arch_vcpu_ioctl_run at ffffffffa01b724c [kvm]
#63 [ffff881e47ce3db0] kvm_vcpu_ioctl at ffffffffa01a0322 [kvm]
#64 [ffff881e47ce3e60] vfs_ioctl at ffffffff8118db82
#65 [ffff881e47ce3ea0] do_vfs_ioctl at ffffffff8118e04a
#66 [ffff881e47ce3f30] sys_ioctl at ffffffff8118e2a1
#67 [ffff881e47ce3f80] system_call_fastpath at ffffffff8100b0f2
    RIP: 00007faceea17a87  RSP: 00007faceab8ba90  RFLAGS: 00000206
    RAX: 0000000000000010  RBX: ffffffff8100b0f2  RCX: 00007facf232e010
    RDX: 0000000000000000  RSI: 000000000000ae80  RDI: 0000000000000010
    RBP: 00007facf54b0e40   R8: 0000000020047000   R9: 00007facf2b3f420
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007facf2468000
    R13: 00007facf54b0f30  R14: 0000000000000000  R15: 00007facf2467000
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
