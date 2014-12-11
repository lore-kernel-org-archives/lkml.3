Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbaLKSzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:55:14 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49578 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbaLKSzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:55:10 -0500
Message-ID: <5489E88A.3000801@gmail.com>
Date: Thu, 11 Dec 2014 11:55:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/8] perf data: Add a 'perf' prefix to the generic fields
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org> <1418310749-22267-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418310749-22267-5-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/14 8:12 AM, Jiri Olsa wrote:

> Before:
>    $ babeltrace ./ctf-data/
>    [03:19:13.962131936] (+0.000001935) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 8 }
>    [03:19:13.962133732] (+0.000001796) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 114 }
>    ...
>
> Now:
>    $ babeltrace ./ctf-data/
>    [03:19:13.962131936] (+0.000001935) cycles: { }, { perf_ip = 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period = 8 }
>    [03:19:13.962133732] (+0.000001796) cycles: { }, { perf_ip = 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period = 114 }
>    ...

How is babeltrace showing time-of-day for perf-based data files? Is that 
tod when the command is run?

David
