Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab3EOPoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:44:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57747 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967Ab3EOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:44:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130515150450.GB2194@krava.brq.redhat.com>
References: <1367421944-19082-1-git-send-email-jolsa@redhat.com>
	<20130507122948.GD1076@krava.brq.redhat.com>
	<20130515150450.GB2194@krava.brq.redhat.com>
Date: Wed, 15 May 2013 17:44:07 +0200
Message-ID: <CAFTL4hzFJ1cOvo0p_r0S+TC4cBJqurtfjkg7fYv-Gtrh2wTLkg@mail.gmail.com>
Subject: Re: [PATCHv3 0/4] perf, signal x86: Fix breakpoint events overflow handling
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/15 Jiri Olsa <jolsa@redhat.com>:
> On Tue, May 07, 2013 at 02:29:48PM +0200, Jiri Olsa wrote:
>> On Wed, May 01, 2013 at 05:25:40PM +0200, Jiri Olsa wrote:
>> > hi,
>> > sending v3 for initial patchset:
>> > https://lkml.org/lkml/2013/3/1/324
>> >
>> > basically just sending remaining (not pulled) patches,
>> > with '*-by: *' tags updated.
>> >
>> > v3 changes:
>> >   - perf test patches already pulled in
>> >   - added Oleg's Tested-by for signal related patches
>> >   - added Frederic's Reviewed-by for signal related patches
>> >   - added Peter's Reviewed-by for perf patch.
>>
>> hi,
>>
>> Thomas, Peter,
>> any chance you could pull this in?
>>
>> Ingo,
>> could you please take the perf change (4/4)?
>> it's reviewed by PeterZ
>
> ping

May be you can set up a branch based on v3.10-rc1 with these patches
applied on top and send it as a pull request to Ingo (and LKML + other
people Cc'ed). Your branch is not pullable as is because it seems to
be based on tip:master (it's not targeted for mainline, just there for
testing) and moreover an old enough version of it.

Just suggesting that because clean pull requests based on sane
starting points usually get better and faster attention than
standalone patches because it's less maintainance noise. Also you have
all the necessary acks so it's all good.

Thanks!
