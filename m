Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967171Ab3HIFvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 01:51:05 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61871 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966964Ab3HIFvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 01:51:04 -0400
X-AuditID: 9c93017e-b7b2aae000000ed6-93-52048345e564
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 01/17] perf util: Save pid-cmdline mapping into tracing header
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
	<1375175954-798-2-git-send-email-namhyung@kernel.org>
	<20130730132839.GA2607@ghostprotocols.net> <51F85FAA.2090400@lge.com>
	<20130731140746.GA3614@ghostprotocols.net>
	<87r4e81u8w.fsf@sejong.aot.lge.com> <52024F38.4080808@gmail.com>
Date: Fri, 09 Aug 2013 14:51:00 +0900
In-Reply-To: <52024F38.4080808@gmail.com> (David Ahern's message of "Wed, 07
	Aug 2013 09:44:24 -0400")
Message-ID: <878v0bxvi3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 07 Aug 2013 09:44:24 -0400, David Ahern wrote:
> On 8/5/13 3:17 AM, Namhyung Kim wrote:
>>> I don't think this is a problem, its in line with Ingo's suggestion of a
>>> new perf ioctl to ask the kernel to generate PERF_RECORD_MMAP events for
>>> existing threads.
>>
>> Hmm.. could you please give me a link of the thread?
>
> I believe this is the thread being referred to:
> https://lkml.org/lkml/2013/6/25/180

Thank you!
Namhyung
