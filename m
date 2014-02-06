Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaBFPTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:19:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7694 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751224AbaBFPTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:19:40 -0500
Date: Thu, 6 Feb 2014 10:18:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        jovi.zhangwei@huawei.com, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: [PATCHSET 0/5] tracing/uprobes: Support multi buffer and event
 trigger
Message-ID: <20140206101844.2e355469@gandalf.local.home>
In-Reply-To: <877g9a316i.fsf@sejong.aot.lge.com>
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
	<87mwi83hvf.fsf@sejong.aot.lge.com>
	<20140203205828.4e5b1592@gandalf.local.home>
	<877g9a316i.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Feb 2014 08:31:17 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> >
> > Currently, I'm working on some bugs at work as well as some things I
> > found in mainline. I'll be reviewing these when I get a chance.
> 
> Great, thanks!

Just an update. I looked at them and ran them though some minor tests
(nothing major yet) and they seem fine. I've added them to the end of
my 3.15 queue, but I wont be posting those patches to linux-next until
after 3.14-rc2, where I'll rebase that work on.

Hopefully 3.14-rc2 will not introduce more bugs and have all the fixes
of 3.14-rc1 requires. Makes testing my code easier, instead of having
to keep adding "fixup" patches that fix other people's code in order to
get my tests working.

-- Steve

