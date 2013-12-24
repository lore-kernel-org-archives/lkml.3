Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3LXH7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 02:59:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44779 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LXH7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 02:59:07 -0500
X-AuditID: 9c930179-b7c89ae000006438-2e-52b93ec97d27
From: Namhyung Kim <namhyung@kernel.org>
To: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [RFC/PATCHSET 00/18] perf report: Add support to accumulate hist periods (v3)
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
	<20131218094622.GA19240@gmail.com> <52B17B14.5030101@fb.com>
	<1387377549.1717.14.camel@leonhard> <52B7FF61.2090908@fb.com>
Date: Tue, 24 Dec 2013 16:59:04 +0900
In-Reply-To: <52B7FF61.2090908@fb.com> (Arun Sharma's message of "Mon, 23 Dec
	2013 14:46:17 +0530")
Message-ID: <87txdyfznb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On Mon, 23 Dec 2013 14:46:17 +0530, Arun Sharma wrote:
> On 12/18/13 8:09 PM, Namhyung Kim wrote:
>> Hi Arun,
>>
>> 2013-12-18 (수), 16:08 +0530, Arun Sharma:
>>> On 12/18/13 3:16 PM, Ingo Molnar wrote:
>>>
>>>> My main complaint that any variation of 'cumulative' or 'cumulate' is
>>>> a tongue-twister to users. I certainly won't be able to remember it
>>>> and will have to call up the manpage every time I use it - which will
>>>> be very annoying. I'd probably not use the feature much.
>>>
>>> I can remember it, mainly because it's such an unusual word :)
>>> Agree that we could use something simpler/easier to remember.
>>>
>>> My other user space projects have been keeping me busy. But still very
>>> interested in this feature. Will test this patch series over the holidays.
>>
>> Thanks in advance for your test and feedback! :)
>
> Looks great! One of the features I'm missing compared to my earlier
> --sort inclusive series of patches is that, in the --children mode,
> I'd still like to see callchains (at least in --tui). Looks like
> --children and -G -s pid can't be used together in this
> implementation.

Right, it wasn't supported in this version.  But I have a plan to add it
in the near future. :)

Thanks,
Namhyung
