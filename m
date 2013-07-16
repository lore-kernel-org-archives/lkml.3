Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3GPAXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:23:15 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17962 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3GPAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:23:14 -0400
X-Spam-Score: -100.8
Message-ID: <51E49236.6080600@asianux.com>
Date: Tue, 16 Jul 2013 08:22:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: remove __init from race_selftest_startup_function()
 and trace_selftest_startup_function_graph()
References: <51DDFCF8.2090808@asianux.com>    <1373561279.17876.45.camel@gandalf.local.home>    <51DF44FA.9060000@asianux.com>   <1373593261.17876.61.camel@gandalf.local.home>   <51DF62DB.3010409@asianux.com>  <1373596735.17876.84.camel@gandalf.local.home>  <51DF7250.9020209@asianux.com> <51DFAE5A.2060005@asianux.com>  <51E35A7D.8000008@asianux.com> <1373905251.17876.150.camel@gandalf.local.home>
In-Reply-To: <1373905251.17876.150.camel@gandalf.local.home>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:20 AM, Steven Rostedt wrote:
> On Mon, 2013-07-15 at 10:12 +0800, Chen Gang wrote:
> 
>> > Hello Frederic and Ingo:
> Are you trying to go around me? I wrote this code and I'm one of the
> maintainers for it. Your issue is very minor, and can wait till other
> things get done first.
> 
> You said my previous patch fixed your problem, right? Then I'll add your
> tested by and push it in due course.
> 
> I'll also get around to adding __init's to other functions too. But it
> is *very* low on the totem pole of importance.
> 

I only provide my suggestions (or recommendations) which I think might
be useful for us, and I don't care about whether you accept or not.

If you want discuss, we can continue, if you won't (now, I guess so),
you can just provide your choice is OK.

>> > 
>> > Could you provide your suggestions or completions for it ?
>> > 
>> > The trace_selftest_startup_* funcitons are mostly added by you without
>> > '__init', do you have additional considerations about it (intend to have
>> > no '__init') ?
>> > 
>> > If no reply, I recommend to keep no '__init': apply this patch or
>> > regress part of the patch "f1ed7c7 ftrace: Do not run selftest if
>> > command line parameter is set" (at least, it can avoid related warnings
>> > and treat all *selftest* fair).
> It's a compile time warning that's a false positive. Not a run time
> crash or other issue of importance. It can wait, relax. Otherwise you
> are starting to become annoying.

At least this patch is not 'urgent' (not a run time crash, or other
issue of 'urgent'), but every members have their own opinions to treat
this issue whether 'important' or not ('important' != 'urgent').

And every members' time resources are expensive (not only you, but also
me, and other members).

When I got none-reply, I don't know what happened (whether you agree, or
not, what I said correct or incorrect ?), it is a polite to give a
confirmation reply to tell whether you accept or not.


Thanks.
-- 
Chen Gang
