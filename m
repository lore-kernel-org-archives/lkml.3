Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3GKGTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:19:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46926 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3GKGTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:19:23 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-7c-51de4e69a2f4
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [RFC 0/4] perf tools: Remove event types data
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
Date: Thu, 11 Jul 2013 15:19:20 +0900
In-Reply-To: <1373388539-9347-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Tue, 9 Jul 2013 18:48:55 +0200")
Message-ID: <87k3kxy5xz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Jul 2013 18:48:55 +0200, Jiri Olsa wrote:
> hi,
> following up on the 'perf timechart' FIXME note and changing
> its tracepoint match not to use event types data.
>
> In my tests the old and new timechart outputs look the same,
> so.. any other tester would be appreciated ;-)
>
> Also as this was the only user of the event types data
> the rest of the patchset is removing it out of the perf.
>
> The event types data are referenced from the perf data
> file header. The reference (offset & size) stays in the
> header with 0s.
>
> Also the event types data is already duplicated via the
> event_desc FEATURE, so there's no information loss.

I generally agree on removing the event_types but have a couple of
issues on patch 1.  Please see my comments on it.

Thanks,
Namhyung
