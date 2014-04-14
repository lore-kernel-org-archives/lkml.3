Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaDNPLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:11:35 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:41097 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaDNPLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:11:30 -0400
Date: Mon, 14 Apr 2014 17:11:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff Levand <geoff@infradead.org>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
Message-ID: <20140414151125.GA27749@gmail.com>
References: <20140331071749.GA1252@gmail.com>
 <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
 <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
 <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
 <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
 <CAGdX0WE_xtUY7=CH7Qzxn9Oe8Mz=60wb6izD-APbF5d3caEthA@mail.gmail.com>
 <20140402074322.GA22744@gmail.com>
 <CAGdX0WHh3UqiCLbz+18_fj5s4PMpTfy638HA=LHpgLfVc2JpOg@mail.gmail.com>
 <20140404073616.GC1637@gmail.com>
 <CAGdX0WEkWq7hVnoffNaOEouDd17qr08EiPG2osF+DBPj4nZ-Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WEkWq7hVnoffNaOEouDd17qr08EiPG2osF+DBPj4nZ-Gg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> Obviously many people love ktap nowadays even though it's not a 
> C-family language, [...]

Imagine how much more widespread it would become amongst kernel 
developers if it had C syntax - see PeterZ's reply for example.

Thanks,

	Ingo
