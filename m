Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaK0E5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 23:57:08 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41358 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK0E5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 23:57:06 -0500
Message-ID: <5476AF1B.5080709@hitachi.com>
Date: Thu, 27 Nov 2014 13:56:59 +0900
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
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102537.11844.9781.stgit@localhost.localdomain> <20141121160329.575fd043@gandalf.local.home> <54729CDE.5030700@hitachi.com> <20141123232932.1ed70d18@gandalf.local.home> <54733C80.6060509@hitachi.com> <54735A4F.8090602@osg.samsung.com> <5473D9F6.8070701@hitachi.com> <5474955A.5070605@osg.samsung.com> <547495D7.40308@osg.samsung.com> <54757F25.80005@hitachi.com> <54761E8E.7070909@osg.samsung.com>
In-Reply-To: <54761E8E.7070909@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/27 3:40), Shuah Khan wrote:
> On 11/26/2014 12:20 AM, Masami Hiramatsu wrote:
>> (2014/11/25 23:44), Shuah Khan wrote:
> 
>>>>
>>>> Good. Please take a look at this thread and give it a try. Please
>>>> give me feedback as well. This is the first step to get the install
>>>> feature added and then we can refine it at the selftests level as
>>>> needed.
>>>>
>>>> https://lkml.org/lkml/2014/11/11/851
>>
>> OK, I'll try that.
>> BTW, are those patches included in the below kernel.org tree ?
>>
>> https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git/
> 
> I just now uploaded it to linux-kselftest.git next branch
> 
> Give it a try and let me know what you think.

Thanks, I reviewed that and sent comments on the thread. :)


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


