Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaGQHKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:10:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33063 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaGQHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:10:46 -0400
Message-ID: <53C776ED.3050001@hitachi.com>
Date: Thu, 17 Jul 2014 16:10:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-tip-commits@vger.kernel.org, akataria@vmware.com,
        anil.s.keshavamurthy@intel.com,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: Re: [PATCH v5 2/2] [BUGFIX] kprobes: Fix "Failed to find
 blacklist" error on ia64 and ppc64
References: <1404276081.7254.1.camel@concordia> <20140702070029.14689.18485.stgit@kbuild-fedora.novalocal> <1405394370.17767.7.camel@concordia> <1405408602.9343.75.camel@pasglop> <53C4FDC8.9050801@hitachi.com> <20140716132838.GA18597@gmail.com>
In-Reply-To: <20140716132838.GA18597@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/16 22:28), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2014/07/15 16:16), Benjamin Herrenschmidt wrote:
>>> On Tue, 2014-07-15 at 13:19 +1000, Michael Ellerman wrote:
>>>
>>>>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>>>> Reported-by: Tony Luck <tony.luck@gmail.com>
>>>>> Tested-by: Tony Luck <tony.luck@intel.com>
>>>>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>>>>
>>>> Tested-by: Michael Ellerman <mpe@ellerman.id.au>
>>>> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (for powerpc)
>>>>
>>>> Ben, can you take this in your tree?
>>>
>>> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>>
>>> That looks more like generic material. Do we have a kprobes maintainer ?
>>> Andrew, do you want to take this ?
>>
>> Yeah, I usually use Ingo's tip tree for kprobes maintenance.
>> Ingo, could you pull this as urgent-for-linus patch?
> 
> Mind resending it in a separate thread with all acks added, etc?

OK, I'll resend that soon.
BTW, I missed Suzuki's Signed-off-by in this version,
I'd like to recover that since he made a big bugfix on this.

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


