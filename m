Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbaCSQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:04:31 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50013 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140319152619.GB10406@linux.vnet.ibm.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 09:04:28 -0700
X-Google-Sender-Auth: 5mA742-7Ziv1ozucnGw96xWIE4Q
Message-ID: <CA+55aFxzDiCEUwVYye0w=sOFVQjMPMKJ6ee=L2sST8aQZ-55Zw@mail.gmail.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 8:26 AM, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
>
> I reverted b0c29f79ecea0b6fbcefc999e70f2843ae8306db on top of v3.14-rc6 and confirmed that
> reverting the commit solved the problem.

Ok. I'll give Peter and Davidlohr a few days to perhaps find something
obvious, but I guess we'll need to revert it from 3.14 and try again
later unless some fix comes up quickly..

Oh well.

             Linus
