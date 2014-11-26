Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaKZHUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:20:15 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38738 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaKZHUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:20:13 -0500
Message-ID: <54757F25.80005@hitachi.com>
Date: Wed, 26 Nov 2014 16:20:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace
 IPMODIFY flag test
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102537.11844.9781.stgit@localhost.localdomain> <20141121160329.575fd043@gandalf.local.home> <54729CDE.5030700@hitachi.com> <20141123232932.1ed70d18@gandalf.local.home> <54733C80.6060509@hitachi.com> <54735A4F.8090602@osg.samsung.com> <5473D9F6.8070701@hitachi.com> <5474955A.5070605@osg.samsung.com> <547495D7.40308@osg.samsung.com>
In-Reply-To: <547495D7.40308@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/25 23:44), Shuah Khan wrote:
> On 11/25/2014 07:42 AM, Shuah Khan wrote:
>> On 11/24/2014 06:23 PM, Masami Hiramatsu wrote:
>>> (2014/11/25 1:18), Shuah Khan wrote:
>>>> On 11/24/2014 07:11 AM, Masami Hiramatsu wrote:
>>>>> (CC'ed Shuah, since this is related to kselftest)
>>>>>
>>>>>
>>>>> So, if your server directory is mounted with noexec, it's an environmental
>>>>> problem. I guess you can not build any kernel drivers on that testbox, can you?
>>>>>
>>>>> Anyway, this gives us a good question, "should test binaries be made by
>>>>> server or client(testbox) environment?" This ipmodify driver is a binary
>>>>> and it should be built with the kernel binary (by server) I think.
>>>>> But yes, I missed the Makefile didn't allow that (this always referred
>>>>> installed running kernel builddir).
>>>>>
>>>>> I hope to have CONFIG_KSELFTEST_BINARIES for Kconfig, or make prep_kselftest
>>>>> target to build these binaries with kernel...
>>>>>
>>>>> Shuah, what would you think about this?
>>>>
>>>> I am working on patch series to add an install target to the
>>>> main kernel makefile, so these tests can be built and installed
>>>> on a target just like we do with kernel and modules. I hope to
>>>> get this in 3.19 or definitely into 3.20
>>>>
>>>> This probably will help address the problem you are seeing.
>>>> Install target is needed for qemu type environments as well.
>>>
>>> Yes, that is what we need for this test case!
>>> Please CC to me when sending the series. I'd like to try and
>>> know how it works :)
>>>
>>
>> Good. Please take a look at this thread and give it a try. Please
>> give me feedback as well. This is the first step to get the install
>> feature added and then we can refine it at the selftests level as
>> needed.
>>
>> https://lkml.org/lkml/2014/11/11/851

OK, I'll try that.
BTW, are those patches included in the below kernel.org tree ?

https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git/

> Forgot to mention I didn't include ftrace in this first series for
> install, planning to add it in my next round of patches. I have the
> code ready for to do that.

No problem, I'll wait for your series :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


