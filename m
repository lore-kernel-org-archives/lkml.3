Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3JYDAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 23:00:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60832 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3JYDAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 23:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <20131024194647.GF4998@ghostprotocols.net>
References: <20131024075813.GA26929@gmail.com>
	<1382604360.5283.9.camel@pippen.local.home>
	<CAGdX0WG1gmC-ZXn5BFRMD5FM2r5d3oxvDU61-xFrT90badv3tg@mail.gmail.com>
	<20131024194647.GF4998@ghostprotocols.net>
Date: Fri, 25 Oct 2013 11:00:01 +0800
Message-ID: <CAGdX0WG8kq2Q2EsT1ricMxwN9f3W7DNC8fLR_e0dTG6eZ_daww@mail.gmail.com>
Subject: Re: ktap inclusion in drivers/staging/?
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 3:46 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Thu, Oct 24, 2013 at 08:11:36PM +0800, Jovi Zhangwei escreveu:
>> I admit there have many places need to cleanup in ktap code, and there
>> also have a long todo list, I will finish it before start review process.
>>
>> Again, really sorry for this, please forgive me this mistake.
>
> Just go eroding it, try to figure out things that could be useful on its
> own, find the right place in the tree, send a flow of small self
> contained patches that comes with tooling that uses whatever new kernel
> feature that is added.
>
> I think that even if you just add a 'perf test' entry that shows how the
> new feature should be used by tooling, exercising it and checking its
> results, so that every time people try 'perf test' it gets re verified,
> that would be ok when no other tools/ living source code exercises it.
>

Nice, I will take some time to look at it.

Thank you.

Jovi
