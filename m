Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaAaWLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:11:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:56709 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaWLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:11:07 -0500
Date: Fri, 31 Jan 2014 23:11:06 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Joakim Hernberg <jbh@alchemy.lu>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
Message-ID: <20140131221106.GG21238@linutronix.de>
References: <20140125134519.GA9845@linutronix.de>
 <20140129153043.4d3ed46f@tor.valhalla.alchemy.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140129153043.4d3ed46f@tor.valhalla.alchemy.lu>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joakim Hernberg | 2014-01-29 15:30:43 [+0100]:

>On Sat, 25 Jan 2014 14:45:19 +0100
>Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>
>> Dear RT folks!
>> 
>> I'm pleased to announce the v3.12.8-rt11 patch set.
>
>So far the only thing seen in the kernel buffer on this 64b system are a
>smattering of "NOHZ: local_softirq_pending 40" and this warning:
>
>[23102.607632] ------------[ cut here ]------------
>[23102.607645] WARNING: CPU: 4 PID: 59 at kernel/time/tick-sched.c:161
>can_stop_full_tick+0x26b/0x280() 

This should be fixed by "irq_work: allow certain work in hard irq
context" I posted to the list today.

>Kernel config file attached:
>

Sebastian
