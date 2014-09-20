Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbaITR0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:26:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46565 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbaITR0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:26:45 -0400
Message-ID: <541DB8CD.7000107@hitachi.com>
Date: Sun, 21 Sep 2014 02:26:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH v4 1/4] ftracetest: Initial commit for ftracetest
References: <20140918120437.28308.72301.stgit@kbuild-f20.novalocal> <20140918120445.28308.57538.stgit@kbuild-f20.novalocal> <541AD905.6000700@osg.samsung.com> <541B80DE.1060902@hitachi.com> <541C3823.4090203@osg.samsung.com>
In-Reply-To: <541C3823.4090203@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/19 23:05), Shuah Khan wrote:
>>>> +TODO
>>>> +====
>>>> +
>>>> + * Fancy colored output :)
>>>> +
>>>> + * Integrate with selftest?
>>>
>>> The second TODO can be removed since it is moved under selftests??
>>
>> Ah, I missed to remove that in this commit. It's already integrated.
>>
>> - * Integrate with selftest?
>>
>> Oops, and I removed it in 4/4 ...
> 
> If you could fix this README, that would be great.

Yeah, but I guess if all of this series are merged, it may be not
such a big flaw...
Steven, would I better resend updates?

>>> If you haven't already done this, could you please make sure it
>>> runs without hangs when run from the "make kselftest" target.
>>
>> OK, here is the last lines of the test result.
>>
>> == Testing sysctl behavior against /proc/sys/vm/swappiness ==
>> Writing test file ... ok
>> Checking sysctl is not set to test value ... ok
>> Writing sysctl from shell ... ok
>> Resetting sysctl to original value ... ok
>> Writing entire sysctl in single write ... ok
>> Writing middle of sysctl after synchronized seek ... Writing beyond end of sysctl ... Writing sysctl with multiple long writes ... ok
>> fw_filesystem: [FAIL]
>> [1] Basic trace file check      [PASS]
>> [2] Basic test for tracers      [PASS]
>> [3] Basic trace clock test      [PASS]
>> [4] Kprobe dynamic event - adding and removing  [PASS]
>> [5] Kprobe dynamic event - busy event check     [PASS]
>>
>> # of passed:  5
>> # of failed:  0
>> # of unresolved:  0
>> # of untested:  0
>> # of unsupported:  0
>> # of xfailed:  0
>> # of undefined(test bug):  0
>>
>> Hmm, I think it should have a separation line before running ftracetest.
>>
> 
> I am not concerned about the spacing.

OK, anyway I can make an update for that afterwords.

> Thanks for doing running the make kselftest target and sharing
> the results. selftests don't get built or run in integ test
> rings. I am working on addressing this at the moment.
> 
> Steven!
> 
> Could you please take this through your tree. You have my
> 
> Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> for the selftests Makefile

Thanks!

> 
> -- Shuah
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


