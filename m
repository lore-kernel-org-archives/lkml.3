Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaJECIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 22:08:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58710 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJECIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 22:08:12 -0400
Message-ID: <5430A804.3040708@hitachi.com>
Date: Sun, 05 Oct 2014 11:08:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: (ltc-kernel 10162) Re: [PATCH ftrace/for-next v6] ftracetest:
 Add POSIX.3 standard and XFAIL result codes
References: <20140929120211.30203.99510.stgit@kbuild-f20.novalocal> <54294C55.3030204@hitachi.com> <542E8888.9090703@hitachi.com> <20141003165337.21043dee@gandalf.local.home>
In-Reply-To: <20141003165337.21043dee@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/04 5:53), Steven Rostedt wrote:
> On Fri, 03 Oct 2014 20:29:12 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Ping? :)
> 
> Just to make sure. This is just the one patch that I missed before,
> right?

Yes, this one is the last patch in previous series.

> 
> I pulled it and now testing it (running the tests). I'll push it to my
> linux-next branch sometime later today. You'll probably see it as you
> wake up ;-)

Thanks!!

> 
> -- Steve
> 
>>
>> (2014/09/29 21:11), Masami Hiramatsu wrote:
>>> Steven, could you pick this instead of old v5 patch?
>>>
>>> As you pointed, this version shows the log of "unsuppoted" test result.
>>>
>>> Thank you,
>>>
>>> (2014/09/29 21:02), Masami Hiramatsu wrote:
>>>> Add XFAIL and POSIX 1003.3 standard codes (UNRESOLVED/
>>>> UNTESTED/UNSUPPORTED) as result codes. These are used for the
>>>> results that test case is expected to fail or unsupported
>>>> feature (by config).
>>>>
>>>> To return these result code, this introduces exit_unresolved,
>>>> exit_untested, exit_unsupported and exit_xfail functions,
>>>> which use real-time signals to notify the result code to
>>>> ftracetest.
>>>>
>>>> This also set "errexit" option for the testcases, so that
>>>> the tests don't need to exit explicitly.
>>>>
>>>> Note that if the test returns UNRESOLVED/UNSUPPORTED/FAIL,
>>>> its test log including executed commands is shown on console
>>>> and main logfile as below.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


