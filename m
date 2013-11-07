Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3KGOcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:32:51 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48742 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3KGOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:32:47 -0500
Message-ID: <527BA48C.2020200@gmail.com>
Date: Thu, 07 Nov 2013 07:32:44 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 0/2] perf record: mmap output file - v3
References: <1383589905-10208-1-git-send-email-jolsa@redhat.com> <527A81B8.7040505@gmail.com> <20131107100619.GB1251@krava.brq.redhat.com>
In-Reply-To: <20131107100619.GB1251@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/13, 3:06 AM, Jiri Olsa wrote:
> On Wed, Nov 06, 2013 at 10:51:52AM -0700, David Ahern wrote:
>> On 11/4/13, 11:31 AM, Jiri Olsa wrote:
>>> hi,
>>> after discussion with David, sending his change
>>> updated into the new data file object.
>>>
>>> David's original post:
>>>    http://marc.info/?l=linux-kernel&m=138180575328977&w=2
>>>
>>> Here's the change:
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>>>    perf/mmap1
>>>
>>
>> Not having any luck with these patches. Basic use case:
>>
>> perf trace record -a -- sleep 5
>> perf trace --summary
>>
>> With your patches I get a parse error. With my latest versions
>> everything works clean.
>
> hum,
> perf trace --summary seems stuck in a loop, but that's no
> different from current acme's perf/core.

D'oh. When writing the email I was trying to keep the command line small 
and in the process removed the -i /tmp/perf.data from the second 
command. Without it perf-trace runs in live mode; with it events are 
read from a file.

David

