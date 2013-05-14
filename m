Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3ENAny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:43:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63746 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3ENAnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:43:53 -0400
X-AuditID: 9c930179-b7b92ae0000035f7-e5-519188c63782
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] perf report: Add --percent-limit option
References: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
	<20130513132028.GA1032@krava.brq.redhat.com>
Date: Tue, 14 May 2013 09:43:50 +0900
In-Reply-To: <20130513132028.GA1032@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 13 May 2013 15:20:29 +0200")
Message-ID: <87li7i5r21.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 13 May 2013 15:20:29 +0200, Jiri Olsa wrote:
> On Mon, May 13, 2013 at 05:41:42PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The --percent-limit option is for not showing small overheaded entries
>> in the output.  Maybe we want to set a certain default value like 0.1.
>
> hi,
> can't apply this on acme's perf/core nor latest tip
> What is this based on? Maybe you could push the branch out? ;-)

Oops, I wanted to make it independent to other patches, but it seemed I
failed. :)

It's on top on acme/perf/core but also depends on my other works.  I'll
resend the patches in a set and push the branch soon.

Thanks,
Namhyung
