Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225Ab3CTBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:25:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50767 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab3CTBZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:25:55 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-f9-51491020b51c
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 8/9] perf util: Get rid of die() calls in trace-data-read.c
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	<1363683224-28804-9-git-send-email-namhyung@kernel.org>
	<1363704928.5938.29.camel@gandalf.local.home>
Date: Wed, 20 Mar 2013 10:25:52 +0900
In-Reply-To: <1363704928.5938.29.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 19 Mar 2013 10:55:28 -0400")
Message-ID: <87620mj1zz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 10:55:28 -0400, Steven Rostedt wrote:
> On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Convert them to pr_debug() and propagate error code.
>
> Shouldn't they be pr_err(). I mean, if the old code would kill the
> process, why just keep it as a debug output?

Please see my other reply.

Arnaldo, can you give me your direction/preference?

Thanks,
Namhyung
