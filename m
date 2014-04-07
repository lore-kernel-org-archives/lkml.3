Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaDGNzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:55:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGNzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:55:46 -0400
Date: Mon, 7 Apr 2014 15:55:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff.Levand@huawei.com
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
Message-ID: <20140407135519.GJ10526@twins.programming.kicks-ass.net>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <20140331071749.GA1252@gmail.com>
 <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
 <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
 <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
 <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
 <20140402074202.GB22680@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402074202.GB22680@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 09:42:03AM +0200, Ingo Molnar wrote:
> I'd suggest using C syntax instead initially, because that's what the 
> kernel is using.
> 
> The overwhelming majority of people probing the kernel are 
> programmers, so there's no point in inventing new syntax, we should 
> reuse existing syntax!

Yes please, keep it C, I forever forget all other syntaxes. While I have
in the past known other languages, I never use them frequently enough to
remember them. And there's nothing more frustrating than having to fight
a tool/language when you just want to get work done.
