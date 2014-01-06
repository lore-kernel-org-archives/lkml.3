Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaAFHpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:45:42 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55673 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaAFHpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:45:41 -0500
X-AuditID: 9c930197-b7c4aae000003d84-32-52ca5f236000
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct add_entry_iter
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-2-git-send-email-namhyung@kernel.org>
	<20140105152815.GA8720@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 16:45:39 +0900
In-Reply-To: <20140105152815.GA8720@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 5 Jan 2014 16:28:15 +0100")
Message-ID: <87sit1eeos.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 16:28:15 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:07PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> +	iter->rep = rep;
>> +	ret = perf_evsel__add_entry(evsel, &al, sample, machine, iter);
>
> you dont need to pass machine pointer, it's already in 'al'

Right.

Thanks,
Namhyung
