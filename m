Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaIZGG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:06:57 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44933 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaIZGG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:06:56 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home>
	<5422336A.6030304@hitachi.com>
	<20140924114235.4287f4a1@gandalf.local.home>
	<20140924115811.6eeeab8c@gandalf.local.home>
	<5422EAE2.6080005@osg.samsung.com>
	<20140924120853.0a717b7e@gandalf.local.home>
Date: Fri, 26 Sep 2014 15:06:51 +0900
In-Reply-To: <20140924120853.0a717b7e@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 24 Sep 2014 12:08:53 -0400")
Message-ID: <877g0qkj9g.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, 24 Sep 2014 12:08:53 -0400, Steven Rostedt wrote:
> On Wed, 24 Sep 2014 10:01:38 -0600
> Shuah Khan <shuahkh@osg.samsung.com> wrote:
>
>> I am working on adding the framework for c tests. We will have
>> to get this evolved for shell scripts. Please see the following
>> thread:
>> 
>> https://lkml.org/lkml/2014/9/23/926
>> 
>
> Thanks,
>
> Also, what's the rules for a test that requires other tools. Some of my
> tests require trace-cmd to be installed as well as perf. My stress test
> runs perf against trace-cmd running hackbench (another required tool),
> but I believe that perf has hackbench built in so I could replace
> hackbench with the perf version.

Yeah, and I think we can at least build perf (if not found) for test as
we can always have the source.  The trace-cmd is different and it'd be
another reason I need to work on 'perf ftrace' command soon.  ;-)

Thanks,
Namhyung
