Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3HMDBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:01:45 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43033 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab3HMDBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:01:44 -0400
X-AuditID: 9c93017e-b7c76ae000003897-ab-5209a1962c2c
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 04/13] perf tools: change machine__findnew_thread() to set thread pid
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
	<1376045519-13832-5-git-send-email-adrian.hunter@intel.com>
Date: Tue, 13 Aug 2013 12:01:42 +0900
In-Reply-To: <1376045519-13832-5-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Fri, 9 Aug 2013 13:51:50 +0300")
Message-ID: <87a9kmway1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 13:51:50 +0300, Adrian Hunter wrote:
> Add a new parameter for 'pid' to machine__findnew_thread().
> Change callers to pass 'pid' when it is known.

I think the changelog should mention the subtlety of passing pid/tid to
prevent possible future misusages.

Thanks,
Namhyung
