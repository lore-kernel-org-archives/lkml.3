Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaISOmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:42:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:12150 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756626AbaISOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:42:08 -0400
Date: Fri, 19 Sep 2014 10:42:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/4] ftracetest: Initial commit for ftracetest
Message-ID: <20140919104205.288cf493@gandalf.local.home>
In-Reply-To: <541C3823.4090203@osg.samsung.com>
References: <20140918120437.28308.72301.stgit@kbuild-f20.novalocal>
	<20140918120445.28308.57538.stgit@kbuild-f20.novalocal>
	<541AD905.6000700@osg.samsung.com>
	<541B80DE.1060902@hitachi.com>
	<541C3823.4090203@osg.samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 08:05:23 -0600
Shuah Khan <shuahkh@osg.samsung.com> wrote:


> I am not concerned about the spacing.
> 
> Thanks for doing running the make kselftest target and sharing
> the results. selftests don't get built or run in integ test
> rings. I am working on addressing this at the moment.
> 
> Steven!
> 
> Could you please take this through your tree. You have my
> 
> Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> for the selftests Makefile

OK, thanks!

I'll start trying to get my own personal tests working here.

It may take some work as my tests may run for 10s of minutes, as they
are more stress tests than a pass/fail thing. But I should have
something other people can use. I'll continue using both my own
personal tests as well as trying the new stuff that gets put here.

-- Steve

