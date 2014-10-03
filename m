Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJCUxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:53:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:8271 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750AbaJCUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:53:46 -0400
Date: Fri, 3 Oct 2014 16:53:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (ltc-kernel 10162) Re: [PATCH ftrace/for-next v6] ftracetest:
 Add POSIX.3 standard and XFAIL result codes
Message-ID: <20141003165337.21043dee@gandalf.local.home>
In-Reply-To: <542E8888.9090703@hitachi.com>
References: <20140929120211.30203.99510.stgit@kbuild-f20.novalocal>
	<54294C55.3030204@hitachi.com>
	<542E8888.9090703@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Oct 2014 20:29:12 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Ping? :)

Just to make sure. This is just the one patch that I missed before,
right?

I pulled it and now testing it (running the tests). I'll push it to my
linux-next branch sometime later today. You'll probably see it as you
wake up ;-)

-- Steve

> 
> (2014/09/29 21:11), Masami Hiramatsu wrote:
> > Steven, could you pick this instead of old v5 patch?
> > 
> > As you pointed, this version shows the log of "unsuppoted" test result.
> > 
> > Thank you,
> > 
> > (2014/09/29 21:02), Masami Hiramatsu wrote:
> >> Add XFAIL and POSIX 1003.3 standard codes (UNRESOLVED/
> >> UNTESTED/UNSUPPORTED) as result codes. These are used for the
> >> results that test case is expected to fail or unsupported
> >> feature (by config).
> >>
> >> To return these result code, this introduces exit_unresolved,
> >> exit_untested, exit_unsupported and exit_xfail functions,
> >> which use real-time signals to notify the result code to
> >> ftracetest.
> >>
> >> This also set "errexit" option for the testcases, so that
> >> the tests don't need to exit explicitly.
> >>
> >> Note that if the test returns UNRESOLVED/UNSUPPORTED/FAIL,
> >> its test log including executed commands is shown on console
> >> and main logfile as below.
