Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaDQIhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:37:25 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64259 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaDQIhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:37:22 -0400
Date: Thu, 17 Apr 2014 10:37:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v9 00/26] kprobes: introduce NOKPROBE_SYMBOL,
 bugfixes and scalbility efforts
Message-ID: <20140417083716.GC30944@gmail.com>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Masami Hiramatsu (26):
>       [BUGFIX]kprobes/x86: Fix page-fault handling logic
>       kprobes/x86: Allow to handle reentered kprobe on singlestepping
>       kprobes: Prohibit probing on .entry.text code
>       kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
>       [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
>       [BUGFIX] x86: Prohibit probing on native_set_debugreg/load_idt
>       [BUGFIX] x86: Prohibit probing on thunk functions and restore

Ok, the whole series is looking pretty good now.

Can I apply the 4 bugfixes first, or do the last 3 bugfixes depend on 
the 3 non-bugfixes patches before them in any way?

Thanks,

	Ingo
