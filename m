Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaHMFh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:37:59 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55371 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMFh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:37:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/4] perf tools: Fix probing the kernel API with cpu-wide events
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
	<1407855871-15024-4-git-send-email-adrian.hunter@intel.com>
Date: Wed, 13 Aug 2014 14:37:57 +0900
In-Reply-To: <1407855871-15024-4-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Tue, 12 Aug 2014 18:04:30 +0300")
Message-ID: <87egwldk5m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014 18:04:30 +0300, Adrian Hunter wrote:
> Fall back to probing with the current pid if cpu-wide
> probing fails.  This primarily affects the setting of
> comm_exec flag when the user is un-privileged and
> /proc/sys/kernel/perf_event_paranoid > 0.  The change
> to comm_exec can be observed by using -vv with
> perf record and a kernel that supports comm_exec.

Maybe I'm missing something - why not just try process-wide probing in
the first place?

Thanks,
Namhyung
