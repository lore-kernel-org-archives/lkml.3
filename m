Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaDAUfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:35:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36386 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaDAUfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:35:19 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFzb0a2j9r3sFmczquDU8CBp4y8HhfJ7BwL57rpJ2fNwPA@mail.gmail.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com> <CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com> <20140331230347.GH32556@tassilo.jf.intel.com> <CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com> <CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com> <533B0B5F.2040907@linux.intel.com> <CA+55aFzb0a2j9r3sFmczquDU8CBp4y8HhfJ7BwL57rpJ2fNwPA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 01 Apr 2014 12:43:26 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Andi Kleen <ak@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <91ba1e94-20ae-40f9-a591-dd9d4f496aae@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be an easy fix through.

On April 1, 2014 12:15:05 PM PDT, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Tue, Apr 1, 2014 at 11:54 AM, H. Peter Anvin <hpa@linux.intel.com>
>wrote:
>>
>> Pretty much.  If nothing else, it breaks tracing.
>
>Good point. And those [rt_]sigreturn() system calls might actually be
>something you want to see in traces.
>
>Although clearly nobody has noticed the lack so far, so nobody must
>have cared all _that_ deeply about them so far ;)
>
>              Linus

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
