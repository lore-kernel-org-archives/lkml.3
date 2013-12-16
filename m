Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab3LPFZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:25:32 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62888 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3LPFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:25:31 -0500
X-AuditID: 9c93017d-b7c5eae000004296-6e-52ae8eca411c
From: Namhyung Kim <namhyung@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        dvhart@linux.intel.com, peterz@infradead.org, tglx@linutronix.de,
        jason.low2@hp.com, Waiman.Long@hp.com, scott.norton@hp.com,
        aswin@hp.com
Subject: Re: [PATCH 2/3] perf-bench: add futex-wake microbenchmark
References: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
	<1387081917-9102-3-git-send-email-davidlohr@hp.com>
Date: Mon, 16 Dec 2013 14:25:30 +0900
In-Reply-To: <1387081917-9102-3-git-send-email-davidlohr@hp.com> (Davidlohr
	Bueso's message of "Sat, 14 Dec 2013 20:31:56 -0800")
Message-ID: <87k3f5gyet.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On Sat, 14 Dec 2013 20:31:56 -0800, Davidlohr Bueso wrote:
> Block a bunch of threads on a futex and wake them up, N at a time.
>
> This program is particularly useful to measure the latency of nthread wakeups
> in non-error situations:  all waiters are queued and all wake calls wakeup
> one or more tasks. An example run:
>
> $ perf bench futex -t 512 -r 100

Did you mean 'perf bench futex wake'?

Thanks,
Namhyung
