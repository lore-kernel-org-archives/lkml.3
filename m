Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3HMDfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:35:23 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61360 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3HMDfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:35:22 -0400
X-AuditID: 9c930197-b7b44ae00000347f-fa-5209a9790400
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 07/13] perf tools: remove references to struct ip_event
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
	<1376045519-13832-8-git-send-email-adrian.hunter@intel.com>
Date: Tue, 13 Aug 2013 12:35:21 +0900
In-Reply-To: <1376045519-13832-8-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Fri, 9 Aug 2013 13:51:53 +0300")
Message-ID: <871u5yw9dy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 13:51:53 +0300, Adrian Hunter wrote:
> struct ip_event assumes fixed positions for ip, pid
> and tid.  That is no longer true with the addition of
> PERF_SAMPLE_IDENTIFIER.  The information is anyway in
> struct sample, so use that instead.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
