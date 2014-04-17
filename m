Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbaDQIyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:54:01 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50061 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbaDQIxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:53:54 -0400
Message-ID: <534F969A.9060802@hitachi.com>
Date: Thu, 17 Apr 2014 17:53:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v9 00/26] kprobes: introduce NOKPROBE_SYMBOL, bugfixes
 and scalbility efforts
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140417083716.GC30944@gmail.com>
In-Reply-To: <20140417083716.GC30944@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/17 17:37), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Masami Hiramatsu (26):
>>       [BUGFIX]kprobes/x86: Fix page-fault handling logic
>>       kprobes/x86: Allow to handle reentered kprobe on singlestepping
>>       kprobes: Prohibit probing on .entry.text code
>>       kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
>>       [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
>>       [BUGFIX] x86: Prohibit probing on native_set_debugreg/load_idt
>>       [BUGFIX] x86: Prohibit probing on thunk functions and restore
> 
> Ok, the whole series is looking pretty good now.
> 
> Can I apply the 4 bugfixes first, or do the last 3 bugfixes depend on 
> the 3 non-bugfixes patches before them in any way?

Right, the last 3 bugfixes depends on NOKPROBE_SYMBOL(), so you can
apply only the first patch...

Thank you,

> 
> Thanks,
> 
> 	Ingo
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


