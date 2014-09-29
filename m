Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaI2Kda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:33:30 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37987 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaI2Kd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:33:29 -0400
Message-ID: <54293572.9010108@hitachi.com>
Date: Mon, 29 Sep 2014 19:33:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home> <5422336A.6030304@hitachi.com> <20140924114235.4287f4a1@gandalf.local.home> <20140924115811.6eeeab8c@gandalf.local.home> <5422EAE2.6080005@osg.samsung.com> <20140924120853.0a717b7e@gandalf.local.home> <5422EFB4.2050104@osg.samsung.com> <20140924123007.7fcb0099@gandalf.local.home> <5422F328.2040707@osg.samsung.com> <5425564A.4020107@hitachi.com> <20140926101840.7d495620@gandalf.local.home>
In-Reply-To: <20140926101840.7d495620@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/26 23:18), Steven Rostedt wrote:
> On Fri, 26 Sep 2014 21:04:26 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>>> Please go ahead and get them in. The framework might have to wait
>>> until 3.19, so there is no need to have it gate test development.
>>> We can evolve them as we go. If tests require special, it means that
>>> they aren't suitable for certain envs such as qemu boot with busybox.
>>> There is a plan to add test targets to cover such cases.
>>
>> Agreed, anyway, in some env those tools(commands) may not supported
>> by busybox because of the memory size etc. In that case, we can just
>> mark the test unsupported or xfail.
>>
> 
> Note, if memory size is such a big issue it that other tools may not be
> there, then most of the ftrace features will probably be disabled due
> to memory constraints on the kernel itself.

Agreed :)

> 
> As we have a way to state "unsupported" we can just return that from
> tests that require tools not available, and say why it is the case.

OK, if we can count "unsupported" as a test failure (yes, it is
unexpectedly failed), it is easy to fix. I'll update XFAIL and
other error code support patch and send it.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


