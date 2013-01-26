Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3AZVCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:02:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28475 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3AZVCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:02:51 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nLi3k7kJnfEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=QwhylRht5LkA:10 a=j8WDfRiXRuDn6mvebhcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359234167.17639.3.camel@gandalf.local.home>
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on
 CONFIG_CC_OPTIMIZE_FOR_SIZE= y in the 64-bit defconfig
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jan Beulich <jbeulich@suse.com>, ling.ml@alipay.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Date: Sat, 26 Jan 2013 16:02:47 -0500
In-Reply-To: <CA+55aFyskO6NMhgkwRNv4wXB=D97VS54_oZw0k_o4nQFso6p-Q@mail.gmail.com>
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
	 <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org>
	 <20130126125208.GC21395@pd.tnic>
	 <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com>
	 <CA+55aFyskO6NMhgkwRNv4wXB=D97VS54_oZw0k_o4nQFso6p-Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-26 at 11:43 -0800, Linus Torvalds wrote:

> The problem, of course, is that most -O2 code generation is done
> assuming hot loops that don't show much if any I$ issues. And the -Os
> thing is done *purely* for size, not taking any performance into
> account at all. There's no balanced middle ground, which is what _we_
> would want.

Gcc needs to implement a -Olinus

;-)

-- Steve


