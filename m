Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaJCMOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:14:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:64235 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751420AbaJCMOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:14:32 -0400
Date: Fri, 3 Oct 2014 08:14:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (ltc-kernel 10162) Re: [PATCH ftrace/for-next v6] ftracetest:
 Add POSIX.3 standard and XFAIL result codes
Message-ID: <20141003081417.4116540d@gandalf.local.home>
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

Haven't forgotten you. It's still a top priority. I was working on
something else and hit a bug that's in mainline with the ring buffer.
It's a hard to hit race and it took a while to bisect, but I finally
found the cause and have the fix. Luckily it was only introduced in
3.17-rc1. This took priority, but I'm almost done with it.

Your stuff is next on the TODO list.

-- Steve


> 
> (2014/09/29 21:11), Masami Hiramatsu wrote:
> > Steven, could you pick this instead of old v5 patch?
> > 
> > As you pointed, this version shows the log of "unsuppoted" test result.
> > 
> > Thank you,

