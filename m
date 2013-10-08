Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3JHOPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:15:44 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:44269 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3JHOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:15:42 -0400
MIME-Version: 1.0
In-Reply-To: <20131008104740.GU3081@twins.programming.kicks-ass.net>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
	<1380195398-4402-4-git-send-email-jean.pihet@linaro.org>
	<20130926124829.GA3284@krava.brq.redhat.com>
	<CAFrcx1nDe6mhxEuU4ROJGOmGFaYtVnnhXYirkmhRb1NEecNhtw@mail.gmail.com>
	<20131008104740.GU3081@twins.programming.kicks-ass.net>
Date: Tue, 8 Oct 2013 16:15:40 +0200
Message-ID: <CAFrcx1kNONpBcsEHX1PN0kNUCOAkBCid+bgbv3mc0TPu=F+MYg@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of dwarf
 parsing feature
From: Jean Pihet <jean.pihet@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8 October 2013 12:47, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 08, 2013 at 12:44:32PM +0200, Jean Pihet wrote:
>> Hi,
>>
>> On 26 September 2013 14:48, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Thu, Sep 26, 2013 at 01:36:37PM +0200, Jean Pihet wrote:
>> >> The newly added dwarf unwinding feature [1] requires:
>> >> . a recent version (>= 1.1) of libunwind,
>> >> . libunwind to be configured with --enable-debug-frame.
>> >>
>> >> [1] http://www.spinics.net/lists/kernel/msg1598951.html
>> >>
>> >> Add the corresponding API tests in the feature check list.
>> >
>> > Acked-by: Jiri Olsa <jolsa@redhat.com>
>> >
>> > thanks,
>> > jirka
>>
>> Thanks for the ack!
>>
>> Is it possible to get an ack from the perf core maintainers?
>> Also, is the patch going in Will's tree?
>
> This being a tools patch you'd have to ask acme; also I know next to
> nothing about all this unwind business except that its stupid expensive
> ;-)
You are right! It brings some more info on the trace though.

-- adding Arnaldo in the loop --
Arnaldo, are you OK with the changes [1]? Jiri acked the patches
already; Will is willing (no pun intended) to take the ARM specific
patches [2] in his tree.

[1] http://www.spinics.net/lists/kernel/msg1608921.html and
http://www.spinics.net/lists/kernel/msg1608922.html
[2] http://www.spinics.net/lists/kernel/msg1608920.html and
http://www.spinics.net/lists/kernel/msg1608923.html

Regards,
Jean
