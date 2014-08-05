Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaHEViF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:38:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:25944 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753657AbaHEViD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:38:03 -0400
Date: Tue, 5 Aug 2014 17:37:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] ftrace: Add a ftrace test collection
Message-ID: <20140805173752.1de5f1c2@gandalf.local.home>
In-Reply-To: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
References: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

This looks great. I'm a bit busy at the moment (just came back from
vacation, and digging myself out of the hole that left me). But I
definitely want this in. I have a bunch of tests too, that I can put on
top of this. My tests are rather hacky, and hard code a lot of stuff in
them, but they do test a bunch of features of ftrace. It shouldn't be
too hard to include them here.


On Tue, 05 Aug 2014 02:45:44 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi,
> 
> I'd like to introduce a collection of testcases for ftrace to
> avoid regressions.
> 
> For a long time, we've tried to stabilize and extend ftrace
> tracing infrastructure. This small test framework is a kind of
> stabilizing work for ftrace. For the first step, this series
> just introduces a few basic testcases. However, it is easy to
> add additional tests. I'd like to ask you, ftrace developers,
> to add tests for your features to ensure it will not be broken
> by future works.
> 
> ftracetest is a tiny bash script so that anyone can easily
> understand what it does. I think it is better to share and
> discuss this tests before growing it.
> 
>  - Is it enough to support bash script? (of course you can
>    invoke other commands from the script)
>  - What's the good naming method of testcases?
>  - Is any dependency check required?
> 
> BTW, I decided to put this under tools/testing/ftrace instead
> of tools/testing/selftests/, because all tests requires root
> privilege. It will be one of discussion points. Anyway,
> it is easy to integrate this to the selftests.

I agree. I think having its own directory is a good idea. Lets see what
other people think. When I get time, I'll see if I can start a branch
that pulls this in and start adding my own tests on top of it.

Thanks!

-- Steve
