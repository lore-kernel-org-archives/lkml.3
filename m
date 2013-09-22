Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3IVCDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 22:03:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57706 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab3IVCDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 22:03:46 -0400
Message-ID: <523E4F8A.7020708@zytor.com>
Date: Sat, 21 Sep 2013 19:01:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>  <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>  <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>  <20130920162603.GA30381@localhost.localdomain>  <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>  <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com> <1379799901.24090.6.camel@pasglop>
In-Reply-To: <1379799901.24090.6.camel@pasglop>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 02:45 PM, Benjamin Herrenschmidt wrote:
> 
> I really don't like the "larger" irq stack ... probably because I can't
> make it work easily :-) See my previous comment about how we get to
> thread_info on ppc.
> 

For the record, I intend to remove thread_info from the stack on x86 and
instead merge it with task_struct as a single structure pointed to with
a percpu variable.

	-hpa


