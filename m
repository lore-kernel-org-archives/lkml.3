Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3DOWZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:25:32 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:45109 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3DOWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <tip-d166991234347215dc23fc9dc15a63a83a1a54e1@git.kernel.org>
References: <20130321215233.646635455@linutronix.de>
	<tip-d166991234347215dc23fc9dc15a63a83a1a54e1@git.kernel.org>
Date: Mon, 15 Apr 2013 15:25:29 -0700
Message-ID: <CA+8MBbLqTVSGpgCKFH79xDvW2brP6Gen7GiSRYW6EY8iDZE3yQ@mail.gmail.com>
Subject: Re: [tip:smp/hotplug] idle: Implement generic idle function
From: Tony Luck <tony.luck@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, magnus.damm@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Built next-20130415 and got this on ia64 early in boot:

WARNING: at kernel/cpu/idle.c:94 cpu_idle_loop+0x360/0x380()
Hardware name: server rx2620
Modules linked in:

Call Trace:
 [<a000000100014ac0>] show_stack+0x80/0xa0
                                sp=a000000101287c50 bsp=a000000101280e48
 [<a000000100dabd40>] dump_stack+0x30/0x50
                                sp=a000000101287e20 bsp=a000000101280e30
 [<a000000100073e40>] warn_slowpath_common+0xc0/0x100
                                sp=a000000101287e20 bsp=a000000101280de8
 [<a000000100073ec0>] warn_slowpath_null+0x40/0x60
                                sp=a000000101287e20 bsp=a000000101280dc0
 [<a0000001000fa7a0>] cpu_idle_loop+0x360/0x380
                                sp=a000000101287e20 bsp=a000000101280d80
 [<a0000001000fa800>] cpu_startup_entry+0x40/0x60
                                sp=a000000101287e20 bsp=a000000101280d68
 [<a000000100d9f460>] rest_init+0x100/0x120
                                sp=a000000101287e20 bsp=a000000101280d50
 [<a00000010114d3b0>] start_kernel+0x770/0x890
                                sp=a000000101287e20 bsp=a000000101280cd0
 [<a000000100d9f320>] start_ap+0x760/0x780
                                sp=a000000101287e30 bsp=a000000101280bc0
