Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaHMPyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:54:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44178 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaHMPyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:54:49 -0400
Message-ID: <53EB8A41.4010909@hitachi.com>
Date: Thu, 14 Aug 2014 00:54:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] ftrace: Add a ftrace test collection
References: <20140805024544.23693.66601.stgit@kbuild-fedora.novalocal> <20140805173752.1de5f1c2@gandalf.local.home> <8738d0euyv.fsf@sejong.aot.lge.com>
In-Reply-To: <8738d0euyv.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/13 15:59), Namhyung Kim wrote:
> Hi Steve and Masami,
> 
> On Tue, 5 Aug 2014 17:37:52 -0400, Steven Rostedt wrote:
>> Hi Masami,
>>
>> This looks great. I'm a bit busy at the moment (just came back from
>> vacation, and digging myself out of the hole that left me). But I
>> definitely want this in. I have a bunch of tests too, that I can put on
>> top of this. My tests are rather hacky, and hard code a lot of stuff in
>> them, but they do test a bunch of features of ftrace. It shouldn't be
>> too hard to include them here.
>>
>>
>> On Tue, 05 Aug 2014 02:45:44 +0000
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>
>>> Hi,
>>>
>>> I'd like to introduce a collection of testcases for ftrace to
>>> avoid regressions.
>>>
>>> For a long time, we've tried to stabilize and extend ftrace
>>> tracing infrastructure. This small test framework is a kind of
>>> stabilizing work for ftrace. For the first step, this series
>>> just introduces a few basic testcases. However, it is easy to
>>> add additional tests. I'd like to ask you, ftrace developers,
>>> to add tests for your features to ensure it will not be broken
>>> by future works.
>>>
>>> ftracetest is a tiny bash script so that anyone can easily
>>> understand what it does. I think it is better to share and
>>> discuss this tests before growing it.
>>>
>>>  - Is it enough to support bash script? (of course you can
>>>    invoke other commands from the script)
> 
> Btw, does it use any bash-specific feature?

Not much ("function" keyword is possible bashism). I usually
use bash and sometimes unintentionally use bash-specific features :)
Anyway, I guess bash is enough common now and sometimes its extensions
are good for short scripting.

>>>  - What's the good naming method of testcases?
> 
> I'm okay with the ftracetest, but tracing-test may be an option. :)

Ah, as you said, I meant its extensions *.tc.  :)

>>>  - Is any dependency check required?
> 
> I think we need to start from no/minimum external dependency.
> 
> 
>>>
>>> BTW, I decided to put this under tools/testing/ftrace instead
>>> of tools/testing/selftests/, because all tests requires root
>>> privilege. It will be one of discussion points. Anyway,
>>> it is easy to integrate this to the selftests.
>>
>> I agree. I think having its own directory is a good idea. Lets see what
>> other people think. When I get time, I'll see if I can start a branch
>> that pulls this in and start adding my own tests on top of it.
> 
> I also agree to have a separate directory and it's not a selftest :)
> 
> Steve, I think you already have a lot of testcases that I want to add,
> I'll take a look if you setup the branch and try to add my own if
> needed.

Great! That's so helpful for us :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


