Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaAQH4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:56:23 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50180 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaAQH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:56:20 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-b6-52d8e22214b3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, acme@ghostprotocols.net
Subject: Re: [PATCH 2/3] perf tools: Spare double comparison of callchain first entry
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
	<1389713836-13375-3-git-send-email-fweisbec@gmail.com>
	<87y52h930t.fsf@sejong.aot.lge.com>
	<20140115165927.GA21574@localhost.localdomain>
	<87d2js9132.fsf@sejong.aot.lge.com>
	<20140116173454.GA5328@localhost.localdomain>
	<20140116194734.GA2373@infradead.org>
Date: Fri, 17 Jan 2014 16:56:18 +0900
In-Reply-To: <20140116194734.GA2373@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 16 Jan 2014 17:47:34 -0200")
Message-ID: <87ob3b6nz1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Frederic,

On Thu, 16 Jan 2014 17:47:34 -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 16, 2014 at 06:34:58PM +0100, Frederic Weisbecker escreveu:
>> On Thu, Jan 16, 2014 at 10:17:53AM +0900, Namhyung Kim wrote: 
>> > I think if the sort key doesn't contain "symbol", unmatch case would be
>> > increased as more various callchains would go into a same entry.
>> 
>> You mean -g fractal,0.5,callee,address ?
>> 
>> Hmm, actually I haven't seen much difference there.
>
> I guess he will, but will wait for Namhyung's final ack here, ok?

I meant sorting of hist entry like "-s cpu".   So as your number said
it's not an issue IMHO.  Arnaldo, I'm good with this change please merge
it. :)

Thanks,
Namhyung
