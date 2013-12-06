Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab3LFVoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:44:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3LFVoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:44:15 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexei Starovoitov <ast@plumgrid.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
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
	<52A12421.2040208@zytor.com> <871u1qwzae.fsf@tassilo.jf.intel.com>
	<52A1285A.6090608@zytor.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 06 Dec 2013 16:43:31 -0500
In-Reply-To: <52A1285A.6090608@zytor.com> (H. Peter Anvin's message of "Thu, 05 Dec 2013 17:28:58 -0800")
Message-ID: <y0mmwkdr6yk.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hpa wrote:

>> I can see there may be some setups which don't have a compiler
>> (e.g. I know some people don't use systemtap because of that)
>> But this needs a custom gcc install too as far as I understand.
>
> Yes... but no compiler and secure boot tend to go together, or at
> least will in the future.

(Maybe not: we're already experimenting with support for secureboot in
systemtap.)

- FChE
