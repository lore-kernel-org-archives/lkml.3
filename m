Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaIWNgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:36:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:37107 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751860AbaIWNgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:36:13 -0400
Date: Tue, 23 Sep 2014 09:36:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/4] ftracetest: Initial commit for ftracetest
Message-ID: <20140923093610.4f404274@gandalf.local.home>
In-Reply-To: <20140922234250.23415.68758.stgit@kbuild-f20.novalocal>
References: <20140922234248.23415.36560.stgit@kbuild-f20.novalocal>
	<20140922234250.23415.68758.stgit@kbuild-f20.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For future reference:

On Mon, 22 Sep 2014 23:42:50 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> ftracetest is a collection of testcase shell-scripts for ftrace.
> To avoid regressions of ftrace, these testcases check correct
> ftrace behaviors. If someone would like to add any features on
> ftrace, the patch series should have at least one testcase for
> checking the new behavior.
> 
> Changes in v5:
>  - Fix a TODO item, since this already integrated to kselftest.
>  - Print the test name at the first line.
> 
> Changes in v4:
>  - Move this under selftests. :)
>  - Add a copyright and note of GPLv2.
>  - Fix documents acconding to Steven's comments.
>  - Fix a small bug pointed by Namhyng.
> 
> Changes in v3:
>  - Use "." instead of "source".
>  - Don't use -e option for echo since dash doesn't support it.
> 
> Changes in v2:
>  - Remove unneeded 'function' keyword.
>  - Add abspath and find_testcases.
>  - Make OPT_TEST_CASES a local var.
>  - Ensure given testcase ended with .tc.
>  - Accept a directory option which has multiple testcases.
>  - Change [PASSED]/[FAILED] to [PASS]/[FAIL]
>  - Change the basic shell to sh (dash).

Place the version changes after the '---'. They are great for patch
series, but we prefer not to have them in the git logs. The "Link:" tag
should allow people to find the version history of patches if they are
interested. By placing the version updates after the '---', git will
ignore them when pulling them in.

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---

Also, please have the Signed-off-by be the last tag, otherwise it
screws up my scripts ;-)

-- Steve
