Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaKZSkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:40:19 -0500
Received: from lists.s-osg.org ([54.187.51.154]:38061 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaKZSkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:40:17 -0500
Message-ID: <54761E8E.7070909@osg.samsung.com>
Date: Wed, 26 Nov 2014 11:40:14 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace IPMODIFY
 flag test
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102537.11844.9781.stgit@localhost.localdomain> <20141121160329.575fd043@gandalf.local.home> <54729CDE.5030700@hitachi.com> <20141123232932.1ed70d18@gandalf.local.home> <54733C80.6060509@hitachi.com> <54735A4F.8090602@osg.samsung.com> <5473D9F6.8070701@hitachi.com> <5474955A.5070605@osg.samsung.com> <547495D7.40308@osg.samsung.com> <54757F25.80005@hitachi.com>
In-Reply-To: <54757F25.80005@hitachi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 12:20 AM, Masami Hiramatsu wrote:
> (2014/11/25 23:44), Shuah Khan wrote:

>>>
>>> Good. Please take a look at this thread and give it a try. Please
>>> give me feedback as well. This is the first step to get the install
>>> feature added and then we can refine it at the selftests level as
>>> needed.
>>>
>>> https://lkml.org/lkml/2014/11/11/851
> 
> OK, I'll try that.
> BTW, are those patches included in the below kernel.org tree ?
> 
> https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git/

I just now uploaded it to linux-kselftest.git next branch

Give it a try and let me know what you think.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
