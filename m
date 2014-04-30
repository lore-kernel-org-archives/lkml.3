Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaD3IYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:24:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:47843 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaD3IYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:24:12 -0400
Date: Wed, 30 Apr 2014 10:24:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        peterz@infradead.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.15-rc3] rtmutex-debug assertion.
In-Reply-To: <1398824670.2522.19.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1404301023140.6261@ionos.tec.linutronix.de>
References: <20140429151655.GA14277@redhat.com>  <20140430001432.GA32142@redhat.com> <1398824670.2522.19.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Davidlohr Bueso wrote:
> On Tue, 2014-04-29 at 20:14 -0400, Dave Jones wrote:
> > 
> > futex(uaddr=0x7f55ff8c4000, op=0x6, val=0x200000006223800b, utime=0x7f55ff8c4000, uaddr2=0x7f55ff8c4000, val3=-123)
> 
> Perhaps because of chance. Even for pi futexes, if the lock is
> uncontended, the kernel will never take part.

Well, that's a syscall fuzzer. It feeds the kernel random crap.
 
