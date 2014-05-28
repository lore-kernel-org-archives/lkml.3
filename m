Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaE1Xw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:52:58 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:36023 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaE1Xw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:52:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 10/26] perf ui/browser: Add support to accumulated hist stat
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
	<1400839463-21933-11-git-send-email-namhyung@kernel.org>
	<20140526175226.GD2763@krava.brq.redhat.com>
Date: Thu, 29 May 2014 08:52:54 +0900
In-Reply-To: <20140526175226.GD2763@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 26 May 2014 19:52:26 +0200")
Message-ID: <87wqd5h355.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014 19:52:26 +0200, Jiri Olsa wrote:
> On Fri, May 23, 2014 at 07:04:07PM +0900, Namhyung Kim wrote:
>> Print accumulated stat of a hist entry if requested.
>> 
>> Tested-by: Arun Sharma <asharma@fb.com>
>> Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
>> Acked-by: Jiri Olsa <jolsa@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/ui/browsers/hists.c | 26 +++++++++++++++++++++++++-
>>  1 file changed, 25 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
>> index 1c331b934ffc..1de7428a9771 100644
>> --- a/tools/perf/ui/browsers/hists.c
>> +++ b/tools/perf/ui/browsers/hists.c
>> @@ -632,7 +632,6 @@ static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
>>  	ret = scnprintf(hpp->buf, hpp->size, fmt, percent);
>>  	slsmg_printf("%s", hpp->buf);
>>  
>> -	advance_hpp(hpp, ret);
>>  	return ret;
>
> Whats the purpose of this one..? does not fit to what's in changelog 

Hmm.. looks like a rebase artifact.  It's not a part of this patch.
I'll remove it.

Thanks,
Namhyung
