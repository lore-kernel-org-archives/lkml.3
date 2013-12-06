Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3LFBL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:11:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50848 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3LFBL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:11:57 -0500
Message-ID: <52A12421.2040208@zytor.com>
Date: Thu, 05 Dec 2013 17:10:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Alexei Starovoitov <ast@plumgrid.com>
CC: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <87fvq9cwlk.fsf@tassilo.jf.intel.com> <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com> <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com> <20131206001454.GB21717@two.firstfloor.org>
In-Reply-To: <20131206001454.GB21717@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 04:14 PM, Andi Kleen wrote:
> 
> In my experience there are roughly two groups of trace users:
> kernel hackers and users. The kernel hackers want something
> convenient and fast, but for anything complicated or performance
> critical they can always hack the kernel to include custom 
> instrumentation.
> 

Not to mention that in that case we might as well -- since we need a
compiler anyway -- generate the machine code in user space; the JIT
solution really only is useful if it can provide something that we can't
do otherwise, e.g. enable it in secure boot environments.

	-hpa

