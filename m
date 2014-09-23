Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaIWBD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:03:29 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:49507 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932142AbaIWBDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:03:14 -0400
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:41:152:355:379:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2693:2895:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3871:3872:4184:4250:4605:5007:7652:7875:7903:8531:9040:9149:10004:10400:10848:10967:11026:11232:11657:11658:11914:12043:12291:12517:12519:12555:12663:12740:13141:13230:13894:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slave60_1c082c4999c08
X-Filterd-Recvd-Size: 4475
User-Agent: K-9 Mail for Android
In-Reply-To: <87h9zzkwgp.fsf@sejong.aot.lge.com>
References: <20140922234248.23415.36560.stgit@kbuild-f20.novalocal> <87h9zzkwgp.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v5 0/4] ftrace: Add a ftrace test collection
From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 22 Sep 2014 21:03:08 -0400
To: Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <4243ee73-aff7-43a6-92cf-bd8df9b954b4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack fot all?  I can add it.

-- Steve


On September 22, 2014 8:32:38 PM GMT-04:00, Namhyung Kim <namhyung@kernel.org> wrote:
>On Mon, 22 Sep 2014 23:42:48 +0000, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here is the collection of testcases for ftrace version 5.
>> This is just a small update.
>>
>>   - Fix a TODO item, since this already integrated to kselftest.
>>   - Print the test name at the first line.
>>   - Add Shuah's acked-by. (Thanks!)
>>
>> ftracetest is a shell(dash) script for testing ftrace features.
>> It will be required to add a unit test for each new feature
>> after this is merged, because of preventing regressions.
>
>If I'm not too late.. :)
>
>Acked-by: Namhyung Kim <namhyung@kernel.org>
>
>Thanks,
>Namhyung
>
>
>>
>> ---
>>
>> Masami Hiramatsu (4):
>>       ftracetest: Initial commit for ftracetest
>>       ftracetest: Add ftrace basic testcases
>>       ftracetest: Add kprobe basic testcases
>>       ftracetest: Add POSIX.3 standard and XFAIL result codes
>>
>>
>>  MAINTAINERS                                        |    1 
>>  tools/testing/selftests/Makefile                   |    1 
>>  tools/testing/selftests/ftrace/Makefile            |    7 +
>>  tools/testing/selftests/ftrace/README              |   82 +++++++
>>  tools/testing/selftests/ftrace/ftracetest          |  251
>++++++++++++++++++++
>>  tools/testing/selftests/ftrace/samples/fail.tc     |    4 
>>  tools/testing/selftests/ftrace/samples/pass.tc     |    3 
>>  .../testing/selftests/ftrace/samples/unresolved.tc |    4 
>>  .../selftests/ftrace/samples/unsupported.tc        |    3 
>>  tools/testing/selftests/ftrace/samples/untested.tc |    3 
>>  tools/testing/selftests/ftrace/samples/xfail.tc    |    3 
>>  .../selftests/ftrace/test.d/00basic/basic1.tc      |    3 
>>  .../selftests/ftrace/test.d/00basic/basic2.tc      |    7 +
>>  .../selftests/ftrace/test.d/00basic/basic3.tc      |    8 +
>>  .../ftrace/test.d/kprobe/add_and_remove.tc         |   11 +
>>  .../selftests/ftrace/test.d/kprobe/busy_check.tc   |   13 +
>>  tools/testing/selftests/ftrace/test.d/template     |    9 +
>>  17 files changed, 413 insertions(+)
>>  create mode 100644 tools/testing/selftests/ftrace/Makefile
>>  create mode 100644 tools/testing/selftests/ftrace/README
>>  create mode 100755 tools/testing/selftests/ftrace/ftracetest
>>  create mode 100644 tools/testing/selftests/ftrace/samples/fail.tc
>>  create mode 100644 tools/testing/selftests/ftrace/samples/pass.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/samples/unresolved.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/samples/unsupported.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/samples/untested.tc
>>  create mode 100644 tools/testing/selftests/ftrace/samples/xfail.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/test.d/00basic/basic1.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
>>  create mode 100644
>tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>>  create mode 100644 tools/testing/selftests/ftrace/test.d/template
>>
>> --

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
