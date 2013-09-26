Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3IZSMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:12:14 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56368 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3IZSML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:12:11 -0400
Message-ID: <524478F2.8040609@gmail.com>
Date: Thu, 26 Sep 2013 12:12:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com> <20130926175105.GB9121@krava.brq.redhat.com>
In-Reply-To: <20130926175105.GB9121@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/13 11:51 AM, Jiri Olsa wrote:
> but it's still faster, since we finally get perf a chance to sleep ;-)
>
> new time:
> 	real    0m30.392s
> 	user    0m0.041s
> 	sys     0m0.389s
>
> old time:
> 	real    0m32.235s
> 	user    0m3.080s
> 	sys     0m14.444s

excellent.

>
>
>> [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
>>
>> Before I get too far down this path I wanted to get comments on the approach.
>
> I think it's worthwhile doing this

If you can toss it onto your queue to run through it other use cases -- 
like the 'make -j' on kernel builds. I am doing the same here and if all 
goes well I submit with some other patches next week.

Thanks,

David
