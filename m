Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaE2BTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 21:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaE2BTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 21:19:17 -0400
Message-ID: <53868AD2.7020902@redhat.com>
Date: Wed, 28 May 2014 21:18:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Anvin <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <waiman.long@hp.com>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        fernando_b1@lab.ntt.co.jp,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        xen-devel@lists.xenproject.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: [RFC] Implement Batched (group) ticket lock
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>	<53865B53.7050809@redhat.com> <CA+55aFx9d1dP+A3tdR-GaASQYBkkJHcV-=t9FdA7AGrMN12S0w@mail.gmail.com>
In-Reply-To: <CA+55aFx9d1dP+A3tdR-GaASQYBkkJHcV-=t9FdA7AGrMN12S0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 06:19 PM, Linus Torvalds wrote:

> If somebody has a P4 still, that's likely the worst case by far.

I'm sure cmpxchg isn't the only thing making P4 the worst case :)

-- 
All rights reversed
