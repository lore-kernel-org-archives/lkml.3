Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3EIN7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:59:21 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41208 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab3EIN7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:59:20 -0400
Message-ID: <518BABB3.7040601@gmail.com>
Date: Thu, 09 May 2013 07:59:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: detect when perf.data file not closed out properly
References: <1368025728-4669-1-git-send-email-dsahern@gmail.com> <20130509093253.GA21690@gmail.com>
In-Reply-To: <20130509093253.GA21690@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 3:32 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> +		pr_err("data size is 0. "
>> +		       "Was the record command properly terminated?\n");
>
> Btw., a small stylistic request: please put user-visible strings into a
> single line - even if it technically turns into an overlong line.
>
> 		pr_err("data size is 0. Was the record command properly terminated?\n");
>
> This 1) makes it easier for people to git grep the error text they are
> seeing during usage 2) makes it easier for _developers_ to see the
> messages they are outputing to users.

Totally agree just battling the line length.

>
> For example from the single-line output it's immediately visible that it
> should be capitalized thusly:
>
> 		pr_err("Data size is 0. Was the record command properly terminated?\n");
>

Ok. Will re-send later today.

David
