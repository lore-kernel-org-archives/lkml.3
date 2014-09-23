Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaIWAcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:32:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55355 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaIWAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:32:41 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/4] ftrace: Add a ftrace test collection
References: <20140922234248.23415.36560.stgit@kbuild-f20.novalocal>
Date: Tue, 23 Sep 2014 09:32:38 +0900
In-Reply-To: <20140922234248.23415.36560.stgit@kbuild-f20.novalocal> (Masami
	Hiramatsu's message of "Mon, 22 Sep 2014 23:42:48 +0000")
Message-ID: <87h9zzkwgp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 23:42:48 +0000, Masami Hiramatsu wrote:
> Hi,
>
> Here is the collection of testcases for ftrace version 5.
> This is just a small update.
>
>   - Fix a TODO item, since this already integrated to kselftest.
>   - Print the test name at the first line.
>   - Add Shuah's acked-by. (Thanks!)
>
> ftracetest is a shell(dash) script for testing ftrace features.
> It will be required to add a unit test for each new feature
> after this is merged, because of preventing regressions.

If I'm not too late.. :)

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>
> ---
>
> Masami Hiramatsu (4):
>       ftracetest: Initial commit for ftracetest
>       ftracetest: Add ftrace basic testcases
>       ftracetest: Add kprobe basic testcases
>       ftracetest: Add POSIX.3 standard and XFAIL result codes
>
>
>  MAINTAINERS                                        |    1 
>  tools/testing/selftests/Makefile                   |    1 
>  tools/testing/selftests/ftrace/Makefile            |    7 +
>  tools/testing/selftests/ftrace/README              |   82 +++++++
>  tools/testing/selftests/ftrace/ftracetest          |  251 ++++++++++++++++++++
>  tools/testing/selftests/ftrace/samples/fail.tc     |    4 
>  tools/testing/selftests/ftrace/samples/pass.tc     |    3 
>  .../testing/selftests/ftrace/samples/unresolved.tc |    4 
>  .../selftests/ftrace/samples/unsupported.tc        |    3 
>  tools/testing/selftests/ftrace/samples/untested.tc |    3 
>  tools/testing/selftests/ftrace/samples/xfail.tc    |    3 
>  .../selftests/ftrace/test.d/00basic/basic1.tc      |    3 
>  .../selftests/ftrace/test.d/00basic/basic2.tc      |    7 +
>  .../selftests/ftrace/test.d/00basic/basic3.tc      |    8 +
>  .../ftrace/test.d/kprobe/add_and_remove.tc         |   11 +
>  .../selftests/ftrace/test.d/kprobe/busy_check.tc   |   13 +
>  tools/testing/selftests/ftrace/test.d/template     |    9 +
>  17 files changed, 413 insertions(+)
>  create mode 100644 tools/testing/selftests/ftrace/Makefile
>  create mode 100644 tools/testing/selftests/ftrace/README
>  create mode 100755 tools/testing/selftests/ftrace/ftracetest
>  create mode 100644 tools/testing/selftests/ftrace/samples/fail.tc
>  create mode 100644 tools/testing/selftests/ftrace/samples/pass.tc
>  create mode 100644 tools/testing/selftests/ftrace/samples/unresolved.tc
>  create mode 100644 tools/testing/selftests/ftrace/samples/unsupported.tc
>  create mode 100644 tools/testing/selftests/ftrace/samples/untested.tc
>  create mode 100644 tools/testing/selftests/ftrace/samples/xfail.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic1.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/template
>
> --
