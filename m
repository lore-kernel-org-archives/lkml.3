Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaKYBvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:51:38 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37122 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKYBvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:51:37 -0500
Message-ID: <5473E0A2.6020709@hitachi.com>
Date: Tue, 25 Nov 2014 10:51:30 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace
 IPMODIFY flag test
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102537.11844.9781.stgit@localhost.localdomain> <20141121160329.575fd043@gandalf.local.home> <54729CDE.5030700@hitachi.com> <20141123232932.1ed70d18@gandalf.local.home> <54733C80.6060509@hitachi.com> <20141124100727.19531a3b@gandalf.local.home> <20141124101831.69f6db23@gandalf.local.home> <20141124101919.3fd6fd01@gandalf.local.home>
In-Reply-To: <20141124101919.3fd6fd01@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/25 0:19), Steven Rostedt wrote:
> On Mon, 24 Nov 2014 10:18:31 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Mon, 24 Nov 2014 10:07:27 -0500
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>> On Mon, 24 Nov 2014 23:11:12 +0900
>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>  
>>>> So, if your server directory is mounted with noexec, it's an environmental
>>>> problem. I guess you can not build any kernel drivers on that testbox, can you?
>>>>
>>>
>>> You're right about the noexec, even though my fstab has "exec" in it ??
>>
>> Ha! I hit this bug!
>>
>>   https://bugzilla.redhat.com/show_bug.cgi?id=769636
>>
>> If I remove "user" from the flags, it mounts exec.
>>
>> This test box runs Fedora 18.
>>
> 
> Oh, and "make O=/tmp" now works :-)

Good :)

So, I don't need to fix that at this point, do I?
It seems that current kselftest only supports this type of build
(build on installed kernel), and Shuah is working on fixing that.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


