Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaI3R6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:58:46 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42229 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaI3R6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:58:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1409290117350.20725@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>
	<20140908185115.GI6758@twins.programming.kicks-ass.net>
	<alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
	<alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
	<alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
	<20140910083136.GP6758@twins.programming.kicks-ass.net>
	<alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
	<541059C9.1040200@oracle.com>
	<alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu>
	<20140910143306.GD4783@worktop.ger.corp.intel.com>
	<alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu>
	<alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu>
	<CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com>
	<alpine.DEB.2.11.1409290117350.20725@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 30 Sep 2014 10:58:43 -0700
Message-ID: <CAHA+R7PCQRScYi3PF2dTQ-Hgoe7wv6GC4utBoF_pt5ZCRyOFuA@mail.gmail.com>
Subject: Re: perf: perf_fuzzer triggers instant reboot
From: Cong Wang <cwang@twopensource.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 10:21 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> On Thu, 25 Sep 2014, Cong Wang wrote:
>
>> On Wed, Sep 24, 2014 at 9:59 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
>
>> > Now that just might mean the patch pushed the code around enough so my
>> > test doesn't trigger, but there is hope that maybe this fixes things.
>>
>> I read this as it fixes your crash as well?
>
> It makes a testcase I have stop triggering an instant reboot, but there
> have been various attempts to fix similar problems over the past few
> months and so far the general family of lockups/reboots still remains.
>
> I'll have to start fuzzing with 3.17-rc7 and see if things are better now,
> but it can take days to trigger this class of bugs.

Great! Thanks for testing!

>
>> Sure, as I said in the changelog, it is a soft lockup which was triggered on
>> dozens of machines here, it is actually pretty straightforward:
>
> so you managed to trigger it with the perf utility?


Yes, it should be some job in our data center running perf.

> Do you have the exact command line that triggered it?
>

No, I didn't check /proc/<pid>/cmdline when I was debugging this.
What's more important, it was triggered by some job in data center,
hard to reproduce manually.

Hope this helps.
