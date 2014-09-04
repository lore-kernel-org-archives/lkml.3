Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaIDD5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 23:57:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33805 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaIDD5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 23:57:20 -0400
Message-ID: <5407E318.3070308@hitachi.com>
Date: Thu, 04 Sep 2014 12:57:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: [RFC PATCH v3 0/4] ftrace: Add a ftrace test collection
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal> <87iol49kd0.fsf@sejong.aot.lge.com>
In-Reply-To: <87iol49kd0.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/04 11:42), Namhyung Kim wrote:
> On Tue, 02 Sep 2014 11:06:32 +0000, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here is the collection of testcases for ftrace version 3.
>> This is just some updates and fixes according to the 
>> discussion at previous version.
>>   https://lkml.org/lkml/2014/8/26/304
>>
>> The major updates are:
>>  - Fix some expressions to work on dash (Thanks Luis!)
>>  - Support UNRESOLVED/UNTESTED/UNSUPPORTED results for testcase.
>>    Those are POSIX 1003.3 standard.
>>    (see http://www.gnu.org/software/dejagnu/manual/x47.html for
>>     more details)
>>  - Fix to show error logs.
>>
>> ftracetest is a small dash script for testing ftrace features.
>> It will be required to add a unit test for each new feature
>> after this is merged, because of preventing feature regressions.
>>
>> This version still be out of the selftest. However, at the kernel
>> summit, I talked with Shuah about that. And since the kselftest
>> will be the standard kernel unit test framework, I agreed to
>> move this under the selftest. But I also would like to ask Steven
>> and Namhyung to agree with it before moving.
>>
>> Actually, since we've already has similar shell-script base
>> testcase under kselftest, we can easily move this under
>> selftests.
> 
> By [k]selftest, did you mean tools/testing/selftests/ ?

Yes, and I will just move tools/testing/ftrace to
tools/testing/selftests/ftrace and add a Makefile.

> Anyway I have no objection to the move.

Thank you!

> 
> Thanks for your work!
> Namhyung
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


