Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaIZMEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:04:34 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36416 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaIZMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:04:33 -0400
Message-ID: <5425564A.4020107@hitachi.com>
Date: Fri, 26 Sep 2014 21:04:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home> <5422336A.6030304@hitachi.com> <20140924114235.4287f4a1@gandalf.local.home> <20140924115811.6eeeab8c@gandalf.local.home> <5422EAE2.6080005@osg.samsung.com> <20140924120853.0a717b7e@gandalf.local.home> <5422EFB4.2050104@osg.samsung.com> <20140924123007.7fcb0099@gandalf.local.home> <5422F328.2040707@osg.samsung.com>
In-Reply-To: <5422F328.2040707@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/25 1:36), Shuah Khan wrote:
> On 09/24/2014 10:30 AM, Steven Rostedt wrote:
>> On Wed, 24 Sep 2014 10:22:12 -0600
>> Shuah Khan <shuahkh@osg.samsung.com> wrote:
>>
>>
>>> One simple approach is to have the user install the required tools
>>> for the test. Indicate what is needed and fail the test with
>>> appropriate message with xskip. This is what I have in mind for
>>> tests that can't be run because of a missing config. The same can
>>> be extended to external tools that the test depends on.
>>
>> Should I hold off adding my tests until we have all this in place. Or
>> should I just push my tests with simply passing if the config isn't
>> supported for now and add it later?
>>
>> I wont add any of the tests that require other tools besides echo, grep
>> and cat.

They are supported by busybox :)

> Please go ahead and get them in. The framework might have to wait
> until 3.19, so there is no need to have it gate test development.
> We can evolve them as we go. If tests require special, it means that
> they aren't suitable for certain envs such as qemu boot with busybox.
> There is a plan to add test targets to cover such cases.

Agreed, anyway, in some env those tools(commands) may not supported
by busybox because of the memory size etc. In that case, we can just
mark the test unsupported or xfail.

Thank you,

> I would recommend at least printing a message saying what you are
> missing if you find something missing.
> 
> thanks,
> -- Shuah
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


