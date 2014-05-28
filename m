Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaE1W3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:29:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:40984 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbaE1W3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:29:51 -0400
Date: Thu, 29 May 2014 00:29:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>,
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
In-Reply-To: <CA+55aFx9d1dP+A3tdR-GaASQYBkkJHcV-=t9FdA7AGrMN12S0w@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1405290025450.3952@nanos>
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <53865B53.7050809@redhat.com> <CA+55aFx9d1dP+A3tdR-GaASQYBkkJHcV-=t9FdA7AGrMN12S0w@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Linus Torvalds wrote:
> 
> If somebody has a P4 still, that's likely the worst case by far.

I do, but I'm only using it during winter and only if the ia64 machine
does not provide sufficient heating. So you have to wait at least half
a year until I'm able to test it.
