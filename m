Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3J2FOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:14:04 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51134 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J2FOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:14:02 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-ae-526f441759da
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/4] perf tools: Split -g and --call-graph for record command
References: <20131026120336.GA24439@gmail.com>
	<1382797536-32303-1-git-send-email-jolsa@redhat.com>
	<1382797536-32303-2-git-send-email-jolsa@redhat.com>
	<526D317E.80408@gmail.com> <20131028174613.GA3811@infradead.org>
	<526EAB05.6090800@gmail.com>
Date: Tue, 29 Oct 2013 14:13:59 +0900
In-Reply-To: <526EAB05.6090800@gmail.com> (David Ahern's message of "Mon, 28
	Oct 2013 12:20:53 -0600")
Message-ID: <87iowg7j6w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 12:20:53 -0600, David Ahern wrote:
> On 10/28/13 11:46 AM, Arnaldo Carvalho de Melo wrote:
>> Added this:
>>
>> --call-graph::
>>          Setup and enable call-graph (stack chain/backtrace) recording,
>>          implies -g.
>>
>>          Allows specifying "fp" (frame pointer) or "dwarf"
>>          (DWARF's CFI - Call Frame Information) as the method to collect
>>          the information used to show the call graphs.
>>
>>          In some systems, where binaries are build wit gcc
>
> s/wit/with/

And also forgot to mention user stack dump size (and its default size)
in case of "dwarf".

Thanks,
Namhyung
