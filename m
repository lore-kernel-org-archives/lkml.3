Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaDBHhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:37:03 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38733 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbaDBHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:37:00 -0400
Date: Wed, 2 Apr 2014 09:36:55 +0200
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
        Geoff.Levand@huawei.com
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
Message-ID: <20140402073655.GA22680@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <20140331071749.GA1252@gmail.com>
 <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
 <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
 <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> > I think nothing stops ktap userspace to parse ktap language and 
> > generate 'internal bpf' format. gcc is unnecessary here.
> 
> It's a big engineering problem, [...]

Sorry, but it will become an even bigger engineering problem if it's 
merged to the upstream kernel tree!

You need to solve known design and implementational issues before we 
can even think about any upstream merge.

Thanks,

	Ingo
