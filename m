Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3LBT6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:58:44 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36927 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3LBT6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:58:40 -0500
Message-ID: <529CE66B.5070209@gmail.com>
Date: Mon, 02 Dec 2013 12:58:35 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
References: <20131202192315.GA17149@ghostprotocols.net> <529CDEA6.8000807@gmail.com> <20131202193850.GC17149@ghostprotocols.net>
In-Reply-To: <20131202193850.GC17149@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 12:38 PM, Arnaldo Carvalho de Melo wrote:
> Can you suggest a better name for the option being discussed?
>
> Perhaps one of:
>
> --show-event-time
> --event-time
>
> ?

Why not just --event-time?

Really should have dropped the 'show' from the recent perf-script change 
(just --task-events and --mmap-events).

>
> As a policy I think we should go on adding just long options and only
> after there is a really strong case we should use a short option for
> really, really popular options.

And adding options to .perfconfig. Need to use that more.

David
