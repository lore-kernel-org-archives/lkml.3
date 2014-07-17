Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaGQLlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:41:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51249 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaGQLlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:41:06 -0400
Message-ID: <53C7B649.1070004@hitachi.com>
Date: Thu, 17 Jul 2014 20:40:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, sparse@chrisli.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        akataria@vmware.com, linux-tip-commits@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, anil.s.keshavamurthy@intel.com,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, rdunlap@infradead.org,
        Tony Luck <tony.luck@gmail.com>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [RESEND PATCH v5] [BUGFIX] kprobes: Fix "Failed to find
 blacklist" error on ia64 and ppc64
References: <20140717071121.3130.86341.stgit@kbuild-fedora.novalocal> <20140717093832.GB4232@gmail.com> <53C7B0E6.1050503@hitachi.com>
In-Reply-To: <53C7B0E6.1050503@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/17 20:17), Masami Hiramatsu wrote:
> (2014/07/17 18:38), Ingo Molnar wrote:
>>
>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>
>>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
>>
>> Looks good, but this is not a valid SOB sequence: if Suzuki wrote the 
>> patch then he should be the first SOB (and should have a From line as 
>> well), if he acked it along the way then it should be an Acked-by - or 
>> Reviewed-by.
> 
> Ah, OK, so I'll add his name as Fixed-by:.

Oops, I also found that an old comment in the patch description
and unneeded "include". I'll fix and send that asap.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


