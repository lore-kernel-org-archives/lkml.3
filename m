Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbaITRdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:33:37 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39464 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbaITRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:33:33 -0400
Message-ID: <541DBA65.60107@hitachi.com>
Date: Sun, 21 Sep 2014 02:33:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/4] ftracetest: Initial commit for ftracetest
References: <20140918120437.28308.72301.stgit@kbuild-f20.novalocal> <20140918120445.28308.57538.stgit@kbuild-f20.novalocal> <541AD905.6000700@osg.samsung.com> <541B80DE.1060902@hitachi.com> <541C3823.4090203@osg.samsung.com> <20140919104205.288cf493@gandalf.local.home>
In-Reply-To: <20140919104205.288cf493@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/19 23:42), Steven Rostedt wrote:
> On Fri, 19 Sep 2014 08:05:23 -0600
> Shuah Khan <shuahkh@osg.samsung.com> wrote:
> 
> 
>> I am not concerned about the spacing.
>>
>> Thanks for doing running the make kselftest target and sharing
>> the results. selftests don't get built or run in integ test
>> rings. I am working on addressing this at the moment.
>>
>> Steven!
>>
>> Could you please take this through your tree. You have my
>>
>> Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
>>
>> for the selftests Makefile
> 
> OK, thanks!
> 
> I'll start trying to get my own personal tests working here.

Great :)

> 
> It may take some work as my tests may run for 10s of minutes, as they
> are more stress tests than a pass/fail thing. But I should have
> something other people can use. I'll continue using both my own
> personal tests as well as trying the new stuff that gets put here.

I think you can also put your stress tests in the ftrace/ directory
(or just make a sub-directory for them). Even ftracetest doesn't
run them, we can update Makefile so that kselftest can run them.
For example, I will add a testcase for my IPMODFIY as a separated
test(ftrace/ipmodify), since it involves some special kernel modules
and doesn't use ftrace debugfs interface but tests ftrace(function trace).

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


