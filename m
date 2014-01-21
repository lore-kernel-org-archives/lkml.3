Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaAUOV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:21:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35991 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbaAUOVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:21:23 -0500
Message-ID: <52DE8231.6080408@zytor.com>
Date: Tue, 21 Jan 2014 06:20:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com> <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com> <52DDAD9D.9030504@zytor.com> <20140121090003.GO31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140121090003.GO31570@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 01:00 AM, Peter Zijlstra wrote:
>>
>> So this is presumably something that needs to be fixed in perf?
> 
> Where do we learn about the offset from userspace?
> 

Now this is tricky... if this offset is too easy to get it completely
defeats kASLR.  On the other hand, I presume that if we are exporting
/proc/kcore we're not secure anyway.  Kees, I assume that in "secure"
mode perf annotations simply wouldn't work anyway?

	-hpa

