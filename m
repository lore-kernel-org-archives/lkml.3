Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab3E3UOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:14:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:35114 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3E3UOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:14:31 -0400
Date: Thu, 30 May 2013 22:14:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: Preemptable Ticket Spinlock
In-Reply-To: <51A73E5C.4010608@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1305302210120.2905@ionos>
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop> <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop> <5175E71F.8070307@linux.vnet.ibm.com>
 <51A73E5C.4010608@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Raghavendra K T wrote:
> Here is the branch with pvpspinlock V9 version in github reabsed to  3.10-rc
> 
> https://github.com/ktraghavendra/linux/tree/pvspinlock_v9
> 
> planning post a formal email in a separate thread with link a to this
> branch (instead of spamming with 19 patches)

19 patches is not really spam if you compare it to the total number of
mails per day on LKML. 

The git tree is nice for people who want to test stuff easily, but if
you want people to review and comment patches, then please use mail.

Thanks,

	tglx
