Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbaDHHkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:40:45 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54942 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaDHHko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:40:44 -0400
Message-ID: <5343A7F4.80702@hitachi.com>
Date: Tue, 08 Apr 2014 16:40:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Alexei Starovoitov <ast@plumgrid.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff.Levand@huawei.com
Subject: Re: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing
 tool for Linux
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com> <20140331071749.GA1252@gmail.com> <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com> <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com> <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com> <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com> <20140402074202.GB22680@gmail.com> <20140407135519.GJ10526@twins.programming.kicks-ass.net>
In-Reply-To: <20140407135519.GJ10526@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/07 22:55), Peter Zijlstra wrote:
> On Wed, Apr 02, 2014 at 09:42:03AM +0200, Ingo Molnar wrote:
>> I'd suggest using C syntax instead initially, because that's what the 
>> kernel is using.
>>
>> The overwhelming majority of people probing the kernel are 
>> programmers, so there's no point in inventing new syntax, we should 
>> reuse existing syntax!
> 
> Yes please, keep it C, I forever forget all other syntaxes. While I have
> in the past known other languages, I never use them frequently enough to
> remember them. And there's nothing more frustrating than having to fight
> a tool/language when you just want to get work done.

Why wouldn't you write a kernel module in C directly? :)
It seems that all what you need is not a tracing language nor a bytecode
engine, but an well organized tracing APIs(library?) for writing a kernel
module for tracing...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


