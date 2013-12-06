Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3LFB3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:29:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50978 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3LFB3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:29:39 -0500
Message-ID: <52A1285A.6090608@zytor.com>
Date: Thu, 05 Dec 2013 17:28:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>	<87fvq9cwlk.fsf@tassilo.jf.intel.com>	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>	<20131206001454.GB21717@two.firstfloor.org>	<52A12421.2040208@zytor.com> <871u1qwzae.fsf@tassilo.jf.intel.com>
In-Reply-To: <871u1qwzae.fsf@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 05:20 PM, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> Not to mention that in that case we might as well -- since we need a
>> compiler anyway -- generate the machine code in user space; the JIT
>> solution really only is useful if it can provide something that we can't
>> do otherwise, e.g. enable it in secure boot environments.
> 
> I can see there may be some setups which don't have a compiler
> (e.g. I know some people don't use systemtap because of that)
> But this needs a custom gcc install too as far as I understand.
> 

Yes... but no compiler and secure boot tend to go together, or at least
will in the future.

	-hpa

