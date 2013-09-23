Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3IWQrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:47:13 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46491 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3IWQrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:47:12 -0400
MIME-Version: 1.0
In-Reply-To: <1379910958.6625.3.camel@pasglop>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	<CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	<alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	<20130920162603.GA30381@localhost.localdomain>
	<CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	<CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	<1379799901.24090.6.camel@pasglop>
	<523E4F8A.7020708@zytor.com>
	<1379824754.24090.11.camel@pasglop>
	<1379824861.24090.12.camel@pasglop>
	<20130922162410.GA10649@laptop.programming.kicks-ass.net>
	<1379887000.24090.19.camel@pasglop>
	<CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	<1379889489.24090.34.camel@pasglop>
	<1379910958.6625.3.camel@pasglop>
Date: Mon, 23 Sep 2013 09:47:11 -0700
X-Google-Sender-Auth: HAYUEcSAwngR4YcCDoNw6B0_pCM
Message-ID: <CA+55aFwcPU+fAqDGp0QhSYip7MYPBB+kQiU4GHEdgMo82i7RVg@mail.gmail.com>
Subject: Re: [PATCH] powerpc/irq: Run softirqs off the top of the irq stack
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 9:35 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> This is the "band aid" discussed so far for the stack overflow
> problem for powerpc.

I don't think it's a "band-aid" in any way, except perhaps in the
sense that there are certainly other things we can also do in this
series (ie I liked Frederic's cleanups etc).

                     Linus
