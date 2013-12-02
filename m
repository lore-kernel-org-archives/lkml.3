Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3LBOhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:37:48 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34770 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3LBOho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:37:44 -0500
Message-ID: <529C9B35.1060607@gmail.com>
Date: Mon, 02 Dec 2013 07:37:41 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf sched: Add documentation for timehist options
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com>	<1385943795-11761-3-git-send-email-dsahern@gmail.com> <8761r7pumh.fsf@sejong.aot.lge.com>
In-Reply-To: <8761r7pumh.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 12:41 AM, Namhyung Kim wrote:
> Hi David,
>
> On Sun,  1 Dec 2013 17:23:15 -0700, David Ahern wrote:
>> Add entry to perf-sched documentation for timehist command and its
>> options.
>
> [SNIP]
>> +--max-stack::
>> +    Set the stack depth limit when showing the callchains. Default: 127
>
> Isn't it 5 instead of 127?

drat. missed that one.

David

