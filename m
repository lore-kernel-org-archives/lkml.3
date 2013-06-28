Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3F1QDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:03:33 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57138 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3F1QDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:03:31 -0400
Message-ID: <51CDB3CB.8040304@gmail.com>
Date: Fri, 28 Jun 2013 10:03:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
References: <1372307120-737-1-git-send-email-namhyung@kernel.org> <20130627093609.GO28407@twins.programming.kicks-ass.net> <20130627103931.GA5534@gmail.com> <20130627104750.GB27378@dyad.programming.kicks-ass.net> <20130628094738.GA28751@krava.brq.redhat.com> <51CD9AE4.6060307@gmail.com> <20130628153736.GA462@gmail.com>
In-Reply-To: <20130628153736.GA462@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/13 9:37 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> On 6/28/13 3:47 AM, Jiri Olsa wrote:
>>>>> I thought -f was the implied default for ages?
>>>>
>>>> OK.. I've been dutifully typing it all this while :-)
>>>
>>> The '-f' option in record command had no affect.. myabe it got
>>> depreceated when we started to backup perf.data to perf.data.old..?
>>
>> Way back in 2010, 2.6.34 kernel - 7865e817 commit. I've been typing
>> the -f for while too. Now about the need for the pesky -f on the
>> analysis side....
>
> That's only needed when perf.data is owned by a different user, right?
>

Yes, why not let file permissions dictate of uid x can read uid y files? 
Why does perf need to have that restriction? For example, QA collects 
the data files, developers analyze them.

David

