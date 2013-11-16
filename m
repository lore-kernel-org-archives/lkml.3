Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3KPPTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 10:19:01 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45582 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3KPPSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 10:18:54 -0500
Message-ID: <52878CD4.5080307@gmail.com>
Date: Sat, 16 Nov 2013 08:18:44 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf tip: fails to convert comm
References: <528306F5.8050307@gmail.com> <20131113180344.GA28039@localhost.localdomain> <52864BFF.20601@gmail.com> <20131116010207.GA18855@localhost.localdomain>
In-Reply-To: <20131116010207.GA18855@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/13, 6:02 PM, Frederic Weisbecker wrote:
> On Fri, Nov 15, 2013 at 09:29:51AM -0700, David Ahern wrote:
>> HI Frederic:
>>
>> On 11/13/13, 11:03 AM, Frederic Weisbecker wrote:
>>>
>>> I see. I can reproduce, I'll check and see what happens. It would be nice if
>>> we could have an option to dump internal perf events like comm events as well
>>> in the perf script stream.
>>
>> Any progress on a solution? This is a regression in 3.13.
>
> So the problem is that when a thread overrides its default ":%pid" comm, we forget
> to tag the thread comm as overriden. Hence, this overriden comm is not inherited on
> future forks.
>
> So here is a fix. Tell me if you see more issue, I'll cook a proper changelog and
> resend if everyting looks good.

That works for me. Thank you.

Tested-by: David Ahern <dsahern@gmail.com>
