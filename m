Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaFCDHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:07:15 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42251 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaFCDHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:07:14 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: acme@kernel.org, namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        mingo@kernel.org, paulus@samba.org
Subject: Re: [PATCH] perf script: pass more arguments to the python event handler
References: <1401467123-12773-1-git-send-email-bigeasy@linutronix.de>
Date: Tue, 03 Jun 2014 12:07:11 +0900
In-Reply-To: <1401467123-12773-1-git-send-email-bigeasy@linutronix.de>
	(Sebastian Andrzej Siewior's message of "Fri, 30 May 2014 18:25:23
	+0200")
Message-ID: <8738fmelnk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Fri, 30 May 2014 18:25:23 +0200, Sebastian Andrzej Siewior wrote:
> This patch extends the current argument list in case of events by
> - IP / addr of the event. Currently only the function name is passed.
> - seconds and ns as the timestamp. Split into two value to stay close to
>   what the trace handler passes.
> - the pid of the proccess
>
> I added a common_ prefix to stay close to the naming of the "trace"
> handler. Currently I don't mind dropping it since "comm" isn't named
> "common_comm". Any suggestions?

Please take a look at Joseph's work on the same direction (and more).

https://lkml.org/lkml/2014/4/3/217

Thanks,
Namhyung
