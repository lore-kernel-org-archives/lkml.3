Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaBEBkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:40:46 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63653 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaBEBko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:40:44 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-f6-52f1969a3bbf
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 00/22] perf tools: Display tracepoint enahncements
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
	<20140202214550.GA2694@krava.redhat.com>
Date: Wed, 05 Feb 2014 10:40:42 +0900
In-Reply-To: <20140202214550.GA2694@krava.redhat.com> (Jiri Olsa's message of
	"Sun, 2 Feb 2014 22:45:50 +0100")
Message-ID: <87r47i1gmd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Feb 2014 22:45:50 +0100, Jiri Olsa wrote:
> On Sun, Feb 02, 2014 at 10:38:48PM +0100, Jiri Olsa wrote:
>> hi,
>> sending out tracepoint (mostly) events display enahncements.
>
> forgot to mention.. the branch is in here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/core_tp

It's segfaulted with --group --tui option since the hpp->ptr is not
setup to point an evsel.  Not sure whose problem.. ;-)

Thanks,
Namhyung
