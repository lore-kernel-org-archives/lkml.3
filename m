Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161017AbaDPNUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:20:36 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754343AbaDPNUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:20:35 -0400
Message-ID: <534E839E.5080203@nod.at>
Date: Wed, 16 Apr 2014 15:20:30 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1857 at arch/x86/kernel/smp.c:124
References: <534E49C8.7050206@nod.at> <20140416131257.GF32556@tassilo.jf.intel.com>
In-Reply-To: <20140416131257.GF32556@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.04.2014 15:12, schrieb Andi Kleen:
>>  [<ffffffff810349ab>] local_apic_timer_interrupt+0x3b/0x60
>>  [<ffffffff815903d5>] smp_apic_timer_interrupt+0x45/0x60
>>  [<ffffffff8158f18a>] apic_timer_interrupt+0x6a/0x70
>>  <EOI>  [<ffffffff81581bd1>] ? panic+0x1a7/0x1ea
>>  [<ffffffff81581bcd>] ? panic+0x1a3/0x1ea
> 
> You're using panic_on_oops?

Nope.

> That seems like a bug in panic. It shouldn't reenable interrupts
> 
> -Andi

Thanks,
//richard
