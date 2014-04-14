Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaDNP3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:29:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaDNP3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:29:03 -0400
Message-ID: <534BFE90.7070500@redhat.com>
Date: Mon, 14 Apr 2014 17:28:16 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff Levand <geoff@infradead.org>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
References: <20140331071749.GA1252@gmail.com> <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com> <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com> <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com> <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com> <CAGdX0WE_xtUY7=CH7Qzxn9Oe8Mz=60wb6izD-APbF5d3caEthA@mail.gmail.com> <20140402074322.GA22744@gmail.com> <CAGdX0WHh3UqiCLbz+18_fj5s4PMpTfy638HA=LHpgLfVc2JpOg@mail.gmail.com> <20140404073616.GC1637@gmail.com> <CAGdX0WEkWq7hVnoffNaOEouDd17qr08EiPG2osF+DBPj4nZ-Gg@mail.gmail.com> <20140414151125.GA27749@gmail.com>
In-Reply-To: <20140414151125.GA27749@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 05:11 PM, Ingo Molnar wrote:
> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>
>> Obviously many people love ktap nowadays even though it's not a
>> C-family language, [...]
>
> Imagine how much more widespread it would become amongst kernel
> developers if it had C syntax - see PeterZ's reply for example.

+1

I think it would be awesome to reuse the kernel's BPF engine
with its C backend for this in the way that Alexei has started
in its original set; surely there's a lot of work that still
needs to be addressed, but it would allow long-term for just
having that engine to maintain, and also to exploit its
flexibility and speed (JIT) where we can.
