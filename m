Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaIXQI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:08:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:16882 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752747AbaIXQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:08:56 -0400
Date: Wed, 24 Sep 2014 12:08:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
Message-ID: <20140924120853.0a717b7e@gandalf.local.home>
In-Reply-To: <5422EAE2.6080005@osg.samsung.com>
References: <20140923173846.603cb49c@gandalf.local.home>
	<5422336A.6030304@hitachi.com>
	<20140924114235.4287f4a1@gandalf.local.home>
	<20140924115811.6eeeab8c@gandalf.local.home>
	<5422EAE2.6080005@osg.samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 10:01:38 -0600
Shuah Khan <shuahkh@osg.samsung.com> wrote:

> I am working on adding the framework for c tests. We will have
> to get this evolved for shell scripts. Please see the following
> thread:
> 
> https://lkml.org/lkml/2014/9/23/926
> 

Thanks,

Also, what's the rules for a test that requires other tools. Some of my
tests require trace-cmd to be installed as well as perf. My stress test
runs perf against trace-cmd running hackbench (another required tool),
but I believe that perf has hackbench built in so I could replace
hackbench with the perf version.

-- Steve
