Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3AZVGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:06:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54702 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab3AZVGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:06:36 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1359234167.17639.3.camel@gandalf.local.home>
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com> <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org> <20130126125208.GC21395@pd.tnic> <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com> <CA+55aFyskO6NMhgkwRNv4wXB=D97VS54_oZw0k_o4nQFso6p-Q@mail.gmail.com> <1359234167.17639.3.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on CONFIG_CC_OPTIMIZE_FOR_SIZE= y in the 64-bit defconfig
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2013 13:04:40 -0800
To: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jan Beulich <jbeulich@suse.com>, ling.ml@alipay.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Message-ID: <bc2bf9ae-5e4b-47ba-bb3b-172cd6e124f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have discussed -Ok(ernel) with the gcc guys in earnest.  They are receptive but lack the round tuits.

Steven Rostedt <rostedt@goodmis.org> wrote:

>On Sat, 2013-01-26 at 11:43 -0800, Linus Torvalds wrote:
>
>> The problem, of course, is that most -O2 code generation is done
>> assuming hot loops that don't show much if any I$ issues. And the -Os
>> thing is done *purely* for size, not taking any performance into
>> account at all. There's no balanced middle ground, which is what _we_
>> would want.
>
>Gcc needs to implement a -Olinus
>
>;-)
>
>-- Steve

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
