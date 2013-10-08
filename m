Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3JHNZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:25:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37449 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3JHNZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:25:45 -0400
Message-ID: <525407D3.8060805@gmail.com>
Date: Tue, 08 Oct 2013 07:25:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf stat: Don't require a workload when using system
 wide or CPU options
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com> <1380400080-9211-3-git-send-email-dsahern@gmail.com> <87li2eofvd.fsf@sejong.aot.lge.com> <52497F3C.9070908@gmail.com> <20131008123928.GA4018@ghostprotocols.net>
In-Reply-To: <20131008123928.GA4018@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/13 6:39 AM, Arnaldo Carvalho de Melo wrote:
> While trying it noticed this, that should also be fixed
> eventually:
>
> [root@zoo ~]# perf stat -c C 0
> C: No such file or directory

you are missing '-' before the C:  perf stat -C 0. The -C = cpus. -c for 
stat is scale.

David
