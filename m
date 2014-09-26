Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaIZOHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:07:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23186 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755211AbaIZOHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:07:13 -0400
Date: Fri, 26 Sep 2014 10:07:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
Message-ID: <20140926100703.7177ba29@gandalf.local.home>
In-Reply-To: <877g0qkj9g.fsf@sejong.aot.lge.com>
References: <20140923173846.603cb49c@gandalf.local.home>
	<5422336A.6030304@hitachi.com>
	<20140924114235.4287f4a1@gandalf.local.home>
	<20140924115811.6eeeab8c@gandalf.local.home>
	<5422EAE2.6080005@osg.samsung.com>
	<20140924120853.0a717b7e@gandalf.local.home>
	<877g0qkj9g.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 15:06:51 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> Yeah, and I think we can at least build perf (if not found) for test as
> we can always have the source.  The trace-cmd is different and it'd be
> another reason I need to work on 'perf ftrace' command soon.  ;-)

Well, if a tool is not found. I wouldn't recommend building it. Either
case, I'll hold off test that is required.

Hmm, maybe I'll post all my tests on my website, for others to play
with. That way I'm not limited in tests that take too much time or use
tools not supported by the kernel selftest infrastructure.

-- Steve
