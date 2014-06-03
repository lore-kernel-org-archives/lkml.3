Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaFCBg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:36:26 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49507 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaFCBgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:36:25 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 2/4] perf tools: allow user to specify hardware breakpoint bp_len
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
	<1401377213-24551-3-git-send-email-fweisbec@gmail.com>
	<20140530133906.GC7427@krava.brq.redhat.com>
Date: Tue, 03 Jun 2014 10:36:22 +0900
In-Reply-To: <20140530133906.GC7427@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 30 May 2014 15:39:06 +0200")
Message-ID: <87mwduepux.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 30 May 2014 15:39:06 +0200, Jiri Olsa wrote:
> On Thu, May 29, 2014 at 05:26:51PM +0200, Frederic Weisbecker wrote:
>> From: Jacob Shin <jacob.w.shin@gmail.com>
>> 
>> Currently bp_len is given a default value of 4. Allow user to override it:
>> 
>>   $ perf stat -e mem:0x1000/8
>>                             ^
>>                             bp_len
>> 
>> If no value is given, it will default to 4 as it did before.
>
> Namhyung,
> both perf tols patches from this patchset mess up with hists
> tests..  I havent found any connection yet.. any idea? ;-)

So you already found the problem in the hpp->elide change and that's the
reason of the failure, right? :)

Thanks,
Namhyung
