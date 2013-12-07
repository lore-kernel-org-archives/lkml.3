Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3LGBNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:13:25 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35251 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3LGBM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:12:57 -0500
MIME-Version: 1.0
In-Reply-To: <871u1qwzae.fsf@tassilo.jf.intel.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131206001454.GB21717@two.firstfloor.org>
	<52A12421.2040208@zytor.com>
	<871u1qwzae.fsf@tassilo.jf.intel.com>
Date: Fri, 6 Dec 2013 17:12:56 -0800
Message-ID: <CAMEtUuyBRTsP59+g_qCxxFs=dzP+1ZJwBv+4=znxkJcyi3RBRA@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 5:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
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

fyi custom gcc is a single 13M binary. It doesn't depend on any
include files or any libraries.
and can be easily packaged together with perf... even for embedded environment.
