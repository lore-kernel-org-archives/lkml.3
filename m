Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3LFBUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:20:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:40894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab3LFBUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:20:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,837,1378882800"; 
   d="scan'208";a="447715108"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131206001454.GB21717@two.firstfloor.org>
	<52A12421.2040208@zytor.com>
Date: Thu, 05 Dec 2013 17:20:25 -0800
In-Reply-To: <52A12421.2040208@zytor.com> (H. Peter Anvin's message of "Thu,
	05 Dec 2013 17:10:57 -0800")
Message-ID: <871u1qwzae.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> Not to mention that in that case we might as well -- since we need a
> compiler anyway -- generate the machine code in user space; the JIT
> solution really only is useful if it can provide something that we can't
> do otherwise, e.g. enable it in secure boot environments.

I can see there may be some setups which don't have a compiler
(e.g. I know some people don't use systemtap because of that)
But this needs a custom gcc install too as far as I understand.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
