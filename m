Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaBJCnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:43:40 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54754 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaBJCnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:43:39 -0500
X-AuditID: 9c93016f-b7b0cae0000024a7-4a-52f83cd93111
From: Namhyung Kim <namhyung@kernel.org>
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist periods (v8)
References: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
	<20140207033110.GA17630@sdfg.com.ar>
Date: Mon, 10 Feb 2014 11:43:36 +0900
In-Reply-To: <20140207033110.GA17630@sdfg.com.ar> (Rodrigo Campos's message of
	"Fri, 7 Feb 2014 03:31:10 +0000")
Message-ID: <87txc7znzb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodrigo,

On Fri, 7 Feb 2014 03:31:10 +0000, Rodrigo Campos wrote:
> On Fri, Feb 07, 2014 at 10:35:02AM +0900, Namhyung Kim wrote:
>> 
>> Currently the perf enables both of --call-graph and --children when it
>> finds callchains in the samples.  While this is useful for TUI or GTK,
>> I'm not sure for stdio as it'd consume so much lines.
>> 
>> It does not handle all kind of cases like event groups and annotations
>> yet, but I really want to release it and get reviews.
>> 
>> You can also get this series on 'perf/cumulate-v8' branch in my tree at:
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
>
> I've modified a little your example to link against two libraries dynamically
> and see different cases of how is self vs children attributed when running with
> "--sort dso" and it seems great.

Thanks for testing!

>
> I've tried simple examples just as: calling a lib1 function that calls lib2
> function which uses lot of CPU, calling lib1 function that uses lot of CPU and
> also calls lib2 func that uses lot of CPU. And things like that. Probably using
> one lib was enough (I first played with only one) as it's a different symbol
> from the main, but just in case some weird bug (was really easy) I tested with
> two :-)

Nice.

>
> I might be able to test with more real world scenarios on Saturday, although I'm
> sick now and I'm not sure how I will feel :S

Oh, sorry to hear that.  Hope you get very well soon!

Thanks,
Namhyung
