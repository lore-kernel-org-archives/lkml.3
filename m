Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaBEBlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:41:25 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60258 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaBEBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:41:06 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-cd-52f196b0b10f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 01/22] perf tools: Fix memory leak in event_format__print function
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
	<1391377150-23920-2-git-send-email-jolsa@redhat.com>
Date: Wed, 05 Feb 2014 10:41:04 +0900
In-Reply-To: <1391377150-23920-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sun, 2 Feb 2014 22:38:49 +0100")
Message-ID: <87mwi61glr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Feb 2014 22:38:49 +0100, Jiri Olsa wrote:
> Properly destroying trace_seq object.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
