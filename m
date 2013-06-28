Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3F1ORQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:17:16 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47945 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab3F1ORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:17:12 -0400
Message-ID: <51CD9AE4.6060307@gmail.com>
Date: Fri, 28 Jun 2013 08:17:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
References: <1372307120-737-1-git-send-email-namhyung@kernel.org> <20130627093609.GO28407@twins.programming.kicks-ass.net> <20130627103931.GA5534@gmail.com> <20130627104750.GB27378@dyad.programming.kicks-ass.net> <20130628094738.GA28751@krava.brq.redhat.com>
In-Reply-To: <20130628094738.GA28751@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/13 3:47 AM, Jiri Olsa wrote:
>>> I thought -f was the implied default for ages?
>>
>> OK.. I've been dutifully typing it all this while :-)
>
> The '-f' option in record command had no affect.. myabe it got
> depreceated when we started to backup perf.data to perf.data.old..?

Way back in 2010, 2.6.34 kernel - 7865e817 commit. I've been typing the 
-f for while too. Now about the need for the pesky -f on the analysis 
side....

David
